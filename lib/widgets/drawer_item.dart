import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerItem {
  final String title;
  final IconData icon;

  const DrawerItem({
    required this.title,
    required this.icon,
  });
}

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: const FaIcon(FontAwesomeIcons.alignLeft));
  }
}
