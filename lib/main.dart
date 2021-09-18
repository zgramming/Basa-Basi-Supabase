import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import './src/app.dart';
import './src/network/model/network.dart';
import './src/utils/utils.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  log('Handling a background message ${message.messageId}');
}

Future<void> _initHive() async {
  ///? START HIVE INITIALIZE
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileHiveModelAdapter());

  await Hive.openBox<ProfileHiveModel>(Constant.hiveKeyBoxProfile);
  await Hive.openBox<String>(Constant.hiveKeyBoxInbox);

  ///? END HIVE INITIALIZE
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();
  await Firebase.initializeApp();
  await _initOneSignal();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  colorPallete.configuration(
    primaryColor: const Color(0xFF0A4969),
    accentColor: const Color(0xFF00C6B2),
    monochromaticColor: const Color(0xFF3A5984),
    success: const Color(0xFF3D6C31),
    warning: const Color(0xFFF9F871),
    info: const Color(0xFF983E4C),
    error: const Color(0xFF00BBFF),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> _initOneSignal() async {
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  await OneSignal.shared.setAppId("d4a2140a-239d-4426-8edc-da100858773a");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    log("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    log('NOTIFICATION OPENED HANDLER CALLED WITH: ${result.notification.title}');
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    log('FOREGROUND HANDLER CALLED WITH: ${event.notification.title}');
  });

  OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) {
    log('SET IN APP MESSAGE CLICK HANDLER');
  });

  OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    log("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    log("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges changes) {
    log("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
    log("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
  });

  final result = await OneSignal.shared.getDeviceState();
  log('GET DEVICE STATE ${result?.userId}');
}
