import 'package:authentication_repository/authentication_repository.dart';
import 'package:final_year_project_v2/app.dart';
import 'package:final_year_project_v2/authentication/authentication.dart';
import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository(firebaseAuth: _firebaseAuth);
  await _authenticationRepository.userAuthStatus.first;
  runApp(MyApp(
    authenticationRepository: _authenticationRepository,
    userRepository: UserRepository(
      firebaseAuth: _firebaseAuth,
    ),
    firebaseAuth: _firebaseAuth,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
    required this.firebaseAuth,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final FirebaseAuth firebaseAuth;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(
          value: authenticationRepository,
        ),
        RepositoryProvider<UserRepository>.value(
          value: userRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              userRepository: userRepository,
            ),
          ),
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(),
          ),
        ],
        child: AppView(
          firebaseAuth: firebaseAuth,
          userRepository: userRepository,
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    Key? key,
    required this.firebaseAuth,
    required this.userRepository,
  }) : super(key: key);

  final FirebaseAuth firebaseAuth;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state.authenticationStatus == AuthenticationStatus.loading) {
        return MaterialApp(
          themeMode: ThemeMode.system,
          theme: light,
          darkTheme: dark,
          home: Scaffold(
            body: Center(
              child: Lottie.asset('assets/lottie/transaction-process.json'),
            ),
          ),
        );
      } else if (state.authenticationStatus ==
          AuthenticationStatus.authenticated) {
        return App(
          firebaseAuth: firebaseAuth,
          userRepository: userRepository,
        );
      } else {
        return MaterialApp(
          themeMode: ThemeMode.system,
          theme: light,
          darkTheme: dark,
          home: const AuthenticationScreen(),
        );
      }
    });
  }
}
