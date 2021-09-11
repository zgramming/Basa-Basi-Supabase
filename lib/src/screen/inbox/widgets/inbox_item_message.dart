import 'package:flutter/material.dart';

import '../../../network/model/network.dart';

import '../../../utils/utils.dart';

class InboxItemMessage extends StatelessWidget {
  final InboxModel inbox;
  const InboxItemMessage({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${inbox.inboxLastMessage}',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Constant.comfortaa.copyWith(
        fontSize: 8.0,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
