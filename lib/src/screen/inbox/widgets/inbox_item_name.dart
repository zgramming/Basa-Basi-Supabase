import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class InboxItemName extends StatelessWidget {
  const InboxItemName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Zeffry Reynando',
      style: Constant.comfortaa.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
