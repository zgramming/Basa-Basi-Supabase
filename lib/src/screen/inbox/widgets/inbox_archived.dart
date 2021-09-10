import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class InboxArchived extends StatelessWidget {
  const InboxArchived({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: OutlinedButton(
        onPressed: () {},
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
                  '1 Pesan diarsipkan',
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
