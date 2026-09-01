import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import '../features/coach_chat/presentation/cubits/coach_chat_unread/coach_chat_unread_cubit.dart';
import '../features/notifications/presentation/cubits/notifications_unread/notifications_unread_cubit.dart';
import 'cubits/locale/app_locale_cubit.dart';
import '../core/di/service_locator.dart';

final class AppBlocProviders {
  AppBlocProviders._();

  static List<BlocProvider> get providers => [
        BlocProvider<AppLocaleCubit>(create: (_) => sl<AppLocaleCubit>()),
        BlocProvider<UserProfileCubit>(
          create: (_) => sl<UserProfileCubit>(),
        ),
        BlocProvider<NotificationsUnreadCubit>(
          create: (_) => sl<NotificationsUnreadCubit>(),
        ),
        BlocProvider<CoachChatUnreadCubit>(
          create: (_) => sl<CoachChatUnreadCubit>(),
        ),
      ];
}
