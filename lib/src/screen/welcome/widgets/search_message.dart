import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../message/message_screen.dart';
import '../../search_new_friend/search_new_friend.dart';

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
                  await GlobalNavigation.pushNamed(routeName: SearchNewFriendScreen.routeNamed);
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
              Consumer(
                builder: (context, ref, child) {
                  final _streamInbox = ref.watch(getAllInbox);
                  return _streamInbox.when(
                    data: (_) {
                      final inboxes = ref.watch(archivedInbox(null)).state;
                      return ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemCount: inboxes.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final inbox = inboxes[index];
                          return InkWell(
                            onTap: () async {
                              /// Initialize pairing;
                              ref.read(pairing).state = inbox.pairing;
                              await GlobalNavigation.pushNamed(routeName: MessageScreen.routeNamed);
                            },
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
                                  '${inbox.pairing?.fullname}',
                                  style: Constant.comfortaa.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text.rich(
                                  TextSpan(
                                    text: 'Username : ',
                                    children: [
                                      TextSpan(
                                        text: '${inbox.pairing?.username}',
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
                                leading: InkWell(
                                  onTap: () async {
                                    late String url;
                                    late ImageViewType imageViewType;
                                    if (inbox.pairing?.pictureProfile == null ||
                                        (inbox.pairing?.pictureProfile?.isEmpty ?? true)) {
                                      url = '${appConfig.urlImageAsset}/ob1.png';
                                      imageViewType = ImageViewType.asset;
                                    } else {
                                      url = inbox.pairing?.pictureProfile ?? '';
                                      imageViewType = ImageViewType.network;
                                    }
                                    await GlobalFunction.showDetailSingleImage(
                                      context,
                                      url: url,
                                      imageViewType: imageViewType,
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadiusDirectional.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2.0,
                                          color: Colors.black.withOpacity(.25),
                                        )
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: (inbox.pairing?.pictureProfile == null ||
                                              (inbox.pairing?.pictureProfile?.isEmpty ?? true))
                                          ? Image.asset(
                                              '${appConfig.urlImageAsset}/ob1.png',
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: inbox.pairing?.pictureProfile ?? '',
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => const Center(
                                                child: CircleAvatar(
                                                  child: Icon(FeatherIcons.image),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(
                      child: Text('Errror ${error.toString()}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
