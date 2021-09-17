import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileModel extends Equatable {
  final int? id;
  final String idUser;
  final String fullname;
  final String email;
  final String password;
  final String username;
  final String? pictureProfile;
  final String? description;
  final bool isOnline;
  final bool isNewUser;
  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  final DateTime? createdAt;
  @JsonKey(
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
  )
  final DateTime? updatedAt;
  final DateTime? updatedUsernameAt;

  const ProfileModel({
    this.id = 0,
    this.idUser = '',
    this.fullname = '',
    this.email = 'zeffry.reynando@gmail.com',
    this.password = 'akutampansekali',
    this.username = '',
    this.pictureProfile,
    this.description,
    this.isOnline = false,
    this.isNewUser = false,
    this.createdAt,
    this.updatedAt,
    this.updatedUsernameAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      idUser,
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
    ];
  }

  @override
  bool get stringify => true;

  ProfileModel copyWith({
    int? id,
    String? idUser,
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
  }) {
    return ProfileModel(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
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
    );
  }
}
