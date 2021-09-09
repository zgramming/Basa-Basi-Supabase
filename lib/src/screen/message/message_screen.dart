import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import '../../utils/utils.dart';

class MessageScreen extends StatelessWidget {
  static const routeNamed = '/message-screen';
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FeatherIcons.chevronLeft),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              '${appConfig.urlImageAsset}/ob1.png',
              width: 30,
              height: 30.0,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Zeffry Reynando',
                  style: Constant.maitree.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online 1 jam yang lalu',
                  style: Constant.maitree.copyWith(
                    fontSize: 8.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.moreVertical),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ListView.builder(
                    itemCount: 10,
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) {
                      final isEven = index.isEven;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Align(
                          alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
                          child: Card(
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            color: isEven ? Colors.white : colorPallete.primaryColor,
                            margin: EdgeInsets.only(
                              left: isEven ? 0.0 : sizes.width(context) / 4,
                              right: isEven ? sizes.width(context) / 4 : 0.0,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "asdjksajd sajjd jsajsa jdksa jdkjsad jas dasdaskjda asdjksajd sajjd jsajsa jdksa jdkjsad jas dasdaskjda asdjksajd sajjd jsajsa jdksa jdkjsad jas dasdaskjda ",
                                    style: Constant.comfortaa.copyWith(
                                      color: isEven ? Colors.black.withOpacity(.5) : Colors.white,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (isEven) ...[
                                        Text(
                                          '20.00',
                                          style: Constant.comfortaa
                                              .copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const Icon(FeatherIcons.smile),
                                      ] else ...[
                                        const Icon(FeatherIcons.smile, color: Colors.white),
                                        Text(
                                          '20.00',
                                          style: Constant.comfortaa.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                ///TODO: Lakukan sesuatu saat ada yang mengetik
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: colorPallete.accentColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Pacarmu sedang mengetik...',
                        textAlign: TextAlign.center,
                        style: Constant.comfortaa.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: sizes.height(context) / 8,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(.25),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormFieldCustom(
                    hintText: 'Tulis Pesan...',
                    disableOutlineBorder: false,
                    radius: 60.0,
                    borderFocusColor: colorPallete.accentColor,
                    activeColor: colorPallete.accentColor,
                    borderColor: Colors.black.withOpacity(.25),
                    textStyle: Constant.comfortaa.copyWith(fontSize: 12.0),
                    padding: const EdgeInsets.all(18.0),
                    hintStyle: Constant.comfortaa.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 10.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: sizes.width(context) / 8,
                  width: sizes.width(context) / 8,
                  decoration: BoxDecoration(
                    color: colorPallete.accentColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Icon(
                    FeatherIcons.send,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
