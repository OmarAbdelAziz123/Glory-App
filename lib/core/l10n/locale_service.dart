import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/cubits/locale/app_locale_cubit.dart';
import '../../features/auth/domain/entities/member_entity.dart';
import '../../features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import '../di/service_locator.dart';
import '../storage/local_storage.dart';
import '../storage/storage_keys.dart';
import 'fallback_messages.dart';

abstract final class LocaleService {
  static String? _normalizeLanguage(String? code) {
    if (code == 'en') return 'en';
    if (code == 'ar') return 'ar';
    return null;
  }

  /// Syncs persisted language with [AppLocaleCubit] on cold start.
  static Future<void> bootstrap() async {
    final storage = sl<ILocalStorage>();
    final cubit = sl<AppLocaleCubit>();
    final saved = _normalizeLanguage(await storage.getString(StorageKeys.language));

    if (saved != null) {
      LocaleHolder.languageCode = saved;
      if (cubit.state.languageCode != saved) {
        cubit.changeLocale(Locale(saved));
      }
      return;
    }

    final code = cubit.state.languageCode == 'en' ? 'en' : 'ar';
    LocaleHolder.languageCode = code;
    await storage.setString(StorageKeys.language, code);
  }

  static Future<void> applyLanguage(String languageCode) async {
    final normalized = languageCode == 'en' ? 'en' : 'ar';
    final locale = Locale(normalized);

    LocaleHolder.languageCode = normalized;
    sl<AppLocaleCubit>().changeLocale(locale);
    await sl<ILocalStorage>().setString(StorageKeys.language, normalized);
  }

  static Future<void> syncFromMember(MemberEntity? member) async {
    final saved = _normalizeLanguage(
      await sl<ILocalStorage>().getString(StorageKeys.language),
    );
    if (saved != null) {
      await applyLanguage(saved);
      return;
    }

    if (member != null) {
      await applyLanguage(member.appLanguage);
    }
  }

  /// Returns `true` when the language actually changed.
  static Future<bool> changeLanguage(
    BuildContext context, {
    required String languageCode,
  }) async {
    final normalized = languageCode == 'en' ? 'en' : 'ar';
    final current = sl<AppLocaleCubit>().state.languageCode;
    if (current == normalized) return false;

    final profileCubit = context.read<UserProfileCubit>();

    await applyLanguage(normalized);

    final member = profileCubit.state.member;
    if (member != null) {
      profileCubit.setMember(member.copyWith(appLanguage: normalized));
    }

    return true;
  }
}
