import 'dart:developer';

import 'package:basa_basi_supabase/src/utils/supabase_query.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:supabase/supabase.dart';

import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';
import 'inbox_state.dart';

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
    await SupabaseQuery.instance.insertOrUpdateInbox(
      idUser: you.id ?? 0,
      idSender: you.id ?? 0,
      idPairing: pairing.id ?? 0,
      inboxChannel: inboxChannel,
      inboxLastMessage: inboxLastMessage,
      inboxLastMessageDate: inboxLastMessageDate.millisecondsSinceEpoch,
      inboxLastMessageStatus: messageStatusValues[inboxLastMessageStatus] ?? '',
      inboxLastMessageType: messageTypeValues[inboxLastMessageType] ?? '',
      totalUnreadMessage: 1,
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

    state = state.updateOrInsert(result);
  }

  Future<void> upsertArchivedInbox(List<InboxModel> values) async {
    await SupabaseQuery.instance.upsertArchiveInbox(values);
    for (final value in values) {
      state = state.updateOrInsert(value);
    }
  }

  Future<void> _getAllInboxByIdUser(int me) async {
    final result = await SupabaseQuery.instance.getAllInboxByIdUser(me);
    state = state.addAll(result);
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

  await ref.watch(InboxProvider.provider.notifier)._getAllInboxByIdUser(user?.id ?? 0);

  /// Listen Our Inbox Chatting
  final _subscribe = Constant.supabase
      .from("inbox:id_pairing=eq.${user?.id}")
      .on(SupabaseEventTypes.all, (events) async {
        if (events.eventType == "INSERT" || events.eventType == "UPDATE") {
          final data = events.newRecord;

          if (data != null) {
            log('Listen My Inbox Insert/Update: ${events.eventType}');
            log('Listen Insert/Update: ${events.newRecord}');
            ProfileModel? pairing;

            /// Check to local database (Hive)
            /// is pairing id exists / not
            /// if exist use from local database
            /// otherwise we perform API call
            if (boxProfile.containsKey(data['id_user'] as int)) {
              pairing = const ProfileHiveModel()
                  .convertToProfileModel(boxProfile.get(data['id_user'] as int));
            } else {
              await Future.delayed(Duration.zero, () async {
                final value = await SupabaseQuery.instance.getUserById(data['id_user'] as int);
                pairing = value;
                boxProfile.put(
                  data['id_user'] as int,
                  const ProfileHiveModel().convertFromProfileModel(value),
                );
              });
            }

            final inbox = InboxModel.fromJson(data).copyWith(user: pairing);
            log('inbox $inbox');
            ref.read(InboxProvider.provider.notifier).upsertInbox(inbox);
          }
        }
      })
      .on(SupabaseEventTypes.delete, (eventDelete) {})
      .subscribe((String event, {String? errorMsg}) {
        log("Subscribe Inbox Event :$event \n Error $errorMsg");
      });

  ref.onDispose(() {
    ref.read(InboxProvider.provider.notifier).deleteAllInbox();
    Constant.supabase.removeSubscription(_subscribe);
    log('dispose listener inbox');
  });

  yield Stream.value(true);
});

final myPairingInbox = StateProvider<InboxModel>((ref) {
  final _pairing = ref.watch(pairing).state;
  final inboxes = ref
      .watch(InboxProvider.provider)
      .items
      .firstWhereOrNull((element) => element.user?.id == _pairing?.id);
  return inboxes ?? const InboxModel();
});

final archivedInbox = StateProvider.family<List<InboxModel>, bool>((ref, isArchived) {
  final result = ref
      .watch(InboxProvider.provider)
      .items
      .where((element) => element.isArchived == isArchived)
      .toList();

  return result;
});
