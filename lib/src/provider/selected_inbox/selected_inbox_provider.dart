import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/model/network.dart';

class SelectedInboxProvider extends StateNotifier<SelectedInboxState> {
  SelectedInboxProvider() : super(const SelectedInboxState());

  static final provider = StateNotifierProvider<SelectedInboxProvider, SelectedInboxState>(
    (ref) => SelectedInboxProvider(),
  );

  void add(InboxModel value) {
    state = state.add(value);
  }

  void reset() {
    state = state.reset();
  }
}

class SelectedInboxState extends Equatable {
  final List<InboxModel> items;
  const SelectedInboxState({
    this.items = const [],
  });

  bool isExists(InboxModel value) =>
      items.firstWhereOrNull((element) => element.id == value.id) != null;

  SelectedInboxState reset() => copyWith(items: []);

  SelectedInboxState add(InboxModel value) {
    var tempList = [...items];
    final isExists = items.firstWhereOrNull((element) => element.id == value.id);
    if (isExists == null) {
      /// Insert
      tempList = [...items, value];
    } else {
      /// Delete
      tempList.removeWhere((element) => element.id == value.id);
    }

    return copyWith(items: tempList);
  }

  int get total => items.length;
  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;

  SelectedInboxState copyWith({
    List<InboxModel>? items,
  }) {
    return SelectedInboxState(
      items: items ?? this.items,
    );
  }
}
