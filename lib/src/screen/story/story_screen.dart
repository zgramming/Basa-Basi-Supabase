import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: Text(
          'Coming Soon 💋💋💋',
          style: Constant.maitree.copyWith(fontWeight: FontWeight.bold, fontSize: 32.0),
        ),
      ),
    );
  }
}
