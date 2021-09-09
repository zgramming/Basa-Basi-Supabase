import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../utils/utils.dart';

class PageItem extends StatelessWidget {
  const PageItem({
    Key? key,
    required this.urlImageAsset,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final String urlImageAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: sizes.height(context) / 1.75,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: colorPallete.primaryColor,
                ),
              ),
              Positioned(
                top: sizes.statusBarHeight(context) + 20,
                right: -40,
                child: Image.asset(
                  urlImageAsset,
                  width: sizes.width(context) / 1.5,
                  height: sizes.width(context) / 1.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: Constant.maitree.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorPallete.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: Constant.comfortaa.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: colorPallete.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
