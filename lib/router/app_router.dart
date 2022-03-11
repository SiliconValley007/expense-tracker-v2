import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/core/arguments.dart';
import 'package:final_year_project_v2/screens/screens.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return HomeScreen.route();
      case authentication:
        return AuthenticationScreen.route();
      case login:
        return LoginScreen.route();
      case signup:
        return SignupScreen.route();
      case edit:
        return EditScreen.route(
            arguments: (routeSettings.arguments ?? EditScreenArguments()) as EditScreenArguments);
      case search:
        return SearchScreen.route(
            searchPreference: routeSettings.arguments as SearchPreference);
      /*case settings:
        return SettingsScreen.route();*/
      case changeTheme:
        return ThemeChanger.route();
      case categoryList:
        return CategoryListScreen.route();
      default:
        return HomeScreen.route();
    }
  }
}
