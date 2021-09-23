import 'package:flutter/material.dart';

import '../../../network/model/network.dart';
import '../../../utils/utils.dart';

class SearchMessageItemTitle extends StatelessWidget {
  const SearchMessageItemTitle({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  final InboxModel inbox;

  @override
  Widget build(BuildContext context) {
    return Text(
      inbox.pairing.fullname,
      style: Constant.comfortaa.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
