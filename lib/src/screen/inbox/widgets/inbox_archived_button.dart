import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './inbox_archived.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class InboxArchivedButton extends ConsumerWidget {
  const InboxArchivedButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalArchivedInbox = ref.watch(archivedInbox(true)).state.length;
    if (totalArchivedInbox == 0) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      child: OutlinedButton(
        onPressed: () async {
          await Navigator.pushNamed(context, InboxArchived.routeNamed);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.0),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.archive_outlined),
            Expanded(
              child: Center(
                child: Text(
                  '$totalArchivedInbox Pesan diarsipkan',
                  style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
