import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';
import '../login/login_screen.dart';

import './widgets/account_menu_item.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: sizes.width(context) / 3,
                        height: sizes.width(context) / 3,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.asset(
                                  '${appConfig.urlImageAsset}/ob1.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: colorPallete.accentColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      FeatherIcons.edit2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Zeffry Reynando',
                    style: Constant.maitree.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                  Text(
                    'Dibuat pada 1 Januari 2020 | 6 Bulan',
                    style: Constant.maitree.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 10.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                AccountMenuItem(
                  title: 'Tentang Developer',
                  onTap: () => '',
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return AccountMenuItem(
                      title: 'Keluar (Developer purpose)',
                      icon: FeatherIcons.logOut,
                      backgroundColor: Colors.red,
                      onTap: () async {
                        await ref.read(ProfileProvider.provider.notifier).signOut();
                        Future.delayed(
                          Duration.zero,
                          () => Navigator.pushReplacementNamed(context, LoginScreen.routeNamed),
                        );
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
