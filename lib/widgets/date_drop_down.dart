import 'package:final_year_project_v2/constants/constants.dart';
import 'package:flutter/material.dart';

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
    return DropdownButton<String>(
      onChanged: onChanged,
      items: dateTimes()
          .map<DropdownMenuItem<String>>((value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList(),
      hint: const Text(
        'Go to Date',
      ),
    );
  }
}
