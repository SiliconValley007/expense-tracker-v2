import '../../../constants/constants.dart';
import 'view.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.searchPreference})
      : super(key: key);

  static Route route({required SearchPreference searchPreference}) =>
      MaterialPageRoute<void>(
        builder: (_) => SearchScreen(
          searchPreference: searchPreference,
        ),
      );

  final SearchPreference searchPreference;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    switch (widget.searchPreference) {
      case SearchPreference.expense:
        return const ExpenseSearchList();
      case SearchPreference.income:
        return const IncomeSearchList();
      default:
        return const Scaffold(
          body: Center(
            child: Text('Search Preference not found'),
          ),
        );
    }
  }
}
