import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './widgets/account_header.dart';
import './widgets/account_menu_item.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../about_developer/about_developer_screen.dart';
import '../license_image/license_image_screen.dart';
import '../login/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AccountHeader(),
          Expanded(
            flex: 2,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                AccountMenuItem(
                  title: 'Tentang Developer',
                  onTap: () async {
                    await GlobalNavigation.pushNamed(routeName: AboutDeveloperScreen.routeNamed);
                  },
                ),
                AccountMenuItem(
                  title: 'Lisensi Gambar',
                  icon: FeatherIcons.image,
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return const LicenseImageScreen();
                      },
                    );
                  },
                ),
                // Consumer(
                //   builder: (_, ref, child) {
                //     return AccountMenuItem(
                //       title: 'Keluar (Developer purpose)',
                //       icon: FeatherIcons.logOut,
                //       backgroundColor: Colors.red,
                //       onTap: () async {
                //         await ref.read(ProfileProvider.provider.notifier).signOut();
                //         await GlobalNavigation.pushNamedAndRemoveUntil(
                //           routeName: LoginScreen.routeNamed,
                //           predicate: (route) => false,
                //         );
                //       },
                //     );
                //   },
                // ),
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
