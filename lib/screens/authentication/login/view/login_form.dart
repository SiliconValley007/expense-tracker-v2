import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/screens/authentication/authentication.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.onSignupButtonPressed})
      : super(key: key);

  final VoidCallback? onSignupButtonPressed;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              showSnackBar(
                context,
                state.errorMessage ?? 'Authentication Failure',
              );
            }
          },
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: MediaQuery.of(context).size.width * 0.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.03,
                          backgroundColor: Colors.green,
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    const _EmailInput(),
                    const SizedBox(height: 8),
                    const _PasswordInput(),
                    const SizedBox(height: 40),
                    const _LoginButton(),
                    const SizedBox(height: 15),
                    const _GoogleLoginButton(),
                    const SizedBox(height: 20),
                    _SignUpButton(
                      onPressed: widget.onSignupButtonPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const _OverlayScreen(),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) => CustomInputWidget(
        key: const Key('loginForm_emailInput_textField'),
        onChanged: (email) =>
            context.read<LoginCubit>().emailChanged(value: email),
        hintText: 'Email',
        icon: Icons.lock,
        keyboardType: TextInputType.emailAddress,
        errorText: state.email.invalid ? 'invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) => CustomInputWidget(
        key: const Key('loginForm_passwordInput_textField'),
        onChanged: (password) =>
            context.read<LoginCubit>().passwordChanged(value: password),
        hintText: 'Password',
        obscureText: true,
        icon: Icons.lock,
        errorText: state.password.invalid ? 'invalid password' : null,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => GestureDetector(
        onTap: state.status.isValidated
            ? () => context.read<LoginCubit>().loginWithCredential()
            : null,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.green,
          ),
          child: const Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayScreen extends StatelessWidget {
  const _OverlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) =>
          state.status.isSubmissionInProgress ? const OverLayScreen() : const SizedBox.shrink(),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.read<LoginCubit>().loginWithGoogle(),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.g_mobiledata,
              color: theme.primaryColor,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              'SIGN IN WITH GOOGLE',
              style: TextStyle(color: theme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "New Here ?",
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 13,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onPressed,
            text: ' Create account',
            style: const TextStyle(
              color: Color(0xFF2EB62C),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
