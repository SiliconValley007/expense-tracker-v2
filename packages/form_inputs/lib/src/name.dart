import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum NameValidationError {
  /// Generic invalid error.
  invalid
}

class Name extends FormzInput<String, NameValidationError> {
  const Name.dirty([String value = '']) : super.dirty(value);

  const Name.pure() : super.pure('');

  /*static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');*/

  @override
  NameValidationError? validator(String? value) {
    /*return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;*/
    return (value ?? '').isEmpty ? NameValidationError.invalid : null;
  }
}
