import 'dart:ui';

import 'package:hydrated_bloc/hydrated_bloc.dart';

final class AppLocaleCubit extends HydratedCubit<Locale> {
  AppLocaleCubit() : super(const Locale('ar'));

  void changeLocale(Locale locale) => emit(locale);

  static const int _persistSchema = 1;

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    if ((json['locale_v'] as int?) != _persistSchema) {
      return const Locale('ar');
    }
    final code = json['language_code'] as String?;
    if (code == 'ar' || code == 'en') return Locale(code!);
    return code != null ? Locale(code) : null;
  }

  @override
  Map<String, dynamic>? toJson(Locale state) => {
    'language_code': state.languageCode,
    'locale_v': _persistSchema,
  };
}
