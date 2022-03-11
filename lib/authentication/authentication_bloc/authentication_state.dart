part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    required this.authenticationStatus,
    this.userProfile = UserProfile.empty,
  });

  final AuthenticationStatus authenticationStatus;
  final UserProfile userProfile;

  const AuthenticationState.authenticated(UserProfile userProfile)
      : this._(
          authenticationStatus: AuthenticationStatus.authenticated,
          userProfile: userProfile,
        );

  const AuthenticationState.unauthenticated()
      : this._(
          authenticationStatus: AuthenticationStatus.unauthenticated,
        );

  const AuthenticationState.loading()
      : this._(
          authenticationStatus: AuthenticationStatus.loading,
        );

  @override
  List<Object> get props => [authenticationStatus, userProfile];
}
