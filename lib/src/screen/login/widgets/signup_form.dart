import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../setup_profile/setup_profile_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _resetForm() {
    _emailController.clear();
    _passwordController.clear();
    _rePasswordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
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
                keyboardType: TextInputType.emailAddress,
                focusedBorderStyle: InputBorderStyle(color: colorPallete.accentColor),
                defaultBorderStyle: InputBorderStyle(color: Colors.black.withOpacity(.25)),
                activeColor: colorPallete.accentColor,
                textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                padding: const EdgeInsets.all(24.0),
                prefixIcon: const Icon(FeatherIcons.mail),
                validator: (value) {
                  String? message;
                  message = GlobalFunction.validateIsEmpty(value, 'Email tidak boleh kosong');
                  message = GlobalFunction.validateIsValidEmail(value);
                  return message;
                },
              ),
              const SizedBox(height: 20),
              TextFormFieldCustom(
                controller: _passwordController,
                hintText: 'Masukkan Password',
                disableOutlineBorder: false,
                radius: 15.0,
                focusedBorderStyle: InputBorderStyle(color: colorPallete.accentColor),
                defaultBorderStyle: InputBorderStyle(color: Colors.black.withOpacity(.25)),
                activeColor: colorPallete.accentColor,
                textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                padding: const EdgeInsets.all(24.0),
                suffixIconConfiguration: const SuffixIconConfiguration(
                  bottomPosition: 5,
                  rightPosition: 5,
                ),
                isPassword: true,
                validator: (value) {
                  return GlobalFunction.validateIsEmpty(value, 'Password tidak boleh kosong');
                },
              ),
              const SizedBox(height: 20),
              TextFormFieldCustom(
                controller: _rePasswordController,
                hintText: 'Masukkan Password Kembali',
                disableOutlineBorder: false,
                radius: 15.0,
                focusedBorderStyle: InputBorderStyle(color: colorPallete.accentColor),
                defaultBorderStyle: InputBorderStyle(color: Colors.black.withOpacity(.25)),
                activeColor: colorPallete.accentColor,
                textStyle: Constant.comfortaa.copyWith(fontSize: 14.0),
                padding: const EdgeInsets.all(24.0),
                suffixIconConfiguration: const SuffixIconConfiguration(
                  bottomPosition: 5,
                  rightPosition: 5,
                ),
                isPassword: true,
                validator: (value) {
                  return GlobalFunction.validateIsEqual(
                    value?.toLowerCase(),
                    _passwordController.text.toLowerCase(),
                    'Konfirmasi Password tidak valid',
                  );
                },
              ),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, child) => ElevatedButton(
                  onPressed: () async {
                    final validate = _formKey.currentState?.validate() ?? false;
                    log('validate $validate');
                    if (!validate) {
                      return;
                    }
                    try {
                      ref.read(isLoading).state = true;

                      final user = await ref.read(ProfileProvider.provider.notifier).signUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                      await ref.read(SessionProvider.provider.notifier).setUserSession(user);

                      _resetForm();

                      await GlobalNavigation.pushNamedAndRemoveUntil(
                        routeName: SetupProfileScreen.routeNamed,
                        predicate: (route) => false,
                      );
                    } catch (e) {
                      GlobalFunction.showSnackBar(
                        context,
                        content: Text(e.toString()),
                        snackBarType: SnackBarType.error,
                      );
                    } finally {
                      if (mounted) {
                        ref.read(isLoading).state = false;
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: Text(
                    'Daftar',
                    style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
