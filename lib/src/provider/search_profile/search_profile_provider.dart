import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final query = ref.watch(querySearch).state;
  final user = ref.watch(SessionProvider.provider).session.user;

  if ((query?.length ?? 0) < 3) {
    return null;
  }

  final result = await ref.watch(SearchProfileProvider.provider.notifier).searchUsers(
        idUser: user?.id ?? 0,
        query: query!,
      );

  return result;
});

class SearchProfileState extends Equatable {
  final List<ProfileModel> items;
  const SearchProfileState({
    this.items = const [],
  });

  int get totalItems => items.length;

  SearchProfileState addAll(List<ProfileModel> values) => copyWith(items: [...values]);
  SearchProfileState reset() {
    return copyWith(items: [...items.where((element) => element.id == 0).toList()]);
  }

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;

  SearchProfileState copyWith({
    List<ProfileModel>? items,
  }) {
    return SearchProfileState(
      items: items ?? this.items,
    );
  }
}
