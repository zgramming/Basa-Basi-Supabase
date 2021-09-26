import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './src/app.dart';
import './src/network/model/network.dart';
import './src/utils/utils.dart';

Future<void> _initHive() async {
  ///? START HIVE INITIALIZE
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileModelAdapter());

  await Hive.openBox<ProfileModel>(Constant.hiveKeyBoxProfile);

  ///? END HIVE INITIALIZE
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    _initHive(),
    _initFirebase(),
    NotificationHelper.instance.init(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

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
