import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:rxdart/rxdart.dart';

import './widgets/welcome_navbar.dart';

import '../../network/model/network.dart';
import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../account/account_screen.dart';
import '../inbox/inbox_screen.dart';
import '../message/message_screen.dart';
import '../search_message/search_message_screen.dart';
import '../story/story_screen.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  Shared.instance.firebaseShowNotification(event);
}

class WelcomeScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _currentIndex = 0;
  final firebaseMessaging = FirebaseMessaging.instance;

  final _items = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(icon: Icon(FeatherIcons.messageCircle), label: 'Pesan'),
    const BottomNavigationBarItem(icon: Icon(FeatherIcons.airplay), label: 'Story'),
    const BottomNavigationBarItem(icon: Icon(FeatherIcons.user), label: 'Akun'),
  ];

  final _screens = <Widget>[
    const InboxScreen(),
    const StoryScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _initListenNotification();
    _initFirebaseMessaging();
  }

  @override
  void dispose() {
    _disposeListenNotification();
    super.dispose();
  }

  void _initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((event) async {
      Shared.instance.firebaseShowNotification(event);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log('on message firebase messaging 2.onMessageOpenedApp ${event.toString()}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _initListenNotification() async {
    selectNotificationSubject = BehaviorSubject<String?>();
    didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
    NotificationHelper.instance.configureSelectNotificationSubject(
      onSelectNotification: (payload) {
        log('onselect notification : payload || $payload\n type ${payload.runtimeType}');
        final _payload = json.decode(payload);
        final map = Map<String, dynamic>.from(_payload as Map);
        final _pairing = ProfileModel.fromJson(map['me'] as Map<String, dynamic>);

        ref.read(pairing).state = _pairing;

        GlobalNavigation.pushNamed(routeName: MessageScreen.routeNamed);
      },
    );
    NotificationHelper.instance.configureDidReceiveLocalNotificationSubject(context);
  }

  void _disposeListenNotification() {
    selectNotificationSubject.close();
    didReceiveLocalNotificationSubject.close();
  }

  Future<void> _requestPermission() async {
    final result = await firebaseMessaging.requestPermission();
    if (result.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (result.authorizationStatus == AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget fab = const SizedBox();
    if (_currentIndex == 0) {
      fab = FloatingActionButton(
        onPressed: () async {
          await GlobalNavigation.pushNamed(routeName: SearchMessageScreen.routeNamed);
        },
        child: const Icon(FeatherIcons.messageCircle),
      );
    } else if (_currentIndex == 1) {
      fab = FloatingActionButton(
        onPressed: () {},
        child: const Icon(FeatherIcons.plus),
      );
    }

    ref.listen<StateController<bool>>(isLoadingArchived, (loading) {
      if (loading.state) {
        GlobalFunction.showDialogLoading(context);
      } else {
        GlobalNavigation.pop();
      }
    });

    return Scaffold(
      appBar: WelcomeNavbar(),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        showUnselectedLabels: false,
        onTap: (value) => setState(() => _currentIndex = value),
      ),
      floatingActionButton: fab,
    );
  }
}
