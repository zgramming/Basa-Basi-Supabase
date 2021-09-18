import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './widgets/inbox_archived_button.dart';
import './widgets/inbox_item_date_and_status.dart';
import './widgets/inbox_item_image.dart';
import './widgets/inbox_item_message.dart';
import './widgets/inbox_item_name.dart';
import './widgets/inbox_item_unread_message.dart';
import '../../network/model/network.dart';
import '../../provider/provider.dart';
import '../message/message_screen.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({
    Key? key,
  }) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final _tempTypingInbox = <InboxModel>[];
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      /// Check setiap 3/4/5 detik apakah ada inboxes yang sedang mengetik
      final typingInboxes = ref.read(InboxProvider.provider).allInboxTyping;
      // log('typingInboxes: $typingInboxes');

      final isEqual = listEquals(typingInboxes, _tempTypingInbox);

      /// Yang Ketik (X) :: Temporary List (Z)
      /// X = 2 || Z = 0
      /// isEqual (false), X = 2 | Z = 2
      /// setState(()=> X == X)
      if (!isEqual) {
        _tempTypingInbox.replaceRange(
          0,
          (_tempTypingInbox.isEmpty) ? 0 : _tempTypingInbox.length,
          typingInboxes,
        );
        setState(() {});
        log('Refresh halaman inbox screen setiap ada yang selesai mengetik');
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
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const InboxArchivedButton(),
        Consumer(
          builder: (context, ref, child) {
            final _streamInbox = ref.watch(getAllInbox);
            return _streamInbox.when(
              data: (_) {
                final inboxes = ref.watch(archivedInbox(false)).state;
                if (inboxes.isEmpty) {
                  return SizedBox(
                    height: sizes.height(context) / 1.3,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('Nantinya pesan-pesan kamu akan bermunculan disini'),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: inboxes.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final inbox = inboxes[index];
                      return InboxItem(inbox: inbox);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
            );
          },
        ),
        const SizedBox(height: 80)
      ],
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
    final _streamListenInbox = ref.watch(listenInbox(inbox.pairing?.id ?? 0));
    return _streamListenInbox.when(
      data: (_) {
        return Column(
          children: [
            InkWell(
              onTap: () async {
                final totalSelectedInbox = ref.read(SelectedInboxProvider.provider).total;

                if (totalSelectedInbox == 0) {
                  /// Initialize pairing
                  ref.read(pairing).state = inbox.pairing;
                  await Navigator.pushNamed(
                    context,
                    MessageScreen.routeNamed,
                  );
                } else {
                  ref.read(SelectedInboxProvider.provider.notifier).add(inbox);
                }
              },
              onLongPress: () {
                ref.read(SelectedInboxProvider.provider.notifier).add(inbox);
              },
              splashColor: colorPallete.primaryColor!.withOpacity(.25),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InboxItemName(inbox: inbox),
                            const SizedBox(height: 10),
                            InboxItemMessage(inbox: inbox),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                InboxItemUnreadMessage(inbox: inbox),
                                InboxItemDateAndStatus(inbox: inbox),
                              ],
                            ),
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}
