import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import './profile_state.dart';
import '../../network/model/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class ProfileProvider extends StateNotifier<ProfileState> {
  ProfileProvider() : super(const ProfileState());
  static final provider =
      StateNotifierProvider<ProfileProvider, ProfileState>((ref) => ProfileProvider());

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

    state = state.setProfile(user);
    return user;
  }

  Future<void> signOut() async {
    final sessionProvider_ = SessionProvider();
    final result = await SupabaseQuery.instance.signOut();
    if (result) {
      log('masuk sini dong');
      ProfileModel? user;
      await sessionProvider_.removeUserSession();
      state = state.setProfile(user);
    }
  }

  Future<ProfileModel> setupUsernameAndImage(
    String idUser, {
    required String username,
    File? file,
  }) async {
    final result = await SupabaseQuery.instance.setupProfileWhenFirstRegister(
      idUser,
      username: username,
      file: file,
    );
    final data = List.from(result.data as List).first;
    final user = ProfileModel.fromJson(Map<String, dynamic>.from(data as Map));

    state = state.setProfile(user);
    return user;
  }
}
