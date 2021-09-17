import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './widgets/message_appbar_title.dart';
import './widgets/message_content.dart';
import './widgets/message_footer.dart';

class MessageScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/message-screen';

  const MessageScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(FeatherIcons.chevronLeft),
          ),
          title: const MessageAppbarTitle(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(FeatherIcons.moreVertical),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MessageContent(),
            MessageFooter(messageController: _messageController),
          ],
        ),
      ),
    );
  }
}
