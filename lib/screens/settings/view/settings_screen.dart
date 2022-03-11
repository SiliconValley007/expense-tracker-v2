import 'package:final_year_project_v2/authentication/authentication.dart';
import 'package:final_year_project_v2/constants/constants.dart';
import 'package:final_year_project_v2/screens/screens.dart';
import 'package:final_year_project_v2/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: DrawerMenuItem(onPressed: onPressed),
        backgroundColor: _theme.scaffoldBackgroundColor,
        foregroundColor: _theme.primaryColor,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (previous, current) =>
                  previous.userProfile != current.userProfile,
              builder: (context, state) {
                final _userProfile = state.userProfile;
                return Column(
                  children: [
                    CircleAvatar(
                      radius: _size.width * 0.1,
                      backgroundColor: Colors.grey,
                      backgroundImage: const NetworkImage(
                        'https://th.bing.com/th/id/R.b67500e782098bcbcad16dd9f2376e0b?rik=vu67XUEk6K3zAw&riu=http%3a%2f%2fwww.laaae.org%2fwp-content%2fuploads%2f2013%2f09%2fempty_profile_picture.gif&ehk=YnKc5oI3guSnLXKOp5fjIQBa0q8kMyfF3sNz8AtS%2fM4%3d&risl=&pid=ImgRaw&r=0&sres=1&sresct=1',
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _size.width * 0.05,
                    ),
                    Text(
                      _userProfile.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      _userProfile.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      _userProfile.createdOn,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 40.0,
            ),
            SettingsButton(
              text: 'Change theme',
              onPressed: () => Navigator.pushNamed(context, changeTheme),
            ),
            /*const SizedBox(
              height: 10.0,
            ),
            SettingsButton(
              text: 'Your categories',
              onPressed: () => Navigator.pushNamed(context, categoryList),
            ),*/
            const SizedBox(
              height: 10.0,
            ),
            SettingsButton(
              text: 'Sign Out',
              onPressed: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
              icon: Icons.exit_to_app,
              iconColor: _theme.primaryColor,
            ),
            /*const SizedBox(
              height: 10.0,
            ),
            SettingsButton(
              text: 'Delete Account',
              textColor: Colors.red,
              onPressed: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationDeleteUser()),
              icon: Icons.delete,
              iconColor: Colors.red,
            ),*/
          ],
        ),
      ),
    );
  }
}
