import 'package:equatable/equatable.dart';

import '../../network/model/network.dart';

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
