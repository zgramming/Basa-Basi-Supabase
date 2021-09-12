import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import '../../../utils/utils.dart';

class SearchNewFriend extends StatefulWidget {
  static const routeNamed = '/search-new-friend';
  const SearchNewFriend({Key? key}) : super(key: key);

  @override
  _SearchNewFriendState createState() => _SearchNewFriendState();
}

class _SearchNewFriendState extends State<SearchNewFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: 100,
              itemBuilder: (context, index) => InkWell(
                onTap: () {},
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(.25),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 2.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24.0),
            child: TextFormFieldCustom(
              prefixIcon: const Icon(FeatherIcons.search),
              disableOutlineBorder: false,
              hintText: 'Cari berdasarkan username atau email',
              hintStyle: Constant.comfortaa.copyWith(
                color: Colors.black.withOpacity(.5),
                fontSize: 12.0,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) => log('onsubmit $value'),
            ),
          ),
        ],
      ),
    );
  }
}
