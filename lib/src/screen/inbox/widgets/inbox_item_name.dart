import 'package:flutter/material.dart';

import '../../../network/model/network.dart';
import '../../../utils/utils.dart';

class InboxItemName extends StatelessWidget {
  final InboxModel inbox;
  const InboxItemName({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      inbox.pairing?.fullname ?? '-',
      style: Constant.comfortaa.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
