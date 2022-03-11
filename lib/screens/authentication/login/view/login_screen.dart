import 'package:authentication_repository/authentication_repository.dart';
import 'package:final_year_project_v2/screens/authentication/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, this.onSignupButtonPressed}) : super(key: key);

  final VoidCallback? onSignupButtonPressed;
  static Page page() => const MaterialPage<void>(child: LoginScreen());

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const LoginScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
          child: LoginForm(
            onSignupButtonPressed: onSignupButtonPressed,
          ),
        ),
      ),
    );
  }
}
