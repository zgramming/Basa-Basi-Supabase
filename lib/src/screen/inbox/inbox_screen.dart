import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './widgets/inbox_archived.dart';
import './widgets/inbox_item_date_and_status.dart';
import './widgets/inbox_item_image.dart';
import './widgets/inbox_item_message.dart';
import './widgets/inbox_item_name.dart';
import './widgets/inbox_item_unread_message.dart';
import '../../network/model/network.dart';
import '../../provider/provider.dart';
import '../message/message_screen.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const InboxArchived(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Builder(
              builder: (context) {
                final _streamInbox = ref.watch(getAllInbox);
                return _streamInbox.when(
                  data: (_) {
                    final inboxes = ref.watch(InboxProvider.provider).items;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: inboxes.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final inbox = inboxes[index];
                        return InboxItem(inbox: inbox);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text(error.toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InboxItem extends ConsumerWidget {
  final InboxModel inbox;
  const InboxItem({
    Key? key,
    required this.inbox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _streamListenInbox = ref.watch(listenYourInbox(inbox.sender?.id ?? 0));
    return Column(
      children: [
        InkWell(
          onTap: () {
            ref.read(sender).state = inbox.sender;
            Navigator.pushNamed(context, MessageScreen.routeNamed);
          },
          splashColor: colorPallete.primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.0,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  InboxItemImage(inbox: inbox),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            InboxItemName(inbox: inbox),
                            InboxItemDateAndStatus(inbox: inbox),
                          ],
                        ),
                        const SizedBox(height: 10),
                        InboxItemMessage(inbox: inbox),
                        const SizedBox(height: 20),
                        InboxItemUnreadMessage(inbox: inbox),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
