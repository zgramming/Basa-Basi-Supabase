import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase/supabase.dart';

import './inbox_state.dart';
import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class InboxProvider extends StateNotifier<InboxState> {
  final SessionProvider session;
  final ProfileModel you;
  InboxProvider({
    required this.session,
    required this.you,
  }) : super(const InboxState());

  static final provider = StateNotifierProvider<InboxProvider, InboxState>(
    (ref) {
      final session = ref.watch(SessionProvider.provider.notifier);
      final you = ref.watch(SessionProvider.provider).session.user;
      return InboxProvider(session: session, you: you);
    },
  );

  Future<void> insertInbox({
    required ProfileModel pairing,
    required String inboxChannel,
    required String inboxLastMessage,
    required DateTime inboxLastMessageDate,
    required MessageStatus inboxLastMessageStatus,
    required MessageType inboxLastMessageType,
  }) async {
    /// Your inbox, it will reset total unread message to 0
    /// because you in the message page, it's not make sense if still have notification unread message
    final result = await Future.wait(
      [
        SupabaseQuery.instance.insertOrUpdateInbox(
          idUser: you.id,
          idSender: you.id,
          idPairing: pairing.id,
          inboxChannel: inboxChannel,
          inboxLastMessage: inboxLastMessage,
          inboxLastMessageDate: inboxLastMessageDate.millisecondsSinceEpoch,
          inboxLastMessageStatus: messageStatusValues[inboxLastMessageStatus] ?? '',
          inboxLastMessageType: messageTypeValues[inboxLastMessageType] ?? '',
          totalUnreadMessage: 0,
        ),
        SupabaseQuery.instance.increaseTotalUnreadMessage(
          idUser: pairing.id,
          inboxChannel: inboxChannel,
        ),
      ],
    );

    final data = List.from(result[0].data as List).first as Map<String, dynamic>;
    final inbox = InboxModel.fromJson(data);

    state = state.updateOrInsert(inbox);
  }

  Future<void> upsertArchivedInbox(List<InboxModel> values) async {
    await SupabaseQuery.instance.upsertArchiveInbox(values);
    for (final value in values) {
      upsertInbox(value);
    }
  }

  Future<void> resetUnreadMessageToZero({
    required String inboxChannel,
    required int idPairing,
  }) async {
    final result = await SupabaseQuery.instance.resetUnreadMessageToZero(
      inboxChannel: inboxChannel,
      idUser: you.id,
    );

    if (result.data != null) {
      final data = List.from(result.data as List).first as Map<String, dynamic>;
      final inbox = InboxModel.fromJson(data);
      state = state.updateOrInsert(inbox);
    }
  }

  Future<void> updateLastMessageStatusInbox({
    required int idPairing,
    required String inboxChannel,
  }) async {
    await SupabaseQuery.instance.updateLastMessageStatusInbox(
      idUser: idPairing,
      inboxChannel: inboxChannel,
    );
  }

  Future<void> _getAllInboxByIdUser(int me) async {
    final result = await SupabaseQuery.instance.getAllInboxByIdUser(me);
    addAll(result);
  }

  void upsertInbox(InboxModel value) {
    state = state.updateOrInsert(value);
  }

  void addAll(List<InboxModel> values) {
    state = state.addAll(values);
  }

  void deleteAllInbox() {
    state = state.delete();
  }
}

final getAllInbox = StreamProvider.autoDispose((ref) async* {
  final user = ref.watch(SessionProvider.provider).session.user;

  await ref.watch(InboxProvider.provider.notifier)._getAllInboxByIdUser(user.id);
  ref.watch(listenMyInbox.last);
  yield Stream.value(true);
});

final listenMyInbox = AutoDisposeStreamProvider((ref) async* {
  final user = ref.watch(SessionProvider.provider).session.user;
  final _subscribe = Constant.supabase
      .from('inbox:id_user=eq.${user.id}')
      .on(SupabaseEventTypes.all, (events) async {
    if (events.eventType == "INSERT" || events.eventType == "UPDATE") {
      /// Listen inbox [INSERT || UPDATE]

      final data = events.newRecord;

      if (data != null) {
        log('Listen My Inbox Insert/Update: ${events.eventType}');
        log('Listen My Inbox Insert/Update: ${events.newRecord}');
        final pairing = await Shared.instance.userExistsInHive(data['id_pairing'] as int);

        InboxModel inbox = const InboxModel();

        /// My own inbox
        inbox = InboxModel.fromJson(data).copyWith(user: user, pairing: pairing);

        ref.read(InboxProvider.provider.notifier).upsertInbox(inbox);
      }
    } else {
      /// Listen inbox [DELETE]
      log('Listen My Inbox DELETE: ${events.oldRecord}');

      ///
    }
  }).subscribe((event, {errorMsg}) {
    log('START LISTEN MY INBOX $event || ERROR LISTEN $errorMsg');
  });

  ref.onDispose(() {
    Constant.supabase.removeSubscription(_subscribe);
  });
});

final myPairingInbox = StateProvider.family<InboxModel, int>((ref, idPairing) {
  final inboxes = ref.watch(InboxProvider.provider).items.firstWhereOrNull((element) {
    return element.user.id == idPairing;
  });
  return inboxes ?? const InboxModel();
});

final archivedInbox = StateProvider.family<List<InboxModel>, bool?>((ref, isArchived) {
  final user = ref.watch(SessionProvider.provider).session.user;

  /// Filter inbox only user not user login
  /// Because we want only show inbox our partner
  /// Not our inbox
  final result = ref.watch(InboxProvider.provider).items.where((element) {
    /// Hanya menampilkan inbox yang idUser == [me] && idSender != [me] && lastMessageDate != null
    final query = element.user.id == user.id && element.inboxLastMessageDate != null;
    final queryArchived = element.isArchived == isArchived;

    if (isArchived != null) {
      return query && queryArchived;
    }
    return query;
  }).toList();

  result.sort((a, b) => b.inboxLastMessageDate!.compareTo(a.inboxLastMessageDate!));
  return result;
});
