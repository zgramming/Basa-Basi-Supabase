import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

class InboxItemImage extends StatelessWidget {
  const InboxItemImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            color: Colors.black.withOpacity(.25),
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                '${appConfig.urlImageAsset}/ob3.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 0.0,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: colorPallete.accentColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 2.0)],
              ),
              child: const FittedBox(
                child: Icon(
                  FeatherIcons.moreHorizontal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
