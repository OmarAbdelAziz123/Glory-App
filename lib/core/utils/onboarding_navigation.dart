import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../di/service_locator.dart';
import '../models/questionnaire_args.dart';
import '../result/result.dart';
import '../router/app_routes.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';

Future<bool> isOnboardingCompletedLocally() async {
  final userId = await sl<ISecureStorage>().read(StorageKeys.userId);
  final key = userId == null || userId.isEmpty
      ? StorageKeys.onboardingSeen
      : '${StorageKeys.onboardingSeen}_$userId';

  return await sl<ILocalStorage>().getBool(key) ?? false;
}

Future<void> markOnboardingCompletedLocally() async {
  final userId = await sl<ISecureStorage>().read(StorageKeys.userId);
  final key = userId == null || userId.isEmpty
      ? StorageKeys.onboardingSeen
      : '${StorageKeys.onboardingSeen}_$userId';

  await sl<ILocalStorage>().setBool(key, value: true);
}

Future<void> navigateAfterAuthentication(BuildContext context) async {
  if (await isOnboardingCompletedLocally()) {
    if (!context.mounted) return;
    context.go(AppRoutes.home);
    return;
  }

  final result = await sl<OnboardingRepository>().getStatus();
  if (!context.mounted) return;

  switch (result) {
    case Success(:final data):
      if (data.completed) {
        await markOnboardingCompletedLocally();
        if (!context.mounted) return;
        context.go(AppRoutes.home);
        return;
      }
      context.go(
        AppRoutes.subscriptionQuestionnaire,
        extra: QuestionnaireScreenArgs(
          prefill: data.prefill,
          completeToHome: true,
        ),
      );
    case Failure():
      context.go(AppRoutes.home);
  }
}
