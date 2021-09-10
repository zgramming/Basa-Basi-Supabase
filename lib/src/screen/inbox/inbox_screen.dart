import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import './widgets/inbox_archived.dart';
import './widgets/inbox_item_date_and_status.dart';
import './widgets/inbox_item_image.dart';
import './widgets/inbox_item_message.dart';
import './widgets/inbox_item_name.dart';
import './widgets/inbox_item_unread_message.dart';

import '../message/message_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const InboxArchived(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 100,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const InboxItem();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InboxItem extends StatelessWidget {
  const InboxItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, MessageScreen.routeNamed),
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
                  const InboxItemImage(),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: const [
                            InboxItemName(),
                            InboxItemDateAndStatus(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const InboxItemMessage(),
                        const SizedBox(height: 20),
                        const InboxItemUnreadMessage(),
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
