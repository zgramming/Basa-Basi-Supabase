import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './message_content_floating_typing.dart';
import './message_item.dart';
import '../../../provider/provider.dart';

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
                    final messages = ref.watch(MessageProvider.provider).items;
                    return ListView.builder(
                      itemCount: messages.length,
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return MessageItem(message: message);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text('error $error'),
                  ),
                );
              },
            ),
          ),

          ///TODO: Lakukan sesuatu saat ada yang mengetik
          const MessageContentFloatingTyping()
        ],
      ),
    );
  }
}
