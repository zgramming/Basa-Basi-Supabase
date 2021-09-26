// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 0;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      id: fields[0] as int,
      fullname: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
      username: fields[4] as String,
      pictureProfile: fields[5] as String?,
      description: fields[6] as String?,
      isOnline: fields[7] as bool?,
      isNewUser: fields[8] as bool?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
      updatedUsernameAt: fields[11] as DateTime?,
      tokenFirebase: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullname)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.username)
      ..writeByte(5)
      ..write(obj.pictureProfile)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.isOnline)
      ..writeByte(8)
      ..write(obj.isNewUser)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.updatedUsernameAt)
      ..writeByte(12)
      ..write(obj.tokenFirebase);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      id: json['id'] as int? ?? 0,
      fullname: json['fullname'] as String? ?? '',
      email: json['email'] as String? ?? 'zeffry.reynando@gmail.com',
      password: json['password'] as String? ?? 'akutampansekali',
      username: json['username'] as String? ?? '',
      pictureProfile: json['picture_profile'] as String?,
      description: json['description'] as String?,
      isOnline: json['is_online'] as bool? ?? false,
      isNewUser: json['is_new_user'] as bool? ?? true,
      createdAt: GlobalFunction.fromJsonMilisecondToDateTime(
          json['created_at'] as int?),
      updatedAt: GlobalFunction.fromJsonMilisecondToDateTime(
          json['updated_at'] as int?),
      updatedUsernameAt: GlobalFunction.fromJsonMilisecondToDateTime(
          json['updated_username_at'] as int?),
      tokenFirebase: json['token_firebase'] as String?,
    );

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
      'token_firebase': instance.tokenFirebase,
    };
