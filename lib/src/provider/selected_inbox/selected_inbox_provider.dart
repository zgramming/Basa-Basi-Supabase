import 'package:flutter_riverpod/flutter_riverpod.dart';

import './selected_inbox_state.dart';
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
