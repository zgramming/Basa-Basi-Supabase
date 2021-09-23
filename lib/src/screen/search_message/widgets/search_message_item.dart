import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './search_message_item_leading.dart';
import './search_message_item_subtitle.dart';
import './search_message_item_title.dart';

import '../../../network/model/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

import '../../message/message_screen.dart';

class SearchMessageItem extends ConsumerWidget {
  const SearchMessageItem({
    Key? key,
    required this.inboxes,
  }) : super(key: key);

  final List<InboxModel> inboxes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: inboxes.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final inbox = inboxes[index];
        return InkWell(
          onTap: () async {
            /// Initialize pairing;
            ref.read(pairing).state = await userExistsInHive(inbox.pairing.id);
            await GlobalNavigation.pushNamed(routeName: MessageScreen.routeNamed);
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 2.0),
              ],
            ),
            child: ListTile(
              title: SearchMessageItemTitle(inbox: inbox),
              subtitle: SearchMessageItemSubtitle(inbox: inbox),
              contentPadding: const EdgeInsets.all(12.0),
              leading: SearchMessageItemLeading(inbox: inbox),
            ),
          ),
        );
      },
    );
  }
}
