import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../network/model/network.dart';

class ProfileState extends Equatable {
  final ProfileModel profile;
  const ProfileState({
    this.profile = const ProfileModel(),
  });

  ProfileState setProfile(ProfileModel? value) => copyWith(profile: value);

  ProfileState setUsernameAndProfile({
    required String username,
    File? file,
  }) {
    return copyWith(
      profile: profile.copyWith(
        username: username,
        pictureProfile: file?.path,
      ),
    );
  }

  @override
  List<Object> get props => [profile];

  @override
  bool get stringify => true;

  ProfileState copyWith({
    ProfileModel? profile,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
    );
  }
}
