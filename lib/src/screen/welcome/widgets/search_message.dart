import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import './search_new_friend.dart';
import '../../../utils/utils.dart';

class SearchMessage extends StatefulWidget {
  static const routeNamed = '/search-message';
  const SearchMessage({Key? key}) : super(key: key);

  @override
  _SearchMessageState createState() => _SearchMessageState();
}

class _SearchMessageState extends State<SearchMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.search),
          ),
        ],
        title: Text(
          'Cari pesan',
          style: Constant.maitree.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () async {
                  await Navigator.pushNamed(context, SearchNewFriend.routeNamed);
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.25),
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(FeatherIcons.plus),
                      ),
                      title: Text(
                        'Teman Baru',
                        style: Constant.comfortaa.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      subtitle: Text(
                        'Cari teman baru yang belum pernah kamu chatting sebelumnya',
                        style: Constant.comfortaa.copyWith(
                          color: Colors.black.withOpacity(.5),
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: 100,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {},
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 2.0),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        'Zeffry Reynando $index',
                        style: Constant.comfortaa.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text.rich(
                        TextSpan(
                          text: 'Username : ',
                          children: [
                            TextSpan(
                              text: 'zeffry.reynando',
                              style: Constant.comfortaa.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorPallete.accentColor,
                              ),
                            ),
                          ],
                        ),
                        style: Constant.comfortaa.copyWith(
                          fontSize: 10.0,
                          color: Colors.black.withOpacity(.5),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: const CircleAvatar(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
