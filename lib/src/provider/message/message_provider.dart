import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase/supabase.dart';

import './message_state.dart';
import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class MessageProvider extends StateNotifier<MessageState> {
  final InboxProvider inboxProvider;
  final ProfileModel you;
  final ProfileModel yourPairing;

  MessageProvider({
    required this.inboxProvider,
    required this.you,
    required this.yourPairing,
  }) : super(const MessageState());

  static final provider = StateNotifierProvider<MessageProvider, MessageState>((ref) {
    final inboxProvider = ref.watch(InboxProvider.provider.notifier);
    final you = ref.watch(SessionProvider.provider).session.user;
    final _pairing = ref.watch(pairing).state;

    return MessageProvider(
      inboxProvider: inboxProvider,
      yourPairing: _pairing!,
      you: you!,
    );
  });

  void addMessage(MessageModel value) {
    state = state.add(value);
  }

  void deleteMessage(int id) {
    state = state.delete(id);
  }

  void updateMessage(MessageModel value) {
    state = state.update(value);
  }

  Future<List<MessageModel>> _getAllMessageByInboxChannel(String inboxChannel) async {
    final result = await SupabaseQuery.instance.getAllMessageByInboxChannel(inboxChannel);

    state = state.addAll(result);
    return result;
  }

  Future<MessageModel> sendMessage({
    // required MessagePost post,
    required String messageContent,
    required MessageStatus status,
    required MessageType type,
    String? messageFileUrl,
  }) async {
    final now = DateTime.now();
    final inboxChannel = getConversationID(
      you: you.id ?? 0,
      pairing: yourPairing.id ?? 0,
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

    /// Insert for your inbox
    final result = await SupabaseQuery.instance.sendMessage(post: post);

    /// After insert message
    /// Then insert to inbox
    await inboxProvider.insertInbox(
      you: you,
      pairing: yourPairing,
      inboxChannel: inboxChannel,
      inboxLastMessage: post.messageContent ?? '',
      inboxLastMessageDate: post.messageDate ?? DateTime.now(),
      inboxLastMessageStatus: post.messageStatus,
      inboxLastMessageType: post.messageType,
    );

    state = state.add(result);
    return result;
  }

  Future<void> updateTyping() async {
    await SupabaseQuery.instance.updateTypingInbox(you.id ?? 0, yourPairing.id ?? 0);
  }
}

final _listenMessage = StreamProvider.autoDispose.family<void, String>((ref, inboxChannel) async* {
  final subscription = Constant.supabase
      .from('message:inbox_channel=eq.$inboxChannel')
      .on(SupabaseEventTypes.insert, (eventInsert) {
    log('Listen Realtime Insert Message EventType ${eventInsert.eventType}');
    log('Listen Realtime Insert Message NewRecord ${eventInsert.newRecord}');

    /// Insert Message
    if (eventInsert.newRecord != null) {
      final user = ref.watch(SessionProvider.provider).session.user;
      final MessageModel value =
          MessageModel.fromJson(Map<String, dynamic>.from(eventInsert.newRecord!));

      /// Masukkan apabila partner kita mengirimkan pesan
      if (user?.id != value.idSender) {
        ref.read(MessageProvider.provider.notifier).addMessage(value);
      }
    }
  }).on(SupabaseEventTypes.update, (eventUpdated) {
    log('Listen Realtime Updated Message EventType ${eventUpdated.eventType}');
    log('Listen Realtime Updated Message NewRecord ${eventUpdated.newRecord}');

    /// Insert Message
    if (eventUpdated.newRecord != null) {
      final MessageModel value =
          MessageModel.fromJson(Map<String, dynamic>.from(eventUpdated.newRecord!));
      final user = ref.watch(SessionProvider.provider).session.user;

      /// Masukkan apabila partner kita mengirimkan pesan
      if (user?.id != value.idSender) {
        ref.read(MessageProvider.provider.notifier).updateMessage(value);
      }
    }
  }).on(SupabaseEventTypes.delete, (eventDeleted) {
    log('Listen Realtime Deleted Message EventType ${eventDeleted.eventType}');
    log('Listen Realtime Deleted Message NewRecord ${eventDeleted.newRecord}');

    if (eventDeleted.oldRecord != null) {
      final MessageModel value =
          MessageModel.fromJson(Map<String, dynamic>.from(eventDeleted.oldRecord!));
      ref.read(MessageProvider.provider.notifier).deleteMessage(value.id ?? 0);
    }
  }).subscribe((String event, {String? errorMsg}) {
    log('Listen Event Realtime Message: $event error: $errorMsg');
  });

  ref.onDispose(() {
    log('on dispose subscription message');
    Constant.supabase.removeSubscription(subscription);
  });
});

final getAllMessage = StreamProvider.autoDispose((ref) {
  final user = ref.watch(SessionProvider.provider).session.user;
  final _pairing = ref.watch(pairing).state;

  final inboxChannel = getConversationID(
    you: user?.id ?? 0,
    pairing: _pairing?.id ?? 0,
  );

  final messages = ref.watch(MessageProvider.provider.notifier)._getAllMessageByInboxChannel(
        inboxChannel,
      );

  final stream = Stream.fromFuture(messages);

  /// Listen upcoming message by inbox channel
  ref.watch(_listenMessage(inboxChannel).stream);

  return stream;
});
