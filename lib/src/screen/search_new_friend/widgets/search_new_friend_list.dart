import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './search_new_friend_item.dart';
import '../../../provider/provider.dart';

class SearchNewFriendList extends StatelessWidget {
  const SearchNewFriendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final result = ref.watch(searchUserByEmailOrUsername);
          return result.when(
            data: (_) {
              final users = ref.watch(SearchProfileProvider.provider).items;
              if (users.isEmpty) {
                return const Center(child: Text('Kosong'));
              }
              return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: users.length,
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return SearchNewFriendItem(user: user);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
          );
        },
      ),
    );
  }
}
