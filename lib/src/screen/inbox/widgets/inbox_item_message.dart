import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class InboxItemMessage extends ConsumerWidget {
  final InboxModel inbox;
  const InboxItemMessage({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(SessionProvider.provider).session.user;

    Widget messageContent = const SizedBox();
    switch (inbox.inboxLastMessageType) {
      case MessageType.text:
        messageContent = Text(
          inbox.inboxLastMessage ?? '',
          style: Constant.comfortaa.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 9.0,
            color: Colors.black.withOpacity(.5),
          ),
        );
        break;
      case MessageType.image:
      case MessageType.imageWithText:
        messageContent = Text(
          'Mengirimkan gambar 📷📷📷',
          style: Constant.comfortaa.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 9.0,
            color: Colors.black.withOpacity(.5),
          ),
        );
        break;
      case MessageType.voice:
        messageContent = Text(
          'Mengirimkan pesan suara 🎙🎙🎙',
          style: Constant.comfortaa.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 9.0,
            color: Colors.black.withOpacity(.5),
          ),
        );
        break;
      case MessageType.file:
        messageContent = Text(
          'Mengirimkan file 📁📁📁',
          style: Constant.comfortaa.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 9.0,
            color: Colors.black.withOpacity(.5),
          ),
        );
        break;
      default:
        return const SizedBox();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          user?.id == inbox.idSender ? 'Kamu : ' : '',
          style: Constant.comfortaa.copyWith(
            fontWeight: FontWeight.bold,
            color: colorPallete.primaryColor,
            fontSize: 10.0,
          ),
        ),
        Expanded(child: messageContent)
      ],
    );
  }
}
