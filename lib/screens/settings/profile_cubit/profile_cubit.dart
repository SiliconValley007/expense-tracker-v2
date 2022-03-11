import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository(),
        super(const ProfileState()) {
    _profileStreamSubscription = _userRepository
        .getCurrentUserProfileStream(uid: _userRepository.currentUserId)
        .listen((user) => emit(state.copyWith(userProfile: user)));
  }

  final UserRepository _userRepository;
  late final StreamSubscription _profileStreamSubscription;

  @override
  Future<void> close() {
    _profileStreamSubscription.cancel();
    return super.close();
  }

  void updateUser(
          {required UserProfile userProfile, required String currentUserId}) =>
      _userRepository.updateUserProfile(userProfile: userProfile);
}
