import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/model/network.dart';
import 'session_state.dart';

class SessionProvider extends StateNotifier<SessionState> {
  SessionProvider() : super(const SessionState());

  static final provider =
      StateNotifierProvider<SessionProvider, SessionState>((ref) => SessionProvider());

  Future<void> setOnboardingSession({required bool value}) async {
    state = await state.setOnboardingSession(value: value);
  }

  Future<void> setDarkModeSession({required bool value}) async {
    state = await state.setDarkModeSession(value: value);
  }

  Future<void> getDarkModeSession() async {
    state = await state.getDarkModeSession();
  }

  Future<void> getOnboardingSession() async {
    state = await state.getOnboardingSession();
  }

  Future<void> setUserSession(ProfileModel user) async {
    state = await state.setUserSession(user);
  }

  Future<void> getUserSession() async {
    final result = await state.getUserSession();

    state = result;
  }

  Future<void> removeUserSession() async {
    state = await state.setUserSession(null);
  }
}

final initializeSession = FutureProvider<bool>((ref) async {
  final _sessionProvider = ref.watch(SessionProvider.provider.notifier);
  await _sessionProvider.getOnboardingSession();
  await _sessionProvider.getDarkModeSession();
  await _sessionProvider.getUserSession();

  return true;
});
