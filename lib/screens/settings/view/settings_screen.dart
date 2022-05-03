import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/authentication.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../screens.dart';

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
              onPressed: () => showSignOutDialog(
                context: context,
                onConfirmPressed: () => context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested()),
              ),
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
