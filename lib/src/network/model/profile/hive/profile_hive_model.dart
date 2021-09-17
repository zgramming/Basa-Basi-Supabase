import 'package:hive/hive.dart';

import '../../network.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 0)
class ProfileHiveModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String idUser;
  @HiveField(2)
  final String fullname;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String password;
  @HiveField(5)
  final String username;
  @HiveField(6)
  final String? pictureProfile;
  @HiveField(7)
  final bool isOnline;
  @HiveField(8)
  final bool isNewUser;
  @HiveField(9)
  final DateTime? createdAt;
  @HiveField(10)
  final DateTime? updatedAt;
  @HiveField(11)
  final DateTime? updatedUsernameAt;

  const ProfileHiveModel({
    this.id,
    this.idUser = '',
    this.fullname = '',
    this.email = '',
    this.password = '',
    this.username = '',
    this.pictureProfile,
    this.isOnline = false,
    this.isNewUser = false,
    this.createdAt,
    this.updatedAt,
    this.updatedUsernameAt,
  });

  ProfileHiveModel convertFromProfileModel(ProfileModel profile) {
    return ProfileHiveModel(
      id: profile.id,
      createdAt: profile.createdAt,
      email: profile.email,
      fullname: profile.fullname,
      idUser: profile.idUser,
      isNewUser: profile.isNewUser,
      isOnline: profile.isOnline,
      password: profile.password,
      pictureProfile: profile.pictureProfile,
      updatedAt: profile.updatedAt,
      updatedUsernameAt: profile.updatedUsernameAt,
      username: profile.username,
    );
  }

  ProfileModel convertToProfileModel(ProfileHiveModel profile) {
    return ProfileModel(
      id: profile.id,
      createdAt: profile.createdAt,
      email: profile.email,
      fullname: profile.fullname,
      idUser: profile.idUser,
      isNewUser: profile.isNewUser,
      isOnline: profile.isOnline,
      password: profile.password,
      pictureProfile: profile.pictureProfile,
      updatedAt: profile.updatedAt,
      updatedUsernameAt: profile.updatedUsernameAt,
      username: profile.username,
    );
  }
}
