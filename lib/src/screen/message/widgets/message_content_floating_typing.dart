import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../utils/utils.dart';

class MessageContentFloatingTyping extends ConsumerWidget {
  const MessageContentFloatingTyping({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      bottom: 10,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: colorPallete.accentColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            'Pacarmu sedang mengetik...',
            textAlign: TextAlign.center,
            style: Constant.comfortaa.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
