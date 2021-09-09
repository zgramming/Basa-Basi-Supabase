import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../utils/utils.dart';
import '../message/message_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
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
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 100,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MessageScreen.routeNamed);
                      },
                      splashColor: colorPallete.primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2.0,
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 80.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2.0,
                                      color: Colors.black.withOpacity(.25),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      '${appConfig.urlImageAsset}/ob3.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Zeffry Reynando',
                                          style: Constant.comfortaa.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              CircleAvatar(
                                                radius: sizes.width(context) * 0.015,
                                                backgroundColor: const Color(0xFfC4C4C4),
                                              ),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                '20.20',
                                                style: Constant.maitree.copyWith(
                                                  fontSize: 8.0,
                                                  color: const Color(0xFFC4C4C4),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Lagi dimana lu bro? udah ditungguin sama anak-anak yang lain nih...',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constant.comfortaa.copyWith(
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: colorPallete.accentColor,
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          style: Constant.comfortaa
                                              .copyWith(fontSize: 8.0, color: Colors.white),
                                          children: [
                                            TextSpan(
                                              text: '1',
                                              style: Constant.comfortaa.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(text: ' Pesan belum dibaca')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
