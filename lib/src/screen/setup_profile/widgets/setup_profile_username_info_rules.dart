import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../utils/utils.dart';

class SetupProfileUsernameInfoRules extends StatelessWidget {
  const SetupProfileUsernameInfoRules({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: Constant.comfortaa.copyWith(
          color: Colors.black.withOpacity(.5),
          fontSize: 10.0,
        ),
        children: [
          const TextSpan(
            text: 'username mempermudah teman kamu untuk mencari kamu loh. ',
          ),
          const TextSpan(
            text: 'username bersifat ',
          ),
          TextSpan(
            text: 'unique ',
            style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text: 'dan hanya bisa diubah 1 kali saja.\n\n',
          ),
          const TextSpan(
            text: 'username hanya boleh menggunakan kombinasi ',
          ),
          TextSpan(
            text: 'huruf kecil, angka, underscore ( _ ) dan titik ( . )\n\n',
            style: Constant.comfortaa.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'Contoh : aku.tampan.sekali, aku_ganteng123, why_im_so_handsome123',
            style: Constant.comfortaa.copyWith(
              fontWeight: FontWeight.bold,
              color: colorPallete.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
