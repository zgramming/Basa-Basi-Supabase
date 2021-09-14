import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

import 'inbox_state.dart';

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
      you: you.id ?? 0,
      idSender: you.id ?? 0,
      inboxChannel: inboxChannel,
      inboxLastMessage: inboxLastMessage,
      inboxLastMessageDate: inboxLastMessageDate.millisecondsSinceEpoch,
      inboxLastMessageStatus: messageStatusValues[inboxLastMessageStatus] ?? '',
      inboxLastMessageType: messageTypeValues[inboxLastMessageType] ?? '',
      totalUnreadMessage: 100,
    );

    /// Your Partner Inbox, We should insert/update it to table Inbox
    await SupabaseQuery.instance.insertOrUpdateInbox(
      you: sender.id ?? 0,
      idSender: you.id ?? 0,
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

  void upsertInbox(InboxModel value) {
    state = state.updateOrInsert(value);
  }

  void add(InboxModel value) {
    state = state.add(value);
  }

  void addAll(List<InboxModel> values) {
    state = state.addAll(values);
  }

  void deleteAllInbox() {
    state = state.delete();
  }

  void deleteById(InboxModel value) {
    state = state.deleteById(value);
  }
}

final getAllInbox = StreamProvider.autoDispose((ref) async* {
  ///? START HIVE SECTION
  final boxProfile = Hive.box<ProfileHiveModel>(Constant.hiveKeyBoxProfile);

  ///? END HIVE SECTION

  final user = ref.watch(SessionProvider.provider).session.user;
  final future = ref.watch(InboxProvider.provider.notifier)._getInboxes(user?.id ?? 0);
  final listen = Constant.supabase
      .from("inbox:id_user=eq.${user?.id}")
      .stream()
      .order('inbox_last_message_date')
      .execute()
      .listen((events) async {
    if (events.isNotEmpty) {
      ProfileModel? sender;

      /// Check if sender exists in Hive Box
      /// if exists, we used it from local database
      /// otherwise call API
      for (final event in events) {
        if (boxProfile.containsKey(event['id_sender'])) {
          final getProfile = boxProfile.get(event['id_sender']);
          sender = const ProfileHiveModel().convertToProfileModel(getProfile);
        } else {
          sender = await SupabaseQuery.instance.getUserById(event['id_sender'] as int);
          boxProfile.put(sender.id, const ProfileHiveModel().convertFromProfileModel(sender));
        }

        final inbox = InboxModel.fromJson(event).copyWith(sender: sender);
        ref.read(InboxProvider.provider.notifier).upsertInbox(inbox);
      }
    }
  });

  ref.onDispose(() {
    ref.read(InboxProvider.provider.notifier).deleteAllInbox();
    listen.cancel();
    log('Ondispose getAllInbox Stream');
  });

  yield Stream.fromFuture(future);
});
