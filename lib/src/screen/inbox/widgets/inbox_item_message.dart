import 'package:basa_basi_supabase/src/provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';

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
    return Text.rich(
      TextSpan(
        text: user?.id == inbox.idSender ? 'Kamu : ' : '',
        style: Constant.comfortaa.copyWith(
          fontWeight: FontWeight.bold,
          color: colorPallete.primaryColor,
          fontSize: 10.0,
        ),
        children: [
          TextSpan(
            text: '${inbox.inboxLastMessage}',
            style: Constant.comfortaa.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 8.0,
              color: Colors.black.withOpacity(.5),
            ),
          )
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Constant.comfortaa.copyWith(
        fontSize: 8.0,
        fontWeight: FontWeight.w300,
        height: 2,
      ),
    );
  }
}
