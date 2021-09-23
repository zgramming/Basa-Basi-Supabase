// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
      alreadyOnboarding: json['already_onboarding'] as bool? ?? false,
      isDarkMode: json['is_dark_mode'] as bool? ?? false,
      user: json['user'] == null
          ? const ProfileModel()
          : ProfileModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'already_onboarding': instance.alreadyOnboarding,
      'is_dark_mode': instance.isDarkMode,
      'user': instance.user,
    };
