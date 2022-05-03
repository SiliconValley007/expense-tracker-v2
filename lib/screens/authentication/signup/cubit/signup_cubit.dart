import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

import '../../../../constants/constants.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const SignupState());

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  void emailChanged({required String value}) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
          state.name,
        ]),
      ),
    );
  }

  void passwordChanged({required String value}) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([
          state.email,
          password,
          state.name,
        ]),
      ),
    );
  }

  void nameChanged({required String value}) {
    final name = Name.dirty(value);
    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([
          state.email,
          state.password,
          name,
        ]),
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final User? _newUser = await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      UserProfile _newUserProfile = _newUser == null
          ? UserProfile.empty
          : FirebaseUsertoUserProfile(_newUser).toUser;
      if (_newUserProfile != UserProfile.empty) {
        await _userRepository.addUserProfile(
          userProfile: UserProfile(
            email: state.email.value,
            id: _newUserProfile.id,
            name: state.name.value,
            createdOn: dateTimeToString(DateTime.now()),
          ),
        );
      }
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        status: FormzStatus.submissionFailure,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
