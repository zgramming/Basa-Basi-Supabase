import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';
import './profile_state.dart';

class ProfileProvider extends StateNotifier<ProfileState> {
  ProfileProvider() : super(const ProfileState());
  static final provider =
      StateNotifierProvider<ProfileProvider, ProfileState>((ref) => ProfileProvider());

  final _sessionProvider = SessionProvider();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final result = await SupabaseQuery.instance.signIn(
      email: email,
      password: password,
    );

    final user = ProfileModel.fromJson(Map<String, dynamic>.from(result.data as Map));

    /// Set User Session
    await _sessionProvider.setUserSession(user);
    state = state.setUser(user);
  }

  Future<void> signUp() async {}
}
