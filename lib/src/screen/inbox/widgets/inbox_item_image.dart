import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class InboxItemImage extends ConsumerWidget {
  final InboxModel inbox;
  const InboxItemImage({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectedInbox = ref.watch(SelectedInboxProvider.provider).isExists(inbox);

    final pairingInbox = ref.watch(myPairingInbox(inbox.pairing?.id ?? 0)).state;

    Widget image;
    if (inbox.pairing?.pictureProfile == null || (inbox.pairing?.pictureProfile?.isEmpty ?? true)) {
      image = Image.asset(
        '${appConfig.urlImageAsset}/ob3.png',
        fit: BoxFit.cover,
        width: 80.0,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: '${inbox.pairing?.pictureProfile}',
        fit: BoxFit.cover,
        width: 80.0,
        errorWidget: (context, url, error) => const Center(
          child: CircleAvatar(
            child: Icon(FeatherIcons.image),
          ),
        ),
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
          InkWell(
            onTap: () async {
              String url;
              ImageViewType type;
              if (inbox.pairing?.pictureProfile == null ||
                  (inbox.pairing?.pictureProfile?.isEmpty ?? true)) {
                url = '${appConfig.urlImageAsset}/ob3.png';
                type = ImageViewType.asset;
              } else {
                url = '${inbox.pairing?.pictureProfile}';
                type = ImageViewType.network;
              }
              await GlobalFunction.showDetailSingleImage(
                context,
                url: url,
                imageViewType: type,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: image,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            width: (isStillTyping(pairingInbox.lastTypingDate) || isSelectedInbox) ? 80 : 0.0,
            height: (isStillTyping(pairingInbox.lastTypingDate) || isSelectedInbox) ? 80 : 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: colorPallete.accentColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 2.0)],
              ),
              child: (isStillTyping(pairingInbox.lastTypingDate) || isSelectedInbox)
                  ? const JumpingDot(
                      numberOfDot: 3,
                      dotColor: Colors.white,
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
