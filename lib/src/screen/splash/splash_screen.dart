import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../login/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../setup_profile/setup_profile_screen.dart';

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
        Navigator.pushReplacementNamed(context, OnboardingScreen.routeNamed);
      } else if (result.session.user == null) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeNamed);
      } else if (result.session.user != null) {
        Navigator.pushReplacementNamed(context, SetupProfileScreen.routeNamed);
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
