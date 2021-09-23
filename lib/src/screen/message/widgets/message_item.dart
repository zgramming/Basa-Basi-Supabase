import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './message_item_content.dart';
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
    final meIsSender = user.id == message.idSender;
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
                        // if (message.isLiked ?? false) ...[
                        //   const Icon(FeatherIcons.smile, color: Colors.white),
                        //   const SizedBox(width: 10),
                        // ],
                        Row(
                          children: [
                            MessageItemDate(message: message, textColor: Colors.white),
                            const SizedBox(width: 5),
                            AnimatedContainer(
                              duration: const Duration(seconds: 2),
                              curve: Curves.bounceIn,
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: message.messageStatus == MessageStatus.send
                                    ? Colors.grey[400]
                                    : colorPallete.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        MessageItemDate(message: message),

                        // if (message.isLiked ?? false) ...[
                        //   const Icon(FeatherIcons.smile),
                        //   const SizedBox(width: 10),
                        // ],
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

class MessageItemDate extends StatelessWidget {
  const MessageItemDate({
    Key? key,
    this.textColor,
    required this.message,
  }) : super(key: key);

  final Color? textColor;

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Text(
      GlobalFunction.formatHM(message.messageDate ?? DateTime(1970)),
      textAlign: TextAlign.right,
      style: Constant.maitree.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 10.0,
        color: textColor,
      ),
    );
  }
}
