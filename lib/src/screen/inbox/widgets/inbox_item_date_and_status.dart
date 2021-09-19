import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class InboxItemDateAndStatus extends ConsumerWidget {
  final InboxModel inbox;
  const InboxItemDateAndStatus({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(SessionProvider.provider).session.user;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (inbox.idSender == user?.id)
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.bounceIn,
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: inbox.inboxLastMessageStatus == MessageStatus.send
                  ? Colors.grey[400]
                  : colorPallete.accentColor,
            ),
          ),
        const SizedBox(width: 5.0),
        Text(
          GlobalFunction.formatHM(inbox.inboxLastMessageDate ?? DateTime.now()),
          style: Constant.maitree.copyWith(
            fontSize: 8.0,
            color: const Color(0xFFC4C4C4),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
