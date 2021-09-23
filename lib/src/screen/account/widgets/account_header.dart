import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../update_profile/update_profile_screen.dart';

class AccountHeader extends ConsumerWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(SessionProvider.provider).session.user;
    return Flexible(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: sizes.width(context) / 4,
              height: sizes.width(context) / 4,
              decoration: BoxDecoration(
                color: colorPallete.accentColor,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.25),
                    blurRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: (user?.pictureProfile != null || (user?.pictureProfile?.isNotEmpty ?? false))
                    ? CachedNetworkImage(
                        imageUrl: '${user?.pictureProfile}',
                        fit: BoxFit.cover,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          '${appConfig.urlImageAsset}/logo_white.png',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    user?.fullname ?? 'Zeffry Reynando Alakazam',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Constant.comfortaa.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: 'Username : ',
                      children: [
                        TextSpan(
                          text: '${user?.username}',
                          style: Constant.comfortaa.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    style: Constant.comfortaa.copyWith(
                      color: Colors.black.withOpacity(.5),
                      fontSize: 10.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: OutlinedButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, UpdateProfileScreen.routeNamed);
                      },
                      child: Text(
                        'Ubah Profile',
                        style: Constant.comfortaa.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
