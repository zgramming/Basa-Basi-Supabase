import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageFooter extends ConsumerStatefulWidget {
  final TextEditingController messageController;
  const MessageFooter({
    required this.messageController,
  });

  @override
  _MessageFooterState createState() => _MessageFooterState();
}

class _MessageFooterState extends ConsumerState<MessageFooter> {
  @override
  Widget build(BuildContext context) {
    final _sender = ref.watch(sender).state;
    return Ink(
      height: sizes.height(context) / 8,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Colors.black.withOpacity(.25),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormFieldCustom(
              controller: widget.messageController,
              hintText: 'Tulis Pesan...',
              disableOutlineBorder: false,
              radius: 60.0,
              borderFocusColor: colorPallete.accentColor,
              activeColor: colorPallete.accentColor,
              borderColor: Colors.black.withOpacity(.25),
              textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
              padding: const EdgeInsets.all(18.0),
              hintStyle: Constant.comfortaa.copyWith(
                fontWeight: FontWeight.w300,
                fontSize: 10.0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Consumer(
            builder: (context, ref, child) => InkWell(
              borderRadius: BorderRadius.circular(15.0),
              splashColor: Colors.black,
              onTap: () async {
                try {
                  ref.read(isLoading).state = true;

                  final data = MessagePost(
                    messageContent: widget.messageController.text,
                    idSender: _sender?.id ?? 0,
                    messageFileUrl: '',
                    messageStatus: MessageStatus.send,
                    messageType: MessageType.text,
                  );

                  /// Reset textfield
                  widget.messageController.clear();

                  await ref.read(MessageProvider.provider.notifier).sendMessage(
                        post: data,
                      );
                } catch (e) {
                  GlobalFunction.showSnackBar(
                    context,
                    content: Text(e.toString()),
                    snackBarType: SnackBarType.error,
                  );
                } finally {
                  ref.read(isLoading).state = false;
                }
              },
              child: Ink(
                height: sizes.width(context) / 8,
                width: sizes.width(context) / 8,
                decoration: BoxDecoration(
                  color: colorPallete.accentColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Icon(
                  FeatherIcons.send,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
