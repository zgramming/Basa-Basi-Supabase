import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase/supabase.dart';

import './message_state.dart';
import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class MessageProvider extends StateNotifier<MessageState> {
  final ProfileModel you;
  final ProfileModel yourPairing;
  final InboxProvider inboxProvider;

  MessageProvider({
    required this.you,
    required this.yourPairing,
    required this.inboxProvider,
  }) : super(const MessageState());

  static final provider = StateNotifierProvider<MessageProvider, MessageState>((ref) {
    final inboxProvider = ref.read(InboxProvider.provider.notifier);
    final you = ref.watch(SessionProvider.provider).session.user;
    final _pairing = ref.watch(pairing).state;

    return MessageProvider(
      you: you,
      yourPairing: _pairing,
      inboxProvider: inboxProvider,
    );
  });

  Future<void> _getAllMessageByInboxChannel(String inboxChannel) async {
    final result = await SupabaseQuery.instance.getAllMessageByInboxChannel(inboxChannel);

    if (mounted) state = state.addAll(values: result);
  }

  Future<void> sendMessage({
    // required MessagePost post,
    required String messageContent,
    required MessageStatus status,
    required MessageType type,
    required List<MessageModel> lastMessages,
    String? messageFileUrl,
  }) async {
    final now = DateTime.now();
    final inboxChannel = Shared.instance.getConversationID(
      you: you.id,
      pairing: yourPairing.id,
    );

    final post = MessagePost(
      createdAt: now,
      messageDate: now,
      inboxChannel: inboxChannel,
      idSender: you.id,
      messageContent: messageContent,
      messageFileUrl: messageFileUrl,
      messageStatus: status,
      messageType: type,
    );

    /// Insert/Update to [inbox]
    await inboxProvider.insertInbox(
      pairing: yourPairing,
      inboxChannel: inboxChannel,
      inboxLastMessage: post.messageContent ?? '',
      inboxLastMessageDate: post.messageDate ?? DateTime.now(),
      inboxLastMessageStatus: post.messageStatus,
      inboxLastMessageType: post.messageType,
    );

    /// Then Insert into [message]
    final result = await SupabaseQuery.instance.sendMessage(post: post);

    final payload = {
      'me': you,
      'last_messages': lastMessages,
    };

    await NotificationHelper.instance.sendSingleNotificationFirebase(
      yourPairing.tokenFirebase ?? '',
      title: yourPairing.fullname,
      body: post.messageContent ?? '',
      payload: json.encode(payload),
    );

    upsert(value: result);
  }

  Future<void> updateTyping() async {
    await SupabaseQuery.instance.updateTypingInbox(
      you: you.id,
      idPairing: yourPairing.id,
    );
  }

  Future<void> updateAllMessageStatusToRead({
    required int idUser,
  }) async {
    final inboxChannel = Shared.instance.getConversationID(
      you: you.id,
      pairing: yourPairing.id,
    );

    await SupabaseQuery.instance.updateIsReadMessage(
      messageStatus: MessageStatus.read,
      inboxChannel: inboxChannel,
      idUser: idUser,
    );

    _updateAllMessageStatusToRead(idUser: idUser);
  }

  void deleteMessage({
    required int id,
  }) {
    state = state.delete(id: id);
  }

  void upsert({
    required MessageModel value,
  }) {
    state = state.upsert(value: value);
  }

  void _updateAllMessageStatusToRead({
    required int idUser,
  }) {
    state = state.updateAllMessageToRead(idUser: idUser);
  }
}

final _listenMessage = StreamProvider.autoDispose.family<void, String>((ref, inboxChannel) async* {
  final user = ref.watch(SessionProvider.provider).session.user;

  final subscription = Constant.supabase
      .from('message:inbox_channel=eq.$inboxChannel')
      .on(SupabaseEventTypes.all, (events) async {
    if (events.eventType == "INSERT" || events.eventType == "UPDATE") {
      /// Listen INSERT & UPDATE mode

      log('Listen Realtime Insert/Update Event Type ${events.eventType}');
      log('Listen Realtime Insert/Update Message NewRecord ${events.newRecord}');

      if (events.newRecord != null) {
        final MessageModel value =
            MessageModel.fromJson(Map<String, dynamic>.from(events.newRecord!));

        /// Masukkan apabila partner kita mengirimkan pesan
        ref.read(MessageProvider.provider.notifier).upsert(value: value);

        /// Jika yang mengirim pesan bukan aku (berarti pairingnya), update semua message aku menjadi read
        /// Ini mengindikasikan kita berada di room yang sama, dan pasti pesan kita dibaca oleh dia
        if (user.id != value.idSender) {
          await Future.delayed(Duration.zero, () {
            ref
                .read(MessageProvider.provider.notifier)
                .updateAllMessageStatusToRead(idUser: user.id);
          });
        }
      }
    } else {
      /// Listen Delete Mode
      log('Listen Realtime Deleted Message OldRecord ${events.oldRecord}');

      if (events.oldRecord != null) {
        final MessageModel value =
            MessageModel.fromJson(Map<String, dynamic>.from(events.oldRecord!));
        ref.read(MessageProvider.provider.notifier).deleteMessage(id: value.id);
      }
    }
  }).subscribe((String event, {String? errorMsg}) {
    log('Listen Event Realtime Message: $event error: $errorMsg');
  });

  ref.onDispose(() {
    log('on dispose subscription message');
    Constant.supabase.removeSubscription(subscription);
  });
});

final getAllMessage = StreamProvider.autoDispose((ref) async* {
  final user = ref.watch(SessionProvider.provider).session.user;
  final _pairing = ref.watch(pairing).state;

  final inboxChannel = Shared.instance.getConversationID(you: user.id, pairing: _pairing.id);

  final messagesNotifier = ref.watch(MessageProvider.provider.notifier);
  final inboxNotifier = ref.watch(InboxProvider.provider.notifier);

  await Future.wait([
    /// Get all message by channel
    messagesNotifier._getAllMessageByInboxChannel(inboxChannel),

    /// update message to read
    messagesNotifier.updateAllMessageStatusToRead(idUser: _pairing.id),

    /// Reset totalUnreadMessage to 0
    inboxNotifier.resetUnreadMessageToZero(
      inboxChannel: inboxChannel,
      idPairing: _pairing.id,
    ),

    /// Update last message status your pairing to read
    inboxNotifier.updateLastMessageStatusInbox(
      idPairing: _pairing.id,
      inboxChannel: inboxChannel,
    ),
  ]);

  /// Listen upcoming message by inbox channel
  ref.watch(_listenMessage(inboxChannel).last);

  yield true;
});

final messages = StateProvider.autoDispose((ref) {
  final items = ref.watch(MessageProvider.provider).items;
  items.sort((a, b) => a.messageDate!.compareTo(b.messageDate!));

  final groupedByDate = groupBy<MessageModel, DateTime>(items, (message) {
    final date = message.messageDate ?? DateTime(1970);
    return DateTime(date.year, date.month, date.day);
  });

  return SplayTreeMap<DateTime, List<MessageModel>>.from(groupedByDate, (a, b) => b.compareTo(a));
  // return groupedByDate;
});
