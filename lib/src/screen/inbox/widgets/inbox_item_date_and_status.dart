import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../utils/utils.dart';

class InboxItemDateAndStatus extends StatelessWidget {
  final InboxModel inbox;
  const InboxItemDateAndStatus({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: sizes.width(context) * 0.015,
            backgroundColor: const Color(0xFfC4C4C4),
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
      ),
    );
  }
}
