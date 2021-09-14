import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase/supabase.dart';

import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class MessageProvider extends StateNotifier<MessageState> {
  final InboxProvider inboxProvider;
  final ProfileModel you;
  final ProfileModel theSender;

  MessageProvider({
    required this.inboxProvider,
    required this.you,
    required this.theSender,
  }) : super(const MessageState());

  static final provider = StateNotifierProvider<MessageProvider, MessageState>((ref) {
    final inboxProvider = ref.watch(InboxProvider.provider.notifier);
    final you = ref.watch(SessionProvider.provider).session.user;
    final _sender = ref.watch(sender).state;

    return MessageProvider(
      inboxProvider: inboxProvider,
      theSender: _sender!,
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
    final result = await SupabaseQuery.instance.getAllMessageByInboxChannel(
      inboxChannel,
    );
    final data = List.from(result.data as List);
    final messages =
        data.map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    state = state.addAll(messages);
    return messages;
  }

  Future<MessageModel> sendMessage({
    required MessagePost post,
  }) async {
    final now = DateTime.now();
    final inboxChannel = getConversationID(
      you: you.id ?? 0,
      senderId: post.idSender ?? 0,
    );

    final yourPost = post.copyWith(
      createdAt: now,
      messageDate: now,
      inboxChannel: inboxChannel,
      idSender: you.id,
    );

    /// Insert for your inbox
    final sendYourPost = await SupabaseQuery.instance.sendMessage(post: yourPost);

    /// After insert message
    /// Then insert to inbox
    await inboxProvider.insertInbox(
      you: you,
      sender: theSender,
      inboxChannel: inboxChannel,
      inboxLastMessage: post.messageContent ?? '',
      inboxLastMessageDate: post.messageDate ?? DateTime.now(),
      inboxLastMessageStatus: post.messageStatus,
      inboxLastMessageType: post.messageType,
    );

    state = state.add(sendYourPost);
    return sendYourPost;
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
  }).on(SupabaseEventTypes.delete, (eventDeleted) {
    log('Listen Realtime Deleted Message EventType ${eventDeleted.eventType}');
    log('Listen Realtime Deleted Message NewRecord ${eventDeleted.newRecord}');

    if (eventDeleted.oldRecord != null) {
      final MessageModel value =
          MessageModel.fromJson(Map<String, dynamic>.from(eventDeleted.oldRecord!));
      ref.read(MessageProvider.provider.notifier).deleteMessage(value.id ?? 0);
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
  }).subscribe((String event, {String? errorMsg}) {
    log('Listen Event Realtime Message: $event error: $errorMsg');
  });

  ref.onDispose(() {
    log('on dispose subscription message');
    Constant.supabase.removeSubscription(subscription);
  });
});

class MessageState extends Equatable {
  final List<MessageModel> items;
  const MessageState({
    this.items = const [],
  });

  MessageState addAll(List<MessageModel> values) => copyWith(items: [...values]);
  MessageState add(MessageModel value) {
    final result = copyWith(items: [value, ...items]).items;
    return copyWith(items: result);
  }

  MessageState update(MessageModel value) {
    items[items.indexWhere((element) => element.id == value.id)] = value;

    return copyWith(items: items);
  }

  MessageState delete(int id) =>
      copyWith(items: [...items.where((element) => element.id != id).toList()]);

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;

  MessageState copyWith({
    List<MessageModel>? items,
  }) {
    return MessageState(
      items: items ?? this.items,
    );
  }
}

final getAllMessage = StreamProvider.autoDispose((ref) {
  final user = ref.watch(SessionProvider.provider).session.user;
  final _sender = ref.watch(sender).state;

  final inboxChannel = getConversationID(
    you: user?.id ?? 0,
    senderId: _sender?.id ?? 0,
  );

  final messages = ref.watch(MessageProvider.provider.notifier)._getAllMessageByInboxChannel(
        inboxChannel,
      );

  final stream = Stream.fromFuture(messages);

  /// Listen upcoming message by inbox channel
  ref.watch(_listenMessage(inboxChannel).stream);

  return stream;
});
