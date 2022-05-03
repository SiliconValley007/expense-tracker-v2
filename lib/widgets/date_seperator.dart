import 'package:flutter/material.dart';

import '../constants/constants.dart';

class DateSeperator extends StatelessWidget {
  const DateSeperator({Key? key, required this.dateTime}) : super(key: key);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        bottom: 8.0,
        top: 5.0,
      ),
      child: Text(
        dateTimeToString(dateTime),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
