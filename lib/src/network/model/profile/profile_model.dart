import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileModel extends Equatable {
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
  final String? description;
  @HiveField(7)
  final bool? isOnline;
  @HiveField(8)
  final bool? isNewUser;
  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  @HiveField(9)
  final DateTime? createdAt;
  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  @HiveField(10)
  final DateTime? updatedAt;
  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  @HiveField(11)
  final DateTime? updatedUsernameAt;
  @HiveField(12)
  final String? tokenFirebase;

  const ProfileModel({
    this.id = 0,
    this.fullname = '',
    this.email = 'zeffry.reynando@gmail.com',
    this.password = 'akutampansekali',
    this.username = '',
    this.pictureProfile,
    this.description,
    this.isOnline = false,
    this.isNewUser = true,
    this.createdAt,
    this.updatedAt,
    this.updatedUsernameAt,
    this.tokenFirebase,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      fullname,
      email,
      password,
      username,
      pictureProfile,
      description,
      isOnline,
      isNewUser,
      createdAt,
      updatedAt,
      updatedUsernameAt,
      tokenFirebase,
    ];
  }

  @override
  bool get stringify => true;

  ProfileModel copyWith({
    int? id,
    String? fullname,
    String? email,
    String? password,
    String? username,
    String? pictureProfile,
    String? description,
    bool? isOnline,
    bool? isNewUser,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? updatedUsernameAt,
    String? tokenFirebase,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      pictureProfile: pictureProfile ?? this.pictureProfile,
      description: description ?? this.description,
      isOnline: isOnline ?? this.isOnline,
      isNewUser: isNewUser ?? this.isNewUser,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedUsernameAt: updatedUsernameAt ?? this.updatedUsernameAt,
      tokenFirebase: tokenFirebase ?? this.tokenFirebase,
    );
  }
}
