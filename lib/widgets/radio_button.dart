import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    Key? key,
    required this.onPressed,
    this.isSelected = false,
    required this.buttonText,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool isSelected;
  final EdgeInsetsGeometry padding;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              buttonText,
              style: TextStyle(
                color: _theme.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            Container(
              height: 30,
              width: 30,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _theme.primaryColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _theme.primaryColor,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
