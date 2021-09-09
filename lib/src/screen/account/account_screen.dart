import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './widgets/account_header.dart';
import './widgets/account_menu_item.dart';

import '../../provider/provider.dart';

import '../login/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Flexible(
            child: AccountHeader(),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                AccountMenuItem(
                  title: 'Tentang Developer',
                  onTap: () => '',
                ),
                Consumer(
                  builder: (_, ref, child) {
                    return AccountMenuItem(
                      title: 'Keluar (Developer purpose)',
                      icon: FeatherIcons.logOut,
                      backgroundColor: Colors.red,
                      onTap: () async {
                        await ref.read(ProfileProvider.provider.notifier).signOut();
                        await ref.read(SessionProvider.provider.notifier).removeUserSession();
                        await Future.delayed(Duration.zero, () {
                          Navigator.pushReplacementNamed(context, LoginScreen.routeNamed);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CopyRightVersion(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: colorPallete.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
