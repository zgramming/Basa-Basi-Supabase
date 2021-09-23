import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './widgets/search_message_item.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../search_new_friend/search_new_friend.dart';

class SearchMessage extends StatelessWidget {
  static const routeNamed = '/search-message';
  const SearchMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.search),
          ),
        ],
        title: Text(
          'Cari pesan',
          style: Constant.maitree.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () async {
                  await GlobalNavigation.pushNamed(routeName: SearchNewFriendScreen.routeNamed);
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(FeatherIcons.plus),
                      ),
                      title: Text(
                        'Teman Baru',
                        style: Constant.comfortaa.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      subtitle: Text(
                        'Cari teman baru yang belum pernah kamu chatting sebelumnya',
                        style: Constant.comfortaa.copyWith(
                          color: Colors.black.withOpacity(.5),
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, child) {
                  final _streamInbox = ref.watch(getAllInbox);
                  return _streamInbox.when(
                    data: (_) {
                      final inboxes = ref.watch(archivedInbox(null)).state;
                      return SearchMessageItem(inboxes: inboxes);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(
                      child: Text('Errror ${error.toString()}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
