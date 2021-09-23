import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';

class SearchMessageItemLeading extends StatelessWidget {
  const SearchMessageItemLeading({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  final InboxModel inbox;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        late String url;
        late ImageViewType imageViewType;
        if (inbox.pairing.pictureProfile == null ||
            (inbox.pairing.pictureProfile?.isEmpty ?? true)) {
          url = '${appConfig.urlImageAsset}/ob1.png';
          imageViewType = ImageViewType.asset;
        } else {
          url = inbox.pairing.pictureProfile ?? '';
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
          child: (inbox.pairing.pictureProfile == null ||
                  (inbox.pairing.pictureProfile?.isEmpty ?? true))
              ? Image.asset(
                  '${appConfig.urlImageAsset}/ob1.png',
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: inbox.pairing.pictureProfile ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Center(
                    child: CircleAvatar(
                      child: Icon(FeatherIcons.image),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
