import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.loading()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    //on<AuthenticationDeleteUser>(_onAuthenticationDeleteRequested);
    _authenticationStatusStreamSubscription = _authenticationRepository
        .userAuthStatus
        .listen((status) => add(AuthenticationStatusChanged(status)));
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late final StreamSubscription<AuthenticationStatus>
      _authenticationStatusStreamSubscription;

  @override
  Future<void> close() {
    _authenticationStatusStreamSubscription.cancel();
    return super.close();
  }

  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final UserProfile _userProfile = await _userRepository.currentUser;
        return emit(_userProfile == UserProfile.empty
            ? const AuthenticationState.unauthenticated()
            : AuthenticationState.authenticated(_userProfile));
      default:
        return emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.logOut();
  }

  /*void _onAuthenticationDeleteRequested(
    AuthenticationDeleteUser event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _userRepository.deleteUserProfile();
  }*/
}
