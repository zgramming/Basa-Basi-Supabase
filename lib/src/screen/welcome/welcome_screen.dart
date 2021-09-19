import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './widgets/search_message.dart';
import './widgets/welcome_navbar.dart';
import '../../provider/provider.dart';
import '../account/account_screen.dart';
import '../inbox/inbox_screen.dart';
import '../story/story_screen.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('WelcomeScreen ${DateTime.now().add(const Duration(seconds: 15)).millisecondsSinceEpoch}');
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

    ref.listen<StateController<bool>>(isLoadingArchived, (loading) {
      if (loading.state) {
        GlobalFunction.showDialogLoading(context);
      } else {
        Navigator.pop(context);
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
