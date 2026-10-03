import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_platform_refresh_scroll.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../cubits/nutrition_plan_current/nutrition_plan_current_cubit.dart';
import '../widgets/nutrition_plan_content.dart';

final class MyNutritionPlanScreen extends StatelessWidget {
  const MyNutritionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NutritionPlanCurrentCubit>()..load(),
      child: const _MyNutritionPlanView(),
    );
  }
}

final class _MyNutritionPlanView extends StatelessWidget {
  const _MyNutritionPlanView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: l10n.myNutritionPlan,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.clock, color: AppColors.white),
            tooltip: l10n.nutritionPlanHistory,
            onPressed: () => context.push(AppRoutes.nutritionPlansHistory),
          ),
        ],
      ),
      body: BlocBuilder<NutritionPlanCurrentCubit, NutritionPlanCurrentState>(
        builder: (context, state) {
          if (state.isLoading && state.plan == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NutritionPlanCurrentStatus.failure &&
              state.plan == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? l10n.errorTryAgain,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<NutritionPlanCurrentCubit>().load(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          final plan = state.plan;
          if (plan == null) {
            return AppPlatformRefreshScroll(
              fillViewport: true,
              onRefresh: () =>
                  context.read<NutritionPlanCurrentCubit>().load(refresh: true),
              child: AppEmptyState(
                icon: Iconsax.cup,
                title: l10n.nutritionPlanEmptyTitle,
                description: l10n.nutritionPlanEmptyDescription,
              ),
            );
          }

          return AppPlatformRefreshScroll(
            onRefresh: () =>
                context.read<NutritionPlanCurrentCubit>().load(refresh: true),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              child: NutritionPlanContent(plan: plan),
            ),
          );
        },
      ),
    );
  }
}
