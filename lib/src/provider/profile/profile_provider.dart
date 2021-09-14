import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import './profile_state.dart';
import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class ProfileProvider extends StateNotifier<ProfileState> {
  final SessionProvider session;

  ProfileProvider({
    required this.session,
  }) : super(const ProfileState());

  static final provider = StateNotifierProvider<ProfileProvider, ProfileState>(
    (ref) {
      final session = ref.watch(SessionProvider.provider.notifier);

      return ProfileProvider(session: session);
    },
  );

  void setProfile(ProfileModel? value) {
    state = state.setProfile(value);
  }

  Future<ProfileModel> signIn({
    required String email,
    required String password,
  }) async {
    final result = await SupabaseQuery.instance.signIn(
      email: email,
      password: password,
    );

    final user = ProfileModel.fromJson(Map<String, dynamic>.from(result.data as Map));

    /// Save Session
    await session.setUserSession(user);

    /// Set User Session
    state = state.setProfile(user);

    return user;
  }

  Future<ProfileModel> signUp({
    required String email,
    required String password,
  }) async {
    final result = await SupabaseQuery.instance.signUp(email: email, password: password);
    final data = List.from(result.data as List).first;
    final user = ProfileModel.fromJson(Map<String, dynamic>.from(data as Map));

    /// Save Session
    await session.setUserSession(user);

    state = state.setProfile(user);
    return user;
  }

  Future<void> signOut() async {
    final result = await SupabaseQuery.instance.signOut();
    await session.removeUserSession();
    if (result) {
      ProfileModel? user;
      state = state.setProfile(user);
    }
  }

  Future<ProfileModel> setupUsernameAndImage(
    String idUser, {
    String? username,
    String? fullname,
    File? file,
  }) async {
    final result = await SupabaseQuery.instance.setupProfileWhenFirstRegister(
      idUser,
      username: username,
      file: file,
      fullname: fullname,
    );
    final data = List.from(result.data as List).first;
    final user = ProfileModel.fromJson(Map<String, dynamic>.from(data as Map));

    /// Save Session
    await session.setUserSession(user);

    state = state.setProfile(user);
    return user;
  }
}
