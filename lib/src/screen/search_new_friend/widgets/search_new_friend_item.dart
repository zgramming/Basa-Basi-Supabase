import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../message/message_screen.dart';

class SearchNewFriendItem extends ConsumerWidget {
  const SearchNewFriendItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  final ProfileModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: () async {
          /// Initialize pairing;
          ref.read(pairing).state = user;
          await Navigator.pushNamed(
            context,
            MessageScreen.routeNamed,
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 2.0,
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              user.fullname,
              style: Constant.comfortaa.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text.rich(
              TextSpan(
                text: 'Username : ',
                children: [
                  TextSpan(
                    text: user.username,
                    style: Constant.comfortaa.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorPallete.accentColor,
                    ),
                  ),
                ],
              ),
              style: Constant.comfortaa.copyWith(
                fontSize: 10.0,
                color: Colors.black.withOpacity(.5),
              ),
            ),
            contentPadding: const EdgeInsets.all(12.0),
            leading: InkWell(
              onTap: () async {
                late String url;
                late ImageViewType imageViewType;
                if (user.pictureProfile == null || (user.pictureProfile?.isEmpty ?? true)) {
                  url = '${appConfig.urlImageAsset}/ob1.png';
                  imageViewType = ImageViewType.asset;
                } else {
                  url = user.pictureProfile!;
                  imageViewType = ImageViewType.network;
                }
                await GlobalFunction.showDetailSingleImage(
                  context,
                  url: url,
                  imageViewType: imageViewType,
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2.0,
                      color: Colors.black.withOpacity(.25),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: (user.pictureProfile == null || (user.pictureProfile?.isEmpty ?? true))
                      ? Image.asset(
                          '${appConfig.urlImageAsset}/ob1.png',
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: '${user.pictureProfile}',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Center(
                            child: CircleAvatar(
                              child: Icon(FeatherIcons.image),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
