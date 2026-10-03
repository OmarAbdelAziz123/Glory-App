import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/widgets/app_platform_refresh_scroll.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../cubits/nutrition_plan_detail/nutrition_plan_detail_cubit.dart';
import '../widgets/nutrition_plan_content.dart';

final class NutritionPlanDetailScreen extends StatelessWidget {
  const NutritionPlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NutritionPlanDetailCubit>(param1: planId)..load(),
      child: const _NutritionPlanDetailView(),
    );
  }
}

final class _NutritionPlanDetailView extends StatelessWidget {
  const _NutritionPlanDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      appBar: AppPrimaryHeader(title: l10n.nutritionPlanDetail),
      body: BlocBuilder<NutritionPlanDetailCubit, NutritionPlanDetailState>(
        builder: (context, state) {
          if (state.isLoading && state.plan == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NutritionPlanDetailStatus.failure ||
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
                          context.read<NutritionPlanDetailCubit>().load(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          return AppPlatformRefreshScroll(
            onRefresh: () =>
                context.read<NutritionPlanDetailCubit>().load(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              child: NutritionPlanContent(plan: state.plan!),
            ),
          );
        },
      ),
    );
  }
}
