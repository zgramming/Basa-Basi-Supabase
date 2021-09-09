import 'package:flutter_riverpod/flutter_riverpod.dart';

import './profile_state.dart';
import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class ProfileProvider extends StateNotifier<ProfileState> {
  ProfileProvider() : super(const ProfileState());
  static final provider =
      StateNotifierProvider<ProfileProvider, ProfileState>((ref) => ProfileProvider());

  final _sessionProvider = SessionProvider();

  void setProfile(ProfileModel? value) {
    state = state.setProfile(value);
  }

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
    state = state.setProfile(user);
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final result = await SupabaseQuery.instance.signUp(email: email, password: password);
    final data = List.from(result.data as List).first;
    final user = ProfileModel.fromJson(Map<String, dynamic>.from(data as Map));

    await _sessionProvider.setUserSession(user);
    state = state.setProfile(user);
  }

  Future<void> signOut() async {
    final result = await SupabaseQuery.instance.signOut();
    if (result) {
      await _sessionProvider.removeUserSession();
      state = state.setProfile(null);
    }
  }
}
