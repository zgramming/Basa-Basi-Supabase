import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../login/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isError = false;
  String? message;

  @override
  void initState() {
    super.initState();
    ref.read(initializeSession.future).then((value) {
      final result = ref.read(SessionProvider.provider);
      log('Splashscreen Session ${result.session.toJson()}');
      if (!result.session.alreadyOnboarding) {
        GlobalNavigation.pushNamedAndRemoveUntil(
          routeName: OnboardingScreen.routeNamed,
          predicate: (route) => false,
        );
      } else if (result.session.user.id == 0) {
        GlobalNavigation.pushNamedAndRemoveUntil(
          routeName: LoginScreen.routeNamed,
          predicate: (route) => false,
        );
      } else {
        GlobalNavigation.pushNamedAndRemoveUntil(
          routeName: WelcomeScreen.routeNamed,
          predicate: (route) => false,
        );
      }
    }).onError((error, stackTrace) {
      setState(() {
        isError = true;
        message = error.toString();
      });
      log('OnErrror ${error.toString()}');
    }).catchError((error) {
      log('OnCactchError ${error.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: isError ? Text(message ?? '') : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
