import 'package:flutter/material.dart';

import '../screens.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: AuthenticationScreen());

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const AuthenticationScreen());

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late final PageController _pageController;
  late final ValueNotifier<bool> _isHidePassword;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isHidePassword = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _isHidePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        LoginScreen(
          onSignupButtonPressed: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeInOut),
        ),
        SignupScreen(
          onLoginButtonPressed: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeInOut),
        ),
      ],
    );
  }
}
