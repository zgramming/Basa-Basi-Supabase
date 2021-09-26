import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './widgets/inbox_item.dart';

import '../../network/model/network.dart';
import '../../provider/provider.dart';

import '../inbox_archived/widgets/inbox_archived_button.dart';

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
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      /// Check setiap 3/4/5 detik apakah ada inboxes yang sedang mengetik
      /// Lalu check apakah typinginbox == tempTypingInbox (apakah isi dalam list masih sama (equal))
      final typingInboxes = ref.read(InboxProvider.provider).allInboxTyping;

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
