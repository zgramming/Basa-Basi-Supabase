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
  InboxProvider({
    required this.session,
  }) : super(const InboxState());

  static final provider = StateNotifierProvider<InboxProvider, InboxState>(
    (ref) {
      final session = ref.watch(SessionProvider.provider.notifier);
      return InboxProvider(session: session);
    },
  );

  Future<void> insertInbox({
    required ProfileModel you,
    required ProfileModel pairing,
    required String inboxChannel,
    required String inboxLastMessage,
    required DateTime inboxLastMessageDate,
    required MessageStatus inboxLastMessageStatus,
    required MessageType inboxLastMessageType,
  }) async {
    /// Your inbox, it will reset total unread message to 0
    /// because you in the message page, it's not make sense if still have notification unread message
    await SupabaseQuery.instance.insertOrUpdateInbox(
      idUser: you.id ?? 0,
      idSender: you.id ?? 0,
      idPairing: pairing.id ?? 0,
      inboxChannel: inboxChannel,
      inboxLastMessage: inboxLastMessage,
      inboxLastMessageDate: inboxLastMessageDate.millisecondsSinceEpoch,
      inboxLastMessageStatus: messageStatusValues[inboxLastMessageStatus] ?? '',
      inboxLastMessageType: messageTypeValues[inboxLastMessageType] ?? '',
      totalUnreadMessage: 0,
    );

    /// Your Partner Inbox, We should insert/update it to table Inbox
    final result = await SupabaseQuery.instance.insertOrUpdateInbox(
      idUser: pairing.id ?? 0,
      idSender: you.id ?? 0,
      idPairing: you.id ?? 0,
      inboxChannel: inboxChannel,
      inboxLastMessage: inboxLastMessage,
      inboxLastMessageDate: inboxLastMessageDate.millisecondsSinceEpoch,
      inboxLastMessageStatus: messageStatusValues[inboxLastMessageStatus] ?? '',
      inboxLastMessageType: messageTypeValues[inboxLastMessageType] ?? '',
      totalUnreadMessage: 1,
    );

    final data = List.from(result.data as List).first as Map<String, dynamic>;
    final inbox = InboxModel.fromJson(data).copyWith(user: await userExistsInHive(pairing.id ?? 0));

    state = state.updateOrInsert(inbox);
  }

  Future<void> upsertArchivedInbox(List<InboxModel> values) async {
    await SupabaseQuery.instance.upsertArchiveInbox(values);
    for (final value in values) {
      upsertInbox(value);
    }
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

  await ref.watch(InboxProvider.provider.notifier)._getAllInboxByIdUser(user?.id ?? 0);

  yield Stream.value(true);
});

final listenInbox = AutoDisposeStreamProviderFamily<bool, int>((ref, idPairing) async* {
  final user = ref.watch(SessionProvider.provider).session.user;
  final inboxChannel = getConversationID(you: user?.id ?? 0, pairing: idPairing);

  final _subscribe = Constant.supabase
      .from('inbox:inbox_channel=eq.$inboxChannel')
      .on(SupabaseEventTypes.all, (events) async {
        if (events.eventType == "INSERT" || events.eventType == "UPDATE") {
          final data = events.newRecord;

          if (data != null) {
            log('Listen My Inbox Insert/Update: ${events.eventType}');
            log('Listen Insert/Update: ${events.newRecord}');
            final pairing = await userExistsInHive(data['id_user'] as int);

            /// Check to local database (Hive)
            /// is pairing id exists / not
            /// if exist use from local database
            /// otherwise we perform API call

            final inbox = InboxModel.fromJson(data).copyWith(user: pairing);
            log('iduser ${user?.id}\n inbox sender ${inbox.idSender}');
            // if (user?.id != inbox.idSender) {
            log('inbox Listen Sender ${inbox.idSender}');
            ref.read(InboxProvider.provider.notifier).upsertInbox(inbox);
            // }
          }
        }
      })
      .on(SupabaseEventTypes.delete, (eventDelete) {})
      .subscribe((String event, {String? errorMsg}) {
        log("Subscribe Inbox (channel : $inboxChannel)\n Event :$event \n Error $errorMsg");
      });

  ref.onDispose(() {
    Constant.supabase.removeSubscription(_subscribe);
    log('dispose Listener inbox with channel ($inboxChannel)');
  });

  yield true;
});

final myPairingInbox = StateProvider<InboxModel>((ref) {
  final _pairing = ref.watch(pairing).state;
  final inboxes = ref
      .watch(InboxProvider.provider)
      .items
      .firstWhereOrNull((element) => element.user?.id == _pairing?.id);
  return inboxes ?? const InboxModel();
});

final archivedInbox = StateProvider.family<List<InboxModel>, bool?>((ref, isArchived) {
  final user = ref.watch(SessionProvider.provider).session.user;

  /// Filter inbox only user not user login
  /// Because we want only show inbox our partner
  /// Not our inbox
  final result = ref.watch(InboxProvider.provider).items.where((element) {
    final query = element.user?.id != user?.id;
    final queryArchived = element.isArchived == isArchived;

    if (isArchived != null) {
      return query && queryArchived;
    }
    return query;
  }).toList();

  return result;
});
