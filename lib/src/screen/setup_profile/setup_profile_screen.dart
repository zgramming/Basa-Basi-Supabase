import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './widgets/setup_profile_image.dart';
import './widgets/setup_profile_username_info_rules.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../welcome/welcome_screen.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/setup-profile';
  const SetupProfileScreen({Key? key}) : super(key: key);

  @override
  _SetupProfileScreenState createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _fullnameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(SessionProvider.provider).session.user;
    log('Initstate SetupProfileUser ${user?.toJson()}');
    _usernameController = TextEditingController(text: user?.username);
    _fullnameController = TextEditingController(text: user?.fullname);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullnameController.dispose();
    super.dispose();
  }

  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(SessionProvider.provider).session.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Mengatur Profile',
          style: Constant.comfortaa.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: sizes.screenHeightMinusAppBarAndStatusBar(context),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SetupProfileImage(
                          onPickImage: (file) => setState(() => _pickedImage = file),
                        ),
                        const SizedBox(height: 40),
                        TextFormFieldCustom(
                          controller: _fullnameController,
                          labelText: 'Nama Lengkap',
                          disableOutlineBorder: false,
                          activeColor: colorPallete.accentColor,
                          borderColor: Colors.black.withOpacity(.25),
                          borderFocusColor: colorPallete.accentColor,
                          padding: const EdgeInsets.all(18.0),
                          hintText: 'Masukkan Nama Lengkap',
                          textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                          validator: (value) => GlobalFunction.validateIsEmpty(value),
                        ),
                        const SizedBox(height: 20),
                        TextFormFieldCustom(
                          controller: _usernameController,
                          labelText: 'Username',
                          disableOutlineBorder: false,
                          activeColor: colorPallete.accentColor,
                          borderColor: Colors.black.withOpacity(.25),
                          borderFocusColor: colorPallete.accentColor,
                          padding: const EdgeInsets.all(18.0),
                          hintText: 'Masukkan username',
                          textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                          inputFormatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^[a-z0-9_.]+$'))
                          ],
                          validator: (value) => GlobalFunction.validateIsEmpty(value),
                        ),
                        const SizedBox(height: 20),
                        const SetupProfileUsernameInfoRules(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final validate = _formKey.currentState?.validate() ?? false;
                    if (!validate) {
                      return;
                    }
                    try {
                      ref.read(isLoading).state = true;
                      final result =
                          await ref.read(ProfileProvider.provider.notifier).setupUsernameAndImage(
                                user?.idUser ?? '',
                                username: _usernameController.text,
                                fullname: _fullnameController.text,
                                file: _pickedImage,
                              );
                      await ref.read(SessionProvider.provider.notifier).setUserSession(result);
                      if (mounted) {
                        await Navigator.pushNamedAndRemoveUntil(
                          context,
                          WelcomeScreen.routeNamed,
                          (route) => false,
                        );
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
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
                  child: Text(
                    'Simpan',
                    style: Constant.comfortaa.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () async {
                    if (mounted) {
                      await Navigator.pushNamedAndRemoveUntil(
                        context,
                        WelcomeScreen.routeNamed,
                        (route) => false,
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    side: BorderSide(color: colorPallete.accentColor!),
                  ),
                  child: Text(
                    'Lewati',
                    style: Constant.comfortaa.copyWith(
                      color: colorPallete.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
