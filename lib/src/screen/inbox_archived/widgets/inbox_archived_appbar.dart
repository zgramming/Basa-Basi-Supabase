import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class InboxArchiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final totalSelectedInbox = ref.watch(SelectedInboxProvider.provider).total;
        return AppBar(
          title: Text(
            'Diarsipkan',
            style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            if (totalSelectedInbox == 0) ...[
              IconButton(
                onPressed: () {},
                icon: const Icon(FeatherIcons.search),
              ),
            ] else ...[
              IconButton(
                onPressed: () async {
                  //TODO: Lakukan query update inbox menjadi unarchived
                  try {
                    ref.read(isLoadingArchived).state = true;
                    final selectedInbox = ref
                        .read(SelectedInboxProvider.provider)
                        .items
                        .map((e) => e.copyWith(isArchived: false))
                        .toList();

                    await ref
                        .read(InboxProvider.provider.notifier)
                        .upsertArchivedInbox(selectedInbox);
                  } catch (e) {
                    GlobalFunction.showSnackBar(
                      context,
                      content: Text(e.toString()),
                      snackBarType: SnackBarType.error,
                    );
                  } finally {
                    ref.read(isLoadingArchived).state = false;
                    ref.read(SelectedInboxProvider.provider.notifier).reset();
                  }
                },
                icon: const Icon(Icons.unarchive),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
