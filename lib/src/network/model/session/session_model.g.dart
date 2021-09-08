// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) {
  return SessionModel(
    alreadyOnboarding: json['already_onboarding'] as bool,
    isDarkMode: json['is_dark_mode'] as bool,
    user: json['user'] == null
        ? null
        : ProfileModel.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'already_onboarding': instance.alreadyOnboarding,
      'is_dark_mode': instance.isDarkMode,
      'user': instance.user,
    };
