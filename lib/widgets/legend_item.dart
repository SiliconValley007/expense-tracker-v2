import 'package:flutter/material.dart';

class Legend extends StatelessWidget {
  const Legend({
    Key? key,
    required this.color,
    required this.title,
  }) : super(key: key);

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: MediaQuery.of(context).size.width * 0.02,
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
