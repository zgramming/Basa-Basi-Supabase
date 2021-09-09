import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import '../../../utils/utils.dart';

class AccountMenuItem extends StatelessWidget {
  final IconData? icon;
  final Color? backgroundColor;
  final String? title;
  final VoidCallback? onTap;

  const AccountMenuItem({
    Key? key,
    this.icon,
    this.backgroundColor,
    this.title,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        margin: const EdgeInsets.only(bottom: 14.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (backgroundColor ?? colorPallete.accentColor)!.withOpacity(.25),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Icon(
                  icon ?? FeatherIcons.smile,
                  color: backgroundColor ?? colorPallete.accentColor,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title ?? 'Default Title',
                style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Icon(Icons.chevron_right),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
