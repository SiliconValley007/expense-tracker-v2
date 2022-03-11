import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:theme_repository/theme_repository.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({ThemeService? themeService})
      : _themeService = themeService ?? ThemeService(),
        super(const ThemeState(themeMode: ThemeMode.system)) {
    setDefaultTheme();
  }

  final ThemeService _themeService;

  void setDefaultTheme() async {
    final int _themePreferenceValue = await _themeService.getTheme();
    final ThemePreference _themePreference =
        ThemePreference.values[_themePreferenceValue];
    switch (_themePreference) {
      case ThemePreference.light:
        emit(state.copyWith(themeMode: ThemeMode.light));
        break;
      case ThemePreference.dark:
        emit(state.copyWith(themeMode: ThemeMode.dark));
        break;
      case ThemePreference.system:
        emit(state.copyWith(themeMode: ThemeMode.system));
        break;
      default:
        emit(state.copyWith(themeMode: ThemeMode.system));
        break;
    }
  }

  void setLightTheme() {
    _themeService.setTheme(ThemePreference.light);
    emit(state.copyWith(themeMode: ThemeMode.light));
  }

  void setDarkTheme() {
    _themeService.setTheme(ThemePreference.dark);
    emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  void setSystemTheme() {
    _themeService.setTheme(ThemePreference.system);
    emit(state.copyWith(themeMode: ThemeMode.system));
  }
}

