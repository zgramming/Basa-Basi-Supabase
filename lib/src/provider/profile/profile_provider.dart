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
    required String tokenFirebase,
  }) async {
    final result = await SupabaseQuery.instance.signIn(
      email: email,
      password: password,
      tokenFirebase: tokenFirebase,
    );

    /// Save Session
    await session.setUserSession(result);

    /// Set User Session
    state = state.setProfile(result);

    return result;
  }

  Future<ProfileModel> signUp({
    required String email,
    required String password,
    required String tokenFirebase,
  }) async {
    final result = await SupabaseQuery.instance.signUp(
      email: email,
      password: password,
      tokenFirebase: tokenFirebase,
    );

    /// Save Session
    await session.setUserSession(result);

    state = state.setProfile(result);
    return result;
  }

  Future<void> signOut() async {
    final result = await SupabaseQuery.instance.signOut();
    await session.removeUserSession();
    if (result) {
      ProfileModel? user;
      state = state.setProfile(user);
    }
  }

  Future<ProfileModel> updateProfile(
    int idUser, {
    String? username,
    String? fullname,
    String? description,
    required String profileUrl,
    required String oldUsername,
    File? file,
  }) async {
    final result = await SupabaseQuery.instance.updateProfile(
      idUser,
      newUsername: username,
      file: file,
      fullname: fullname,
      description: description,
      profileUrl: profileUrl,
      oldUsername: oldUsername,
    );

    /// Save Session
    await session.setUserSession(result);

    state = state.setProfile(result);
    return result;
  }

  Future<void> updateFromNewToOldUser(int idUser) async {
    final result = await SupabaseQuery.instance.updateFromNewToOldUser(idUser);
    await session.setUserSession(result);
  }
}
