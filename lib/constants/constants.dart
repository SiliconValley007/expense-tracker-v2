import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const String home = '/';
const String login = '/login';
const String signup = '/signup';
const String authentication = '/authentication';
const String edit = '/edit';
const String settings = '/settings';
const String graphView = '/graph-view';
const String changeTheme = '/change-theme';
const String search = '/search';
const String categoryList = '/category-list';

TextTheme appTextTheme(BuildContext context) => GoogleFonts.robotoTextTheme(
      Theme.of(context).textTheme,
    );

ThemeData light = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: const Color(0xff26272b),
  iconTheme: const IconThemeData(color: Color(0xff9f9fa2)),
  cardColor: Colors.white,
  colorScheme: const ColorScheme.light().copyWith(
    secondary: const Color(0xfff3f4f4),
    brightness: Brightness.light,
  ),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: Colors.white),
  scaffoldBackgroundColor: const Color(0xfff6f6f6),
);

ThemeData dark = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: const Color(0xfff3f4f4),
  iconTheme: const IconThemeData(color: Color(0xff56575c)),
  cardColor: Colors.white.withOpacity(0.8),
  colorScheme: const ColorScheme.dark().copyWith(
    secondary: Colors.black,
    brightness: Brightness.dark,
  ),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: Colors.white),
  scaffoldBackgroundColor: const Color(0xff080a0b),
);

const List<Color> categoryColors = [
  Color(0xffabc4ff),
  Color.fromARGB(255, 233, 12, 12),
  Color(0xffffc09f),
  Color(0xffffee93),
  Color.fromARGB(255, 176, 221, 13),
  Color(0xffadf7b6),
  Color(0xff809bce),
  Color.fromARGB(255, 206, 67, 130),
  Color.fromARGB(255, 130, 57, 75),
  Color(0xffff686b),
  Color(0xff6e78ff),
  Color(0xff70d6ff),
  Color(0xffffd670),
];

const Map<String, Color> chartWeekDayColors = {
  'Sunday': Color(0xff70d6ff),
  'Saturday': Color(0xffffd670),
  'Friday': Color(0xffff686b),
  'Thursday': Color(0xffadf7b6),
  'Wednesday': Color(0xffabc4ff),
  'Tuesday': Color(0xffffc09f),
  'Monday': Color(0xfffb6f92),
};

String dateTimeToString(DateTime? dateTime) =>
    dateTime == null ? '' : DateFormat.yMMMMd().format(dateTime);

void showSnackBar(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

List<String> setSearchParam(String text) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < text.length; i++) {
    temp = temp + text[i].toLowerCase();
    caseSearchList.add(temp);
  }
  return caseSearchList;
}

enum SearchPreference {
  income,
  expense,
}
