import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../network/model/network.dart';
import '../../provider/provider.dart';
import '../../utils/utils.dart';
import '../setup_profile/widgets/setup_profile_username_info_rules.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/update-screen';
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _usernameController;
  late final TextEditingController _fullnameController;
  late final TextEditingController _descriptionController;
  late final String? pictureProfile;
  File? _pickedImage;

  ProfileModel? user;

  @override
  void initState() {
    super.initState();
    final _user = ref.read(SessionProvider.provider).session.user;
    user = _user;

    _usernameController = TextEditingController(text: '${user?.username}');
    _fullnameController = TextEditingController(text: '${user?.fullname}');
    _descriptionController = TextEditingController(text: user?.description ?? '');
    pictureProfile = user?.pictureProfile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (pictureProfile == null || (pictureProfile?.isEmpty ?? true)) {
      image = Image.asset('${appConfig.urlImageAsset}/ob1.png', fit: BoxFit.cover);
    } else {
      image = CachedNetworkImage(imageUrl: pictureProfile!, fit: BoxFit.cover);
    }

    if (_pickedImage != null) {
      image = Image.file(_pickedImage!, fit: BoxFit.cover);
    }

    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        GlobalFunction.showDialogLoading(context);
      } else {
        Navigator.pop(context);
      }
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Edit Profile',
            style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final validate = _formKey.currentState?.validate() ?? false;

                if (!validate) {
                  return;
                }

                try {
                  ref.read(isLoading).state = true;

                  if (_pickedImage == null) {
                    final isEqual = listEquals(
                      [
                        user?.username,
                        user?.fullname,
                        user?.description,
                      ],
                      [
                        _usernameController.text,
                        _fullnameController.text,
                        _descriptionController.text,
                      ],
                    );

                    if (isEqual) {
                      throw Exception('Tidak ada perubahan');
                    }
                  }

                  await ref.read(ProfileProvider.provider.notifier).updateProfile(
                        user?.id ?? 0,
                        description: _descriptionController.text,
                        fullname: _fullnameController.text,
                        username: _usernameController.text,
                        file: _pickedImage,
                        profileUrl: user?.pictureProfile ?? '',
                        oldUsername: user?.username ?? '',
                      );

                  if (mounted) {
                    GlobalFunction.showSnackBar(
                      context,
                      content: const Text('Berhasil update profile'),
                      snackBarType: SnackBarType.success,
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  GlobalFunction.showSnackBar(
                    context,
                    content: Text(e.toString()),
                    snackBarType: SnackBarType.error,
                  );
                } finally {
                  ref.read(isLoading).state = false;
                }
              },
              icon: const Icon(FeatherIcons.check),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await uploadImage();
                      if (result != null) {
                        setState(() {
                          _pickedImage = File(result);
                        });
                      }
                    },
                    child: Center(
                      child: Container(
                        width: sizes.width(context) / 3,
                        height: sizes.width(context) / 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(blurRadius: 2.0, color: Colors.black.withOpacity(.5)),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(child: ClipOval(child: image)),
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: CircleAvatar(
                                backgroundColor: colorPallete.accentColor,
                                radius: 15,
                                child: const FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(14.0),
                                    child: Icon(
                                      FeatherIcons.edit2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    controller: _usernameController,
                    hintText: 'zeffry.reynando',
                    labelText: 'Username',
                    activeColor: colorPallete.accentColor,
                    inputFormatter: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-z0-9_.]+$'),
                      )
                    ],
                    validator: (value) => GlobalFunction.validateIsEmpty(value),
                  ),
                  const SizedBox(height: 20),
                  const SetupProfileUsernameInfoRules(),
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    controller: _fullnameController,
                    hintText: 'Zeffry, Reynando, etc...',
                    labelText: 'Nama Lengkap',
                    activeColor: colorPallete.accentColor,
                    validator: (value) => GlobalFunction.validateIsEmpty(value),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldCustom(
                    controller: _descriptionController,
                    hintText: 'Pencinta Es Teh Manis',
                    labelText: 'Deskripsi',
                    activeColor: colorPallete.accentColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
