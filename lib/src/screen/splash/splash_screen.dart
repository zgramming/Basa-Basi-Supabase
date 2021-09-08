import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';
import '../../provider/provider.dart';

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
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeNamed);
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
      body: Center(
        child: isError ? Text(message ?? '') : const CircularProgressIndicator(),
      ),
    );
  }
}
