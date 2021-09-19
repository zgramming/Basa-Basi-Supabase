import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageAppbarTitle extends ConsumerWidget {
  const MessageAppbarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _pairing = ref.watch(pairing).state;
    Widget image;
    if (_pairing?.pictureProfile == null || (_pairing?.pictureProfile?.isEmpty ?? true)) {
      image = Image.asset(
        '${appConfig.urlImageAsset}/ob1.png',
        fit: BoxFit.cover,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: '${_pairing!.pictureProfile}',
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const Center(
          child: CircleAvatar(
            child: Icon(FeatherIcons.image),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: 40.0,
          height: 40.0,
          child: ClipRRect(borderRadius: BorderRadius.circular(10.0), child: image),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _pairing?.fullname ?? '-',
              style: Constant.maitree.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Text(
            //   'Nantinya fitur tracking online',
            //   style: Constant.maitree.copyWith(
            //     fontSize: 8.0,
            //     fontWeight: FontWeight.w300,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
