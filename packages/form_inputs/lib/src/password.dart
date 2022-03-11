import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  invalid
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.dirty([String value = '']) : super.dirty(value);

  const Password.pure() : super.pure('');

  /*static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');*/

  @override
  PasswordValidationError? validator(String? value) {
    /*return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;*/
    return (value?.length ?? 0) < 6 ? PasswordValidationError.invalid : null;
  }
}
