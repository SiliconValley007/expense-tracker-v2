import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../signup.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key, this.onLoginButtonPressed}) : super(key: key);

  final VoidCallback? onLoginButtonPressed;

  static Page page() => const MaterialPage<void>(child: SignupScreen());

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const SignupScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<SignupCubit>(
          create: (_) => SignupCubit(
            authenticationRepository: context.read<AuthenticationRepository>(),
            userRepository: context.read<UserRepository>(),
          ),
          child: SignUpForm(
            onLoginButtonPressed: onLoginButtonPressed,
          ),
        ),
      ),
    );
  }
}
