import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './message_content_floating_typing.dart';
import './message_item.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageContent extends StatelessWidget {
  const MessageContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned.fill(
            child: Consumer(
              builder: (context, ref, child) {
                final _streamMessage = ref.watch(getAllMessage);
                return _streamMessage.when(
                  data: (_) {
                    // final messages = ref.watch(MessageProvider.provider).items;
                    final _messages = ref.watch(messages).state;
                    return ListView(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      children: _messages.entries.map((map) {
                        final date = map.key;
                        final listMessage = map.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: colorPallete.accentColor,
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                                child: Text(
                                  GlobalFunction.formatYMD(date, type: 2),
                                  style: Constant.comfortaa.copyWith(
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: listMessage.length,
                              itemBuilder: (context, index) {
                                final message = listMessage[index];
                                return MessageItem(message: message);
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    );
                    // return ListView.builder(
                    //   itemCount: messages.length,
                    //   physics: const BouncingScrollPhysics(),
                    //   reverse: true,
                    //   itemBuilder: (context, index) {
                    //     final message = messages[index];
                    //     return MessageItem(message: message);
                    //   },
                    // );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text('error $error'),
                  ),
                );
              },
            ),
          ),
          const MessageContentFloatingTyping()
        ],
      ),
    );
  }
}
