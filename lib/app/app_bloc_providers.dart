import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/locale/app_locale_cubit.dart';

final class AppBlocProviders {
  AppBlocProviders._();

  static List<BlocProvider> get providers => [
        BlocProvider<AppLocaleCubit>(create: (_) => AppLocaleCubit()),
      ];
}
