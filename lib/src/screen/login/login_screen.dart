import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './widgets/signin_form.dart';
import './widgets/signup_form.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        GlobalFunction.showDialogLoading(context);
      } else {
        Navigator.pop(context);
      }
    });
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: sizes.screenHeightMinusStatusBar(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        '${appConfig.urlImageAsset}/logo_primary.png',
                        width: sizes.width(context) / 2.5,
                        height: sizes.width(context) / 2.5,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Ayo mulai jalin kebersamaan dengan berbincang bersama teman kamu',
                        style: Constant.comfortaa.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Container(
                  // color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => isLogin = true),
                          style: ElevatedButton.styleFrom(
                            primary: isLogin ? colorPallete.accentColor : Colors.white,
                            side: BorderSide(
                              color: isLogin ? colorPallete.accentColor! : Colors.white,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
                          ),
                          child: Text(
                            'Sign In',
                            style: Constant.comfortaa.copyWith(
                              color: isLogin ? Colors.white : colorPallete.accentColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => isLogin = false),
                          style: ElevatedButton.styleFrom(
                            primary: isLogin ? Colors.white : colorPallete.accentColor,
                            side: BorderSide(
                              color: isLogin ? Colors.white : colorPallete.accentColor!,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
                          ),
                          child: Text(
                            'Sign Up',
                            style: Constant.comfortaa.copyWith(
                              color: isLogin ? colorPallete.accentColor : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedCrossFade(
                    firstChild: const SignInForm(),
                    secondChild: const SignUpForm(),
                    crossFadeState: isLogin ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 500),
                    firstCurve: Curves.fastOutSlowIn,
                    secondCurve: Curves.fastOutSlowIn,
                  ),
                ),
                CopyRightVersion(
                  decoration: BoxDecoration(color: colorPallete.primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
