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

    state = state.addAll(result);
    return result;
  }
}

final searchUserByEmailOrUsername = AutoDisposeFutureProvider<List<ProfileModel>?>((ref) async {
  final boxProfile = Hive.box<ProfileModel>(Constant.hiveKeyBoxProfile);
  final query = ref.watch(querySearch).state;
  final user = ref.watch(SessionProvider.provider).session.user;

  if ((query?.length ?? 0) < 3) {
    return null;
  }

  ///? START HIVE SECTION

  ///? END HIVE SECTION

  final profiles = await ref.watch(SearchProfileProvider.provider.notifier).searchUsers(
        idUser: user.id,
        query: query!,
      );

  for (final profile in profiles) {
    boxProfile.put(profile.id, profile);
  }

  return profiles;
});
