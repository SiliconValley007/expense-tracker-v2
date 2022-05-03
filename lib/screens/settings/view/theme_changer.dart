import '../../screens.dart';
import '../../../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const ThemeChanger());

  @override
  Widget build(BuildContext context) {
    final ThemeCubit _themeCubit = context.read<ThemeCubit>();
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: _theme.scaffoldBackgroundColor,
        foregroundColor: _theme.primaryColor,
        title: const Text(
          'Change Theme',
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (previous, current) =>
              previous.themeMode != current.themeMode,
          builder: (context, state) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                CustomRadioButton(
                  onPressed: () => _themeCubit.setLightTheme(),
                  isSelected: state.themeMode == ThemeMode.light,
                  buttonText: 'Light Theme',
                ),
                CustomRadioButton(
                  onPressed: () => _themeCubit.setDarkTheme(),
                  isSelected: state.themeMode == ThemeMode.dark,
                  buttonText: 'Dark Theme',
                ),
                CustomRadioButton(
                  onPressed: () => _themeCubit.setSystemTheme(),
                  isSelected: state.themeMode == ThemeMode.system,
                  buttonText: 'System Theme',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
