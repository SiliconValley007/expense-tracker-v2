import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/core.dart';
import '../../../widgets/widgets.dart';
import '../../screens.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({
    Key? key,
    required this.onSelectedItem,
    required this.onPressedClose,
  }) : super(key: key);

  final ValueChanged<DrawerItem> onSelectedItem;
  final VoidCallback onPressedClose;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 30),
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) =>
                previous.userProfile != current.userProfile,
            builder: (context, state) => Row(
              children: [
                IconButton(
                  onPressed: onPressedClose,
                  icon: const FaIcon(
                    FontAwesomeIcons.angleLeft,
                    color: Colors.white,
                  ),
                ),
                Text(
                  state.userProfile.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              children: DrawerItems.all
                  .map((drawerItem) => ListTile(
                        onTap: () => onSelectedItem(drawerItem),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        leading: Icon(
                          drawerItem.icon,
                          color: Colors.green,
                        ),
                        title: Text(
                          drawerItem.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Spacer(),
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (previous, current) =>
                previous.userProfile != current.userProfile,
            builder: (context, state) => Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 10.0,
                ),
                child: Text(
                  'Account created on: ${state.userProfile.createdOn}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
