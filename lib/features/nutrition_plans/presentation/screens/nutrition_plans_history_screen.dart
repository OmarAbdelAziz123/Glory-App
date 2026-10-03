import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_platform_refresh_scroll.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/nutrition_plan_entities.dart';
import '../cubits/nutrition_plans_list/nutrition_plans_list_cubit.dart';
import '../utils/nutrition_plan_format.dart';

final class NutritionPlansHistoryScreen extends StatefulWidget {
  const NutritionPlansHistoryScreen({super.key});

  @override
  State<NutritionPlansHistoryScreen> createState() =>
      _NutritionPlansHistoryScreenState();
}

final class _NutritionPlansHistoryScreenState
    extends State<NutritionPlansHistoryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      context.read<NutritionPlansListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NutritionPlansListCubit>()..load(),
      child: _NutritionPlansHistoryView(scrollController: _scrollController),
    );
  }
}

final class _NutritionPlansHistoryView extends StatelessWidget {
  const _NutritionPlansHistoryView({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      appBar: AppPrimaryHeader(title: l10n.nutritionPlanHistory),
      body: BlocConsumer<NutritionPlansListCubit, NutritionPlansListState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          final message = state.errorMessage;
          if (message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.plans.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.plans.isEmpty &&
              state.status != NutritionPlansListStatus.failure) {
            return AppPlatformRefreshScroll(
              fillViewport: true,
              onRefresh: () =>
                  context.read<NutritionPlansListCubit>().load(refresh: true),
              child: AppEmptyState(
                icon: Iconsax.document_text,
                title: l10n.nutritionPlanHistoryEmptyTitle,
                description: l10n.nutritionPlanEmptyDescription,
              ),
            );
          }

          if (state.plans.isEmpty &&
              state.status == NutritionPlansListStatus.failure) {
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
                          context.read<NutritionPlansListCubit>().load(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          return AppPlatformRefreshScroll(
            controller: scrollController,
            onRefresh: () =>
                context.read<NutritionPlansListCubit>().load(refresh: true),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              child: Column(
              children: [
                for (var i = 0; i < state.plans.length; i++) ...[
                  _PlanListTile(plan: state.plans[i]),
                  if (i < state.plans.length - 1) const SizedBox(height: 10),
                ],
                if (state.isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }
}

final class _PlanListTile extends StatelessWidget {
  const _PlanListTile({required this.plan});

  final NutritionPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final goal = NutritionPlanFormat.goalLabel(l10n, plan.plan.goal);
    final date = NutritionPlanFormat.formatDate(l10n, plan.approvedAt);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          AppRoutes.nutritionPlanDetail.replaceFirst(':id', plan.id),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Iconsax.cup, color: AppColors.primary800),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal, style: context.contentBold),
                    const SizedBox(height: 4),
                    Text(date, style: context.captionRegular),
                    if (plan.coach.fullName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        plan.coach.fullName,
                        style: context.captionRegular.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Iconsax.arrow_left_2, size: 18, color: AppColors.neutral500),
            ],
          ),
        ),
      ),
    );
  }
}
