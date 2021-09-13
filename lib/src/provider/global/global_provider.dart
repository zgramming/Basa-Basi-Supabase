import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/model/network.dart';

final isLoading = StateProvider.autoDispose<bool>((ref) => false);

final querySearch = StateProvider.autoDispose<String?>((ref) => null);

/// Keep Sender to variable, then we can reuse it on anywhere widget
final sender = StateProvider<ProfileModel?>((ref) => null);
