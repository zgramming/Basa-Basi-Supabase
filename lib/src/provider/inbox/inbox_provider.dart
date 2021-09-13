import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase/supabase.dart';

import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class InboxProvider extends StateNotifier<InboxState> {
  InboxProvider() : super(const InboxState());

  static final provider =
      StateNotifierProvider<InboxProvider, InboxState>((ref) => InboxProvider());

  Future<List<InboxModel>> _getInboxes(int idUser) async {
    final result = await SupabaseQuery.instance.getAllInboxByIdUser(idUser);
    final data = List.from(result.data as List);
    final inboxes =
        data.map((e) => InboxModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    state = state.addAll(inboxes);
    return inboxes;
  }

  Future<void> insertInbox({
    required ProfileModel you,
    required ProfileModel sender,
    required String inboxChannel,
    required String inboxLastMessage,
    required DateTime inboxLastMessageDate,
    required MessageStatus inboxLastMessageStatus,
    required MessageType inboxLastMessageType,
  }) async {
    final result = await SupabaseQuery.instance.insertOrUpdateInbox(
      you: you.id,
      idSender: sender.id,
      inboxChannel: inboxChannel,
      inboxLastMessage: inboxLastMessage,
      inboxLastMessageDate: inboxLastMessageDate.millisecondsSinceEpoch,
      inboxLastMessageStatus: messageStatusValues[inboxLastMessageStatus] ?? '',
      inboxLastMessageType: messageTypeValues[inboxLastMessageType] ?? '',
      totalUnreadMessage: 100,
    );

    await SupabaseQuery.instance.insertOrUpdateInbox(
      you: sender.id,
      idSender: you.id,
      inboxChannel: inboxChannel,
      inboxLastMessage: inboxLastMessage,
      inboxLastMessageDate: inboxLastMessageDate.millisecondsSinceEpoch,
      inboxLastMessageStatus: messageStatusValues[inboxLastMessageStatus] ?? '',
      inboxLastMessageType: messageTypeValues[inboxLastMessageType] ?? '',
      totalUnreadMessage: 100,
    );

    final data = List.from(result.data as List).first;
    final inbox = InboxModel.fromJson(Map<String, dynamic>.from(data as Map));

    state = state.updateOrInsert(inbox.copyWith(sender: sender));
  }

  void updateOrInsertInbox(InboxModel value) {
    state = state.updateOrInsert(value);
  }

  void deleteAllInbox() {
    state = state.delete();
  }
}

class InboxState extends Equatable {
  final List<InboxModel> items;
  const InboxState({
    this.items = const [],
  });

  InboxState addAll(List<InboxModel> values) => copyWith(items: [...values]);

  InboxState delete() => copyWith(items: []);

  InboxState updateOrInsert(InboxModel value) {
    final index = items.indexWhere((element) => element.id == value.id);
    final oldRecord = items.firstWhereOrNull((element) => element.id == value.id);

    /// Jika
    if (oldRecord != null) {
      items[index] = oldRecord.copyWith(
        totalUnreadMessage: value.totalUnreadMessage,
        lastTypingDate: value.lastTypingDate,
        isArchived: value.isArchived,
        deletedAt: value.deletedAt,
        inboxLastMessage: value.inboxLastMessage,
        inboxLastMessageDate: value.inboxLastMessageDate,
        inboxLastMessageStatus: value.inboxLastMessageStatus,
        inboxLastMessageType: value.inboxLastMessageType,
        isDeleted: value.isDeleted,
        updatedAt: value.updatedAt,
      );
      return copyWith(items: items);
    } else {
      return copyWith(items: [...items, value]);
    }
  }

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;

  InboxState copyWith({
    List<InboxModel>? items,
  }) {
    return InboxState(
      items: items ?? this.items,
    );
  }
}

final getAllInbox = StreamProvider.autoDispose((ref) {
  final user = ref.watch(SessionProvider.provider).session.user;
  final future = ref.watch(InboxProvider.provider.notifier)._getInboxes(user?.id ?? 0);

  return Stream.fromFuture(future);
});

final listenYourInbox = StreamProvider.family.autoDispose<bool, int>((ref, senderId) async* {
  final user = ref.read(SessionProvider.provider).session.user;
  final inboxes = ref.read(InboxProvider.provider).items;

  final inboxChannel = getConversationID(you: user?.id ?? 0, senderId: senderId);

  final subscription = Constant.supabase
      .from('inbox:inbox_channel=eq.$inboxChannel')
      .on(SupabaseEventTypes.insert, (eventInsert) {
    log('Listen Inbox Insert Type ${eventInsert.eventType}');
    log('Listen Inbox Insert NewRecord ${eventInsert.newRecord}');
    log('Listen Inbox Insert OldRecord ${eventInsert.oldRecord}');
  }).on(SupabaseEventTypes.update, (eventUpdated) {
    log('Listen Inbox Updated Type ${eventUpdated.eventType}');
    log('Listen Inbox Updated NewRecord ${eventUpdated.newRecord}');
    log('Listen Inbox Updated OldRecord ${eventUpdated.oldRecord}');
    if (eventUpdated.newRecord != null) {
      final value = InboxModel.fromJson(eventUpdated.newRecord!);

      final isExists = inboxes.firstWhereOrNull((element) => element.id == value.id);
      if (isExists != null) {
        ref.read(InboxProvider.provider.notifier).updateOrInsertInbox(value);
      }
    }
  }).on(SupabaseEventTypes.delete, (eventDeleted) {
    log('Listen Inbox Deleted Type ${eventDeleted.eventType}');
    log('Listen Inbox Deleted NewRecord ${eventDeleted.newRecord}');
    log('Listen Inbox Deleted OldRecord ${eventDeleted.oldRecord}');
  }).subscribe((String event, {String? errorMsg}) {
    log('Listen Event Realtime Inbox: $event, Channel: $inboxChannel, error: $errorMsg');
  });

  ref.onDispose(() {
    log('on dispose subscription');
    Constant.supabase.removeSubscription(subscription);
  });

  yield true;
});
