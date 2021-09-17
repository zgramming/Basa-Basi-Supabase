import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../utils/utils.dart';

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
