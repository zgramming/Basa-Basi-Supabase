import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';

import '../../../utils/utils.dart';

class InboxItemUnreadMessage extends StatelessWidget {
  final InboxModel inbox;
  const InboxItemUnreadMessage({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inbox.totalUnreadMessage == 0) {
      return const Expanded(child: SizedBox());
    }
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: colorPallete.accentColor,
          ),
          child: Text.rich(
            TextSpan(
              style: Constant.comfortaa.copyWith(fontSize: 8.0, color: Colors.white),
              children: [
                TextSpan(
                  text: '${inbox.totalUnreadMessage} pesan belum dibaca',
                  style: Constant.comfortaa.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
