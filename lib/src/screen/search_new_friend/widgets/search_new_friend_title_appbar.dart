import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class SearchNewFriendTitleAppbar extends StatelessWidget {
  const SearchNewFriendTitleAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final totalSearch = ref.watch(SearchProfileProvider.provider).items.length;
        return Text.rich(
          TextSpan(
            text: '$totalSearch',
            children: [
              TextSpan(
                text: ' user ditemukan',
                style: Constant.comfortaa.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          style: Constant.maitree.copyWith(fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
