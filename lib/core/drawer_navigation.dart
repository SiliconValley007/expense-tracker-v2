import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/widgets.dart';

class DrawerItems {
  static const expenseList =
      DrawerItem(title: 'Expenses', icon: FontAwesomeIcons.moneyCheck);
  static const incomeList = DrawerItem(title: 'Incomes', icon: Icons.money);
  static const categories =
      DrawerItem(title: 'Categories', icon: Icons.category);
  static const settings = DrawerItem(title: 'Settings', icon: Icons.settings);

  static final List<DrawerItem> all = [
    expenseList,
    incomeList,
    categories,
    settings,
  ];
}
