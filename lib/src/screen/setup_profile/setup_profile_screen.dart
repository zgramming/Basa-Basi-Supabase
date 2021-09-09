import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import './widgets/setup_profile_image.dart';
import './widgets/setup_profile_username_info_rules.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/setup-profile';
  const SetupProfileScreen({Key? key}) : super(key: key);

  @override
  _SetupProfileScreenState createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  late final TextEditingController _usernameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {});
    final user = ref.read(SessionProvider.provider).session.user;
    _usernameController = TextEditingController(text: user?.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(SessionProvider.provider).session.user;
    return Scaffold(
      appBar: AppBar(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SetupProfileImage(
                        onPickImage: (file) => setState(() => _pickedImage = file),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: TextFormFieldCustom(
                          controller: _usernameController,
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
                      ),
                      const SizedBox(height: 20),
                      const SetupProfileUsernameInfoRules(),
                      const SizedBox(height: 20),
                    ],
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
                      await SupabaseQuery.instance.setupProfileWhenFirstRegister(
                        user?.idUser ?? '',
                        username: _usernameController.text,
                        file: _pickedImage,
                      );
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
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(18.0)),
                  child: Text(
                    'Simpan',
                    style: Constant.comfortaa.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
