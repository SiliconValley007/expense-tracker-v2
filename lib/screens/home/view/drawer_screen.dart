import 'package:final_year_project_v2/core/core.dart';
import 'package:final_year_project_v2/screens/screens.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                CircleAvatar(
                  radius: _size.width * 0.07,
                  backgroundColor: Colors.grey,
                  backgroundImage: const NetworkImage(
                    'https://th.bing.com/th/id/R.b67500e782098bcbcad16dd9f2376e0b?rik=vu67XUEk6K3zAw&riu=http%3a%2f%2fwww.laaae.org%2fwp-content%2fuploads%2f2013%2f09%2fempty_profile_picture.gif&ehk=YnKc5oI3guSnLXKOp5fjIQBa0q8kMyfF3sNz8AtS%2fM4%3d&risl=&pid=ImgRaw&r=0&sres=1&sresct=1',
                  ),
                ),
                const SizedBox(width: 20),
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
                          color: Colors.white,
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
                    color: Colors.white,
                    fontSize: 14,
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
