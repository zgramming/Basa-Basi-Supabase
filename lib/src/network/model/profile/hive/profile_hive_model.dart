import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../network.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 0)
class ProfileHiveModel extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String fullname;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String username;
  @HiveField(5)
  final String? pictureProfile;
  @HiveField(6)
  final bool? isOnline;
  @HiveField(7)
  final bool? isNewUser;
  @HiveField(8)
  final DateTime? createdAt;
  @HiveField(9)
  final DateTime? updatedAt;
  @HiveField(10)
  final DateTime? updatedUsernameAt;

  const ProfileHiveModel({
    this.id = 0,
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
      isNewUser: profile.isNewUser,
      isOnline: profile.isOnline,
      password: profile.password,
      pictureProfile: profile.pictureProfile,
      updatedAt: profile.updatedAt,
      updatedUsernameAt: profile.updatedUsernameAt,
      username: profile.username,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      fullname,
      email,
      password,
      username,
      pictureProfile,
      isOnline,
      isNewUser,
      createdAt,
      updatedAt,
      updatedUsernameAt,
    ];
  }

  @override
  bool get stringify => true;

  ProfileHiveModel copyWith({
    int? id,
    String? fullname,
    String? email,
    String? password,
    String? username,
    String? pictureProfile,
    bool? isOnline,
    bool? isNewUser,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? updatedUsernameAt,
  }) {
    return ProfileHiveModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      pictureProfile: pictureProfile ?? this.pictureProfile,
      isOnline: isOnline ?? this.isOnline,
      isNewUser: isNewUser ?? this.isNewUser,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedUsernameAt: updatedUsernameAt ?? this.updatedUsernameAt,
    );
  }
}
