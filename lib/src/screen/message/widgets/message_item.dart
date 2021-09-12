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
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: meIsSender ? colorPallete.primaryColor : Colors.white,
          margin: EdgeInsets.only(
            left: meIsSender ? sizes.width(context) / 4 : 0.0,
            right: meIsSender ? 0.0 : sizes.width(context) / 4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  message.messageContent,
                  style: Constant.comfortaa.copyWith(
                    color: meIsSender ? Colors.white : Colors.black.withOpacity(.5),
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (meIsSender) ...[
                      if (message.isLiked) const Icon(FeatherIcons.smile, color: Colors.white),
                      Text(
                        '20.00',
                        style: Constant.maitree.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ] else ...[
                      Text(
                        '20.00',
                        style: Constant.maitree.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                      ),
                      if (message.isLiked) const Icon(FeatherIcons.smile),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
