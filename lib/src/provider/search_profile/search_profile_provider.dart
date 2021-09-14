import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import './search_profile_state.dart';
import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class SearchProfileProvider extends StateNotifier<SearchProfileState> {
  SearchProfileProvider() : super(const SearchProfileState());

  static final provider = StateNotifierProvider<SearchProfileProvider, SearchProfileState>(
    (ref) => SearchProfileProvider(),
  );

  Future<List<ProfileModel>> searchUsers({
    required int idUser,
    required String query,
  }) async {
    final result = await SupabaseQuery.instance.searchUserByEmailOrUsername(
      idUser: idUser,
      query: query,
    );
    final data = result.data as List;

    final users =
        data.map((e) => ProfileModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    state = state.addAll(users);
    return users;
  }
}

final searchUserByEmailOrUsername = AutoDisposeFutureProvider<List<ProfileModel>?>((ref) async {
  final boxProfile = Hive.box<ProfileHiveModel>(Constant.hiveKeyBoxProfile);

  final query = ref.watch(querySearch).state;
  final user = ref.watch(SessionProvider.provider).session.user;

  if ((query?.length ?? 0) < 3) {
    return null;
  }

  final profiles = await ref.watch(SearchProfileProvider.provider.notifier).searchUsers(
        idUser: user?.id ?? 0,
        query: query!,
      );

  /// We should cached profile user when success search
  /// it usefull when listening sender in inbox
  /// if sender already exists in local database (hive)
  /// then we should use from local database otherwise call API
  for (final profile in profiles) {
    if (!boxProfile.containsKey(profile.id)) {
      /// We save to local when in local database not found the sender
      boxProfile.put(profile.id, const ProfileHiveModel().convertFromProfileModel(profile));
    }
  }

  return profiles;
});
