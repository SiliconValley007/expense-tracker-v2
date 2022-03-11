part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({this.userProfile = UserProfile.empty});

  final UserProfile userProfile;

  @override
  List<Object> get props => [userProfile];

  ProfileState copyWith({UserProfile? userProfile}) =>
      ProfileState(userProfile: userProfile ?? this.userProfile);
}
