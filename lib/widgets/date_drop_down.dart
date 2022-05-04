import 'package:flutter/material.dart';

import '../constants/constants.dart';

class DateDropDown extends StatelessWidget {
  const DateDropDown({
    Key? key,
    required this.scrollToPositions,
    required this.transactionDates,
    required this.onChanged,
  }) : super(key: key);

  final List<int> scrollToPositions;
  final List<DateTime> transactionDates;
  final void Function(String?) onChanged;

  List<String> dateTimes() {
    List<String> _datetimes = [];
    for (int index in scrollToPositions) {
      _datetimes.add(dateTimeToString(transactionDates[index]));
    }
    return _datetimes;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return DropdownButton<String>(
      onChanged: onChanged,
      items: dateTimes()
          .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: _theme.primaryColor,
                  ),
                ),
              ))
          .toList(),
      hint: Text(
        'Go to Date',
        style: TextStyle(
          color: _theme.primaryColor,
        ),
      ),
    );
  }
}
