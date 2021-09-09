// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    id: json['id'] as int,
    idUser: json['id_user'] as String?,
    fullname: json['fullname'] as String?,
    email: json['email'] as String,
    password: json['password'] as String,
    username: json['username'] as String?,
    pictureProfile: json['picture_profile'] as String?,
    isOnline: json['is_online'] as bool,
    isNewUser: json['is_new_user'] as bool,
    createdAt:
        GlobalFunction.fromJsonMilisecondToDateTime(json['created_at'] as int?),
    updatedAt:
        GlobalFunction.fromJsonMilisecondToDateTime(json['updated_at'] as int?),
    updatedUsernameAt: json['updated_username_at'] == null
        ? null
        : DateTime.parse(json['updated_username_at'] as String),
  );
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'fullname': instance.fullname,
      'email': instance.email,
      'password': instance.password,
      'username': instance.username,
      'picture_profile': instance.pictureProfile,
      'is_online': instance.isOnline,
      'is_new_user': instance.isNewUser,
      'created_at':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.createdAt),
      'updated_at':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.updatedAt),
      'updated_username_at': instance.updatedUsernameAt?.toIso8601String(),
    };
