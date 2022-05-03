import 'package:category_repository/category_repository.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_repository/income_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'constants/constants.dart';
import 'router/app_router.dart';
import 'screens/screens.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.firebaseAuth,
    required this.userRepository,
  }) : super(key: key);

  final FirebaseAuth firebaseAuth;
  final UserRepository userRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ExpenseRepository _expenseRepository;
  late final IncomeRepository _incomeRepository;
  late final CategoryRepository _categoryRepository;

  @override
  void initState() {
    super.initState();
    _expenseRepository = ExpenseRepository(firebaseAuth: widget.firebaseAuth);
    _incomeRepository = IncomeRepository(firebaseAuth: widget.firebaseAuth);
    _categoryRepository = CategoryRepository(firebaseAuth: widget.firebaseAuth);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ExpenseRepository>.value(
          value: _expenseRepository,
        ),
        RepositoryProvider<IncomeRepository>.value(
          value: _incomeRepository,
        ),
        RepositoryProvider<CategoryRepository>.value(
          value: _categoryRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ExpenseCubit>(
            create: (_) => ExpenseCubit(expenseRepository: _expenseRepository),
          ),
          BlocProvider<IncomeCubit>(
            create: (_) => IncomeCubit(incomeRepository: _incomeRepository),
          ),
          BlocProvider<CategoryCubit>(
            create: (_) =>
                CategoryCubit(categoryRepository: _categoryRepository),
          ),
          BlocProvider<ExpenseSearchCubit>(
            create: (_) =>
                ExpenseSearchCubit(expenseRepository: _expenseRepository),
          ),
          BlocProvider<IncomeSearchCubit>(
            create: (_) =>
                IncomeSearchCubit(incomeRepository: _incomeRepository),
          ),
          BlocProvider<ProfileCubit>(
            create: (_) => ProfileCubit(userRepository: widget.userRepository),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (previous, current) =>
              previous.themeMode != current.themeMode,
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: state.themeMode,
              theme: light.copyWith(textTheme: appTextTheme(context)),
              darkTheme: dark.copyWith(textTheme: appTextTheme(context)),
              home: const HomeScreen(),
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}
