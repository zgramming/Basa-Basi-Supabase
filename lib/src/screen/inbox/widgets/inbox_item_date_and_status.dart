import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../utils/utils.dart';

class InboxItemDateAndStatus extends StatelessWidget {
  const InboxItemDateAndStatus({
    Key? key,
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
            '20.20',
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
