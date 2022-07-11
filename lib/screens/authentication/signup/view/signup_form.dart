import '../../../../constants/constants.dart';
import '../../authentication.dart';
import '../../../../widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:nil/nil.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key, required this.onLoginButtonPressed})
      : super(key: key);

  final VoidCallback? onLoginButtonPressed;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late final ValueNotifier<bool> _isHidePassword;

  @override
  void initState() {
    super.initState();
    _isHidePassword = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _isHidePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              showSnackBar(
                context,
                state.errorMessage ?? 'Signup Failure',
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
                        'Hello',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'There',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: MediaQuery.of(context).size.width * 0.18,
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
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    const _NameInput(),
                    const SizedBox(height: 16),
                    const _EmailInput(),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isHidePassword,
                      builder: (context, value, child) => _PasswordInput(
                        suffix: IconButton(
                          splashColor: Colors.transparent,
                          onPressed: () =>
                              _isHidePassword.value = !_isHidePassword.value,
                          icon: Icon(
                            value ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: value,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const _SignupButton(),
                    const SizedBox(height: 20),
                    _LoginButton(
                      onPressed: widget.onLoginButtonPressed,
                    )
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
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) => CustomInputWidget(
        key: const Key('signupForm_emailInput_textField'),
        onChanged: (email) =>
            context.read<SignupCubit>().emailChanged(value: email),
        hintText: 'Email',
        icon: Icons.mail,
        keyboardType: TextInputType.emailAddress,
        errorText: state.email.invalid ? 'invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key? key,
    this.suffix,
    required this.obscureText,
  }) : super(key: key);

  final Widget? suffix;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) => CustomInputWidget(
        key: const Key('signupForm_passwordInput_textField'),
        onChanged: (password) =>
            context.read<SignupCubit>().passwordChanged(value: password),
        hintText: 'Password',
        obscureText: obscureText,
        icon: Icons.lock,
        errorText: state.password.invalid ? 'invalid password' : null,
        suffix: suffix,
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) => CustomInputWidget(
        key: const Key('signupForm_nameInput_textField'),
        onChanged: (name) =>
            context.read<SignupCubit>().nameChanged(value: name),
        hintText: 'Name',
        icon: Icons.person,
        errorText: state.name.invalid ? 'Name must not be empty' : null,
      ),
    );
  }
}

class _OverlayScreen extends StatelessWidget {
  const _OverlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) =>
          state.status.isSubmissionInProgress ? const OverLayScreen() : nil,
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => GestureDetector(
        onTap: state.status.isValidated
            ? () => context.read<SignupCubit>().signUpFormSubmitted()
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
          child: state.status.isSubmissionInProgress
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text(
                  'Signup',
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

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Already have an account ?",
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 13,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onPressed,
            text: ' Login',
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
