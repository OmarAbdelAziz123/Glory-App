import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final class AppThemeCubit extends HydratedCubit<ThemeMode> {
  AppThemeCubit() : super(ThemeMode.dark);

  void setTheme(ThemeMode mode) => emit(mode);

  void toggle() => emit(
        state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
      );

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final index = json['theme_mode'] as int?;
    return index != null ? ThemeMode.values[index] : null;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) => {
        'theme_mode': state.index,
      };
}
