import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';

class InboxItemImage extends StatelessWidget {
  final InboxModel inbox;
  const InboxItemImage({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (inbox.sender?.pictureProfile == null || (inbox.sender?.pictureProfile?.isEmpty ?? true)) {
      image = Image.asset(
        '${appConfig.urlImageAsset}/ob3.png',
        fit: BoxFit.cover,
        width: 80.0,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: '${inbox.sender!.pictureProfile}',
        fit: BoxFit.cover,
        width: 80.0,
      );
    }

    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            color: Colors.black.withOpacity(.25),
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: image,
            ),
          ),
          Positioned(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 0.0,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: colorPallete.accentColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 2.0)],
              ),
              child: const FittedBox(
                child: Icon(
                  FeatherIcons.moreHorizontal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
