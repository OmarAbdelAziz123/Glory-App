import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/l10n/l10n_extension.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/secure_screen_scope.dart';
import 'app_bloc_providers.dart';
import 'cubits/locale/app_locale_cubit.dart';
import 'router/app_router.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: const _AppView(),
    );
  }
}

final class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppLocaleCubit>().state;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Glory Gym',
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.router,
      builder: (context, child) => SecureScreenScope(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
