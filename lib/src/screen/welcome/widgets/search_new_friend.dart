import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../message/message_screen.dart';

class SearchNewFriend extends ConsumerStatefulWidget {
  static const routeNamed = '/search-new-friend';
  const SearchNewFriend({Key? key}) : super(key: key);

  @override
  _SearchNewFriendState createState() => _SearchNewFriendState();
}

class _SearchNewFriendState extends ConsumerState<SearchNewFriend> {
  final debounce = Debouncer(milliseconds: 500);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer(
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
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final result = ref.watch(searchUserByEmailOrUsername);
                return result.when(
                  data: (_) {
                    final users = ref.watch(SearchProfileProvider.provider).items;
                    if (users.isEmpty) {
                      return const Center(child: Text('Kosong'));
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: InkWell(
                            onTap: () async {
                              ref.read(sender).state = user;
                              await Navigator.pushNamed(context, MessageScreen.routeNamed);
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
                                  '${user.fullname}',
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
                                        text: '${user.username}',
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
                                    if (user.pictureProfile == null ||
                                        (user.pictureProfile?.isEmpty ?? true)) {
                                      url = '${appConfig.urlImageAsset}/ob1.png';
                                      imageViewType = ImageViewType.asset;
                                    } else {
                                      url = user.pictureProfile!;
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
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2.0,
                                          color: Colors.black.withOpacity(.25),
                                        )
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: (user.pictureProfile == null ||
                                              (user.pictureProfile?.isEmpty ?? true))
                                          ? Image.asset(
                                              '${appConfig.urlImageAsset}/ob1.png',
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: '${user.pictureProfile}',
                                              fit: BoxFit.cover,
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
                  error: (error, stackTrace) => Center(child: Text(error.toString())),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 2.0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24.0),
            child: Consumer(
              builder: (context, ref, child) => Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormFieldCustom(
                  prefixIcon: const Icon(FeatherIcons.search),
                  disableOutlineBorder: false,
                  hintText: 'Cari berdasarkan username atau email',
                  hintStyle: Constant.comfortaa.copyWith(
                    color: Colors.black.withOpacity(.5),
                    fontSize: 12.0,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    debounce.run(() {
                      if (value.length >= 3) {
                        ref.read(querySearch).state = value;
                      } else {
                        ref.read(querySearch).state = null;
                      }
                    });
                  },
                  validator: (value) {
                    final length = value?.length ?? 0;
                    if (length < 3) {
                      return 'Inputan minimal 3 karakter';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) => log('onsubmit $value'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
