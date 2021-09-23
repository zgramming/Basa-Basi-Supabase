import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../network/model/network.dart';
import '../../../utils/utils.dart';

class SearchMessageItemSubtitle extends StatelessWidget {
  const SearchMessageItemSubtitle({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  final InboxModel inbox;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Username : ',
        children: [
          TextSpan(
            text: inbox.pairing.username,
            style: Constant.comfortaa.copyWith(
              fontWeight: FontWeight.bold,
              color: colorPallete.accentColor,
            ),
          ),
        ],
      ),
      style: Constant.comfortaa.copyWith(
        fontSize: 10.0,
        color: Colors.black.withOpacity(.5),
      ),
    );
  }
}
