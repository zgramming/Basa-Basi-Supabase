import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/model/network.dart';

final isLoading = StateProvider.autoDispose<bool>((ref) => false);

final isLoadingArchived = StateProvider.autoDispose<bool>((ref) => false);
final querySearch = StateProvider.autoDispose<String?>((ref) => null);

/// Keep Pairing to variable, then we can reuse it on anywhere widget
final pairing = StateProvider<ProfileModel>((ref) => const ProfileModel());
