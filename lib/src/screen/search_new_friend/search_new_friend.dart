import 'package:flutter/material.dart';

import './widgets/search_new_friend_list.dart';
import './widgets/search_new_friend_textfield.dart';
import './widgets/search_new_friend_title_appbar.dart';

class SearchNewFriendScreen extends StatelessWidget {
  static const routeNamed = '/search-new-friend';
  const SearchNewFriendScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const SearchNewFriendTitleAppbar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          SearchNewFriendList(),
          SearchNewFriendTextField(),
        ],
      ),
    );
  }
}
