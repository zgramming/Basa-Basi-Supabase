import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageItem extends ConsumerWidget {
  const MessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(SessionProvider.provider).session.user;
    final meIsSender = user?.id == message.idSender;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Align(
        alignment: meIsSender ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: sizes.width(context) / 1.25,
          ),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            color: meIsSender ? colorPallete.primaryColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: meIsSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  MessageItemContent(message: message, meIsSender: meIsSender),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (meIsSender) ...[
                        if (message.isLiked ?? false) ...[
                          const Icon(FeatherIcons.smile, color: Colors.white),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          GlobalFunction.formatHM(message.messageDate ?? DateTime(1970)),
                          textAlign: TextAlign.right,
                          style: Constant.maitree.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                            color: Colors.white,
                          ),
                        ),
                      ] else ...[
                        Text(
                          GlobalFunction.formatHM(message.messageDate ?? DateTime(1970)),
                          style: Constant.maitree.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        ),
                        if (message.isLiked ?? false) ...[
                          const Icon(FeatherIcons.smile),
                          const SizedBox(width: 10),
                        ],
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageItemContent extends StatelessWidget {
  const MessageItemContent({
    Key? key,
    required this.message,
    required this.meIsSender,
  }) : super(key: key);

  final MessageModel message;
  final bool meIsSender;

  @override
  Widget build(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.messageContent ?? '',
          style: Constant.comfortaa.copyWith(
            color: meIsSender ? Colors.white : Colors.black.withOpacity(.5),
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        );
      case MessageType.image:
      case MessageType.imageWithText:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                await GlobalFunction.showDetailSingleImage(context, url: message.messageFileUrl!);
              },
              child: Ink(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.5),
                      blurRadius: 2.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: '${message.messageFileUrl}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (message.messageType == MessageType.imageWithText)
              Text(
                message.messageContent ?? '',
                style: Constant.comfortaa.copyWith(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
