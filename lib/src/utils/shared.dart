import 'dart:developer';

import 'package:global_template/global_template.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import './utils.dart';
import '../network/model/network.dart';

final ImagePicker _picker = ImagePicker();
final _boxProfile = Hive.box<ProfileHiveModel>(Constant.hiveKeyBoxProfile);

String getConversationID({
  required int you,
  required int pairing,
}) {
  if (you.hashCode <= pairing.hashCode) {
    return "${you}_$pairing";
  } else {
    return "${pairing}_$you";
  }
}

String compareDateMessage(DateTime date) {
  final now = DateTime.now();
  final dateCompared = DateTime(date.year, date.month, date.day, date.hour);
  final dateNow = DateTime(now.year, now.month, now.day, date.hour);
  final diff = dateNow.difference(dateCompared).inDays;
  // log(' Compared : $dateNow - $dateCompared\ndifferent $diff');
  if (diff > 1) {
    return GlobalFunction.formatYMD(dateCompared, type: 3);
  } else if (diff > 0 && diff <= 1) {
    return 'Kemarin';
  } else {
    return 'Hari ini';
  }
}

bool isStillTyping(DateTime? lastTyping) {
  if (lastTyping != null) {
    final diff = lastTyping.add(const Duration(seconds: 5)).difference(DateTime.now()).inSeconds;
    // log('diff $diff');
    return diff >= 0;
  }
  return false;
}

Future<String?> uploadImage({ImageSource source = ImageSource.gallery}) async {
  final file = await _picker.pickImage(
    source: source,
    maxHeight: 800,
    maxWidth: 800,
  );

  if (file == null) {
    log('Tidak menemukan gambar yang dipilih');
    return null;
  }

  return file.path;
  // await Future.delayed(Duration.zero, () {
  //   Navigator.pushNamed(context, MessagePreviewImage.routeNamed, arguments: file.path);
  // });
}

Future<ProfileModel> userExistsInHive(int idUser) async {
  ProfileModel pairing = const ProfileModel();
  if (_boxProfile.containsKey(idUser)) {
    final result = _boxProfile.get(idUser) ?? const ProfileHiveModel();
    pairing = const ProfileHiveModel().convertToProfileModel(result);
  } else {
    await Future.delayed(Duration.zero, () async {
      final value = await SupabaseQuery.instance.getUserById(idUser);
      pairing = value;
      _boxProfile.put(
        idUser,
        const ProfileHiveModel().convertFromProfileModel(value),
      );
    });
  }
  return pairing;
}
