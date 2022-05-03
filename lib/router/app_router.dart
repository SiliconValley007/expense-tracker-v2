import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../core/arguments.dart';
import '../screens/screens.dart';

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
            arguments: (routeSettings.arguments ?? EditScreenArguments())
                as EditScreenArguments);
      case search:
        return SearchScreen.route(
            searchPreference: routeSettings.arguments as SearchPreference);
      case graphView:
        return GraphViewScreen.route(graphScreenArguments: routeSettings.arguments as GraphScreenArguments);
      case changeTheme:
        return ThemeChanger.route();
      case categoryList:
        return CategoryListScreen.route();
      default:
        return HomeScreen.route();
    }
  }
}
