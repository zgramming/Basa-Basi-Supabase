import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class InboxItemMessage extends StatelessWidget {
  const InboxItemMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Lagi dimana lu bro? udah ditungguin sama anak-anak yang lain nih...',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Constant.comfortaa.copyWith(
        fontSize: 8.0,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
