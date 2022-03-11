import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputWidget extends StatelessWidget {
  const CustomInputWidget({
    Key? key,
    TextEditingController? controller,
    required this.hintText,
    this.icon,
    this.errorText,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.inputFormatters,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController? _controller;
  final String hintText;
  final String? errorText;
  final IconData? icon;
  final int? maxLines;
  final bool readOnly;
  final bool obscureText;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: TextField(
        key: key,
        controller: _controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        maxLines: maxLines,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        cursorColor: Colors.grey,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: _theme.iconTheme.color,
          ),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: _theme.iconTheme.color,
          ),
          helperText: '',
          errorText: errorText,
        ),
      ),
    );
  }
}
