import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../setup_profile/setup_profile_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormFieldCustom(
                controller: _emailController,
                hintText: 'Masukkan Email',
                disableOutlineBorder: false,
                radius: 15.0,
                borderFocusColor: colorPallete.accentColor,
                activeColor: colorPallete.accentColor,
                borderColor: Colors.black.withOpacity(.25),
                textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                padding: const EdgeInsets.all(24.0),
                prefixIcon: const Icon(FeatherIcons.mail),
                validator: (value) => GlobalFunction.validateIsValidEmail(value),
              ),
              const SizedBox(height: 20),
              TextFormFieldCustom(
                controller: _passwordController,
                hintText: 'Masukkan Password',
                disableOutlineBorder: false,
                radius: 15.0,
                borderFocusColor: colorPallete.accentColor,
                activeColor: colorPallete.accentColor,
                borderColor: Colors.black.withOpacity(.25),
                textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                padding: const EdgeInsets.all(24.0),
                suffixIconConfiguration: const SuffixIconConfiguration(
                  bottomPosition: 5,
                  rightPosition: 5,
                ),
                isPassword: true,
                validator: (value) =>
                    GlobalFunction.validateIsEmpty(value, 'Password tidak boleh kosong'),
              ),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      final validate = _formKey.currentState?.validate() ?? false;
                      log('validate $validate');
                      if (!validate) {
                        return;
                      }
                      try {
                        ref.read(isLoading).state = true;
                        await ref.read(ProfileProvider.provider.notifier).signIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                        if (mounted) {
                          await Navigator.pushReplacementNamed(
                            context,
                            SetupProfileScreen.routeNamed,
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: Text(
                      'Masuk',
                      style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
