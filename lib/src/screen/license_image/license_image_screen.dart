import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../utils/utils.dart';

class LicenseImageScreen extends StatelessWidget {
  const LicenseImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Sumber gambar yang kamu lihat di halaman '),
            TextSpan(
              text: 'Onboarding ',
              style: Constant.comfortaa.copyWith(
                fontWeight: FontWeight.bold,
                color: colorPallete.primaryColor,
              ),
            ),
            const TextSpan(text: 'dari '),
            TextSpan(
              text: 'Freepik ',
              style: Constant.comfortaa.copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: colorPallete.primaryColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  try {
                    await Shared.instance.openUrl('https://www.freepik.com');
                  } catch (e) {
                    GlobalFunction.showSnackBar(
                      context,
                      content: Text(e.toString()),
                      snackBarType: SnackBarType.error,
                    );
                  }
                },
            ),
            const TextSpan(text: 'dan '),
            TextSpan(
              text: 'FlatIcon ',
              style: Constant.comfortaa.copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: colorPallete.primaryColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  try {
                    await Shared.instance.openUrl('https://www.flaticon.com/');
                  } catch (e) {
                    GlobalFunction.showSnackBar(
                      context,
                      content: Text(e.toString()),
                      snackBarType: SnackBarType.error,
                    );
                  }
                },
            ),
          ],
          style: Constant.comfortaa.copyWith(fontSize: 14.0, height: 2.0),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
