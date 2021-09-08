import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/model/network.dart';
import '../../utils/utils.dart';

class SessionState extends Equatable {
  final SessionModel session;

  const SessionState({
    this.session = const SessionModel(),
  });

  Future<SessionState> setOnboardingSession({
    required bool value,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(Constant.spOnboardingKey, value);
    return copyWith(session: session.copyWith(alreadyOnboarding: value));
  }

  Future<SessionState> getOnboardingSession() async {
    final sp = await SharedPreferences.getInstance();
    final getSession = sp.getBool(Constant.spOnboardingKey) ?? false;
    return copyWith(session: session.copyWith(alreadyOnboarding: getSession));
  }

  Future<SessionState> setDarkModeSession({
    required bool value,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(Constant.spDarkModeKey, value);
    return copyWith(session: session.copyWith(isDarkMode: value));
  }

  Future<SessionState> getDarkModeSession() async {
    final sp = await SharedPreferences.getInstance();
    final getSession = sp.getBool(Constant.spDarkModeKey) ?? false;
    return copyWith(session: session.copyWith(isDarkMode: getSession));
  }

  Future<SessionState> setUser(ProfileModel user) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(Constant.spUserKey, jsonEncode(user));
    return copyWith(session: session.copyWith(user: user));
  }

  Future<SessionState> getUser() async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.getString(Constant.spUserKey);
    ProfileModel? user;
    if (result == null) {
      return copyWith(session: session.copyWith(user: user));
    }

    final decode = json.decode(result) as Map;
    user = ProfileModel.fromJson(Map<String, dynamic>.from(decode));
    return copyWith(session: session.copyWith(user: user));
  }

  @override
  List<Object> get props => [session];

  @override
  bool get stringify => true;

  SessionState copyWith({
    SessionModel? session,
  }) {
    return SessionState(
      session: session ?? this.session,
    );
  }
}
