import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import './widgets/search_message.dart';

import '../account/account_screen.dart';
import '../inbox/inbox_screen.dart';
import '../story/story_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;

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
  Widget build(BuildContext context) {
    Widget fab = const SizedBox();
    if (_currentIndex == 0) {
      fab = FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            SearchMessage.routeNamed,
          );
        },
        child: const Icon(FeatherIcons.messageCircle),
      );
    } else if (_currentIndex == 1) {
      fab = FloatingActionButton(
        onPressed: () {},
        child: const Icon(FeatherIcons.plus),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          '${appConfig.urlImageAsset}/logo_white.png',
          width: 40.0,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.search),
          )
        ],
      ),
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
