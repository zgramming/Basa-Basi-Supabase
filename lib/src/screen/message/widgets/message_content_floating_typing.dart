import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageContentFloatingTyping extends ConsumerStatefulWidget {
  const MessageContentFloatingTyping({Key? key}) : super(key: key);

  @override
  _MessageContentFloatingTypingState createState() => _MessageContentFloatingTypingState();
}

class _MessageContentFloatingTypingState extends ConsumerState<MessageContentFloatingTyping> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    int flag = 0;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final inbox = ref.read(myPairingInbox).state;
      final isTyping = isStillTyping(inbox.lastTypingDate);

      /// Only rebuild widget when !isTyping and flag == 0
      /// it mean avoid uncenessary rebuild
      if (!isTyping && flag == 0) {
        setState(() {});
        flag++;
      }

      /// If isTyping give flag back to 0
      if (isTyping) {
        flag = 0;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inbox = ref.watch(myPairingInbox).state;
    final isTyping = isStillTyping(inbox.lastTypingDate);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      bottom: isTyping ? 10 : -50,
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
