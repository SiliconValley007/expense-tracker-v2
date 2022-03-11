import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.arrow_right,
    this.textColor,
    this.iconColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textColor ?? Theme.of(context).primaryColor,
              ),
            ),
            Icon(
              icon,
              color: iconColor ?? Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
