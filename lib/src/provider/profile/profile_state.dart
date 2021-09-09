import 'package:equatable/equatable.dart';

import '../../network/model/network.dart';

class ProfileState extends Equatable {
  final ProfileModel profile;
  const ProfileState({
    this.profile = const ProfileModel(),
  });

  ProfileState setProfile(ProfileModel? value) => copyWith(profile: value);

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
