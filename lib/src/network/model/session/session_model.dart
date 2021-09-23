import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../network.dart';

part 'session_model.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class SessionModel extends Equatable {
  final bool alreadyOnboarding;
  final bool isDarkMode;
  final ProfileModel user;

  const SessionModel({
    this.alreadyOnboarding = false,
    this.isDarkMode = false,
    this.user = const ProfileModel(),
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  @override
  List<Object> get props => [alreadyOnboarding, isDarkMode, user];

  @override
  bool get stringify => true;

  SessionModel copyWith({
    bool? alreadyOnboarding,
    bool? isDarkMode,
    ProfileModel? user,
  }) {
    return SessionModel(
      alreadyOnboarding: alreadyOnboarding ?? this.alreadyOnboarding,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      user: user ?? this.user,
    );
  }
}
