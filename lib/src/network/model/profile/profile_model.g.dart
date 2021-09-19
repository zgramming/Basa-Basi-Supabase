// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    id: json['id'] as int?,
    fullname: json['fullname'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    username: json['username'] as String,
    pictureProfile: json['picture_profile'] as String?,
    description: json['description'] as String?,
    isOnline: json['is_online'] as bool,
    isNewUser: json['is_new_user'] as bool,
    createdAt:
        GlobalFunction.fromJsonMilisecondToDateTime(json['created_at'] as int?),
    updatedAt:
        GlobalFunction.fromJsonMilisecondToDateTime(json['updated_at'] as int?),
    updatedUsernameAt: GlobalFunction.fromJsonMilisecondToDateTime(
        json['updated_username_at'] as int?),
  );
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'password': instance.password,
      'username': instance.username,
      'picture_profile': instance.pictureProfile,
      'description': instance.description,
      'is_online': instance.isOnline,
      'is_new_user': instance.isNewUser,
      'created_at':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.createdAt),
      'updated_at':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.updatedAt),
      'updated_username_at': GlobalFunction.toJsonMilisecondFromDateTime(
          instance.updatedUsernameAt),
    };
