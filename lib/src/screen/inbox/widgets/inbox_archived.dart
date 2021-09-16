import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './inbox_archived_appbar.dart';
import '../../../provider/provider.dart';
import '../inbox_screen.dart';

class InboxArchived extends StatelessWidget {
  static const routeNamed = '/inbox-archived';
  const InboxArchived({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InboxArchiveAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Consumer(
          builder: (context, ref, child) {
            final inboxes = ref.watch(archivedInbox(true)).state;
            if (inboxes.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('Pesan-pesan yang kamu arsipkan akan muncul disini'),
                ),
              );
            }
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
        ),
      ),
    );
  }
}
