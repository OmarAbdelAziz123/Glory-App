import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../domain/entities/nutrition_plan_entities.dart';
import '../utils/nutrition_plan_format.dart';
import '../utils/nutrition_sandy_launcher.dart';

final class NutritionPlanContent extends StatelessWidget {
  const NutritionPlanContent({
    super.key,
    required this.plan,
    this.showMeta = true,
  });

  final NutritionPlanEntity plan;
  final bool showMeta;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final details = plan.plan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showMeta) ...[
          _MetaSection(plan: plan),
          const SizedBox(height: 16),
        ],
        AppEntrance(
          delay: const Duration(milliseconds: 30),
          child: _GoalChip(
            label: NutritionPlanFormat.goalLabel(l10n, details.goal),
          ),
        ),
        const SizedBox(height: 16),
        if (details.summary.isNotEmpty) ...[
          AppEntrance(
            delay: const Duration(milliseconds: 50),
            child: _SectionCard(
              title: l10n.nutritionPlanSummary,
              child: Text(details.summary, style: context.contentRegular),
            ),
          ),
          const SizedBox(height: 16),
        ],
        AppEntrance(
          delay: const Duration(milliseconds: 70),
          child: _MacrosSection(details: details),
        ),
        const SizedBox(height: 16),
        AppEntrance(
          delay: const Duration(milliseconds: 90),
          child: _WaterTargetCard(liters: details.waterLiters),
        ),
        if (plan.coachNote != null && plan.coachNote!.trim().isNotEmpty) ...[
          const SizedBox(height: 16),
          AppEntrance(
            delay: const Duration(milliseconds: 110),
            child: _CoachNoteCard(note: plan.coachNote!.trim()),
          ),
        ],
        if (details.meals.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(l10n.nutritionPlanMeals, style: context.contentBold),
          const SizedBox(height: 10),
          for (var i = 0; i < details.meals.length; i++) ...[
            AppEntrance(
              delay: Duration(milliseconds: 120 + (i * 35)),
              child: _MealCard(meal: details.meals[i]),
            ),
            if (i < details.meals.length - 1) const SizedBox(height: 10),
          ],
        ],
        if (details.guidelines.isNotEmpty) ...[
          const SizedBox(height: 20),
          _BulletSection(
            title: l10n.nutritionPlanGuidelines,
            icon: Iconsax.tick_circle,
            iconColor: AppColors.green200,
            items: details.guidelines,
          ),
        ],
        if (details.avoid.isNotEmpty) ...[
          const SizedBox(height: 16),
          _BulletSection(
            title: l10n.nutritionPlanAvoid,
            icon: Iconsax.close_circle,
            iconColor: AppColors.red,
            items: details.avoid,
          ),
        ],
        if (plan.sandyConversationId != null &&
            plan.sandyConversationId!.isNotEmpty) ...[
          const SizedBox(height: 24),
          AppButton(
            label: l10n.nutritionPlanAskSandy,
            onPressed: () => NutritionSandyLauncher.openConversation(
              context,
              conversationId: plan.sandyConversationId!,
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

final class _MetaSection extends StatelessWidget {
  const _MetaSection({required this.plan});

  final NutritionPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaRow(
            label: l10n.nutritionPlanInbodyTestDate,
            value: NutritionPlanFormat.formatDate(l10n, plan.testDate),
          ),
          const SizedBox(height: 8),
          _MetaRow(
            label: l10n.nutritionPlanApprovedOn,
            value: NutritionPlanFormat.formatDateTime(l10n, plan.approvedAt),
          ),
          if (plan.coach.fullName.isNotEmpty) ...[
            const SizedBox(height: 8),
            _MetaRow(
              label: l10n.nutritionPlanCoach,
              value: plan.coach.fullName,
            ),
          ],
        ],
      ),
    );
  }
}

final class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: context.captionRegular.copyWith(color: AppColors.neutral500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: context.subtitleMedium),
        ),
      ],
    );
  }
}

final class _GoalChip extends StatelessWidget {
  const _GoalChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        child: Text(
          label,
          style: context.subtitleMedium.copyWith(color: AppColors.primary800),
        ),
      ),
    );
  }
}

final class _MacrosSection extends StatelessWidget {
  const _MacrosSection({required this.details});

  final NutritionPlanDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final proteinCal = details.proteinG * 4;
    final carbsCal = details.carbsG * 4;
    final fatCal = details.fatG * 9;
    final macroTotal = (proteinCal + carbsCal + fatCal).clamp(1, 999999);

    return _SectionCard(
      child: Column(
        children: [
          _CaloriesRing(calories: details.dailyCalories),
          const SizedBox(height: 20),
          _MacroBar(
            label: l10n.nutritionPlanProtein,
            grams: details.proteinG,
            color: const Color(0xFF5B8DEF),
            fraction: proteinCal / macroTotal,
          ),
          const SizedBox(height: 12),
          _MacroBar(
            label: l10n.nutritionPlanCarbs,
            grams: details.carbsG,
            color: const Color(0xFFE8A838),
            fraction: carbsCal / macroTotal,
          ),
          const SizedBox(height: 12),
          _MacroBar(
            label: l10n.nutritionPlanFat,
            grams: details.fatG,
            color: const Color(0xFF6BCB77),
            fraction: fatCal / macroTotal,
          ),
        ],
      ),
    );
  }
}

final class _CaloriesRing extends StatelessWidget {
  const _CaloriesRing({required this.calories});

  final int calories;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: 148,
      width: 148,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 148,
            width: 148,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 10,
              backgroundColor: AppColors.neutral200,
              color: AppColors.primary,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$calories',
                style: context.highlightBold.copyWith(fontSize: 28),
              ),
              Text(
                l10n.nutritionPlanDailyCalories,
                style: context.captionRegular.copyWith(
                  color: AppColors.neutral500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.grams,
    required this.color,
    required this.fraction,
  });

  final String label;
  final int grams;
  final Color color;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: context.subtitleMedium)),
            Text(
              l10n.nutritionPlanMacroGrams(grams),
              style: context.captionRegular.copyWith(
                color: AppColors.neutral600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.05, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.neutral200,
            color: color,
          ),
        ),
      ],
    );
  }
}

final class _WaterTargetCard extends StatelessWidget {
  const _WaterTargetCard({required this.liters});

  final double liters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SectionCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Iconsax.cup, color: Color(0xFF0288D1), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.nutritionPlanWater, style: context.subtitleMedium),
                const SizedBox(height: 2),
                Text(
                  NutritionPlanFormat.waterLabel(l10n, liters),
                  style: context.contentBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _CoachNoteCard extends StatelessWidget {
  const _CoachNoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SectionCard(
      title: l10n.nutritionPlanCoachNote,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.message_text_1, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(note, style: context.contentRegular)),
        ],
      ),
    );
  }
}

final class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal});

  final NutritionPlanMealEntity meal;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: meal.name,
      trailing: meal.time.isNotEmpty
          ? Text(
              meal.time,
              style: context.subtitleMedium.copyWith(color: AppColors.primary),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in meal.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  ', style: TextStyle(color: AppColors.neutral500)),
                  Expanded(child: Text(item, style: context.contentRegular)),
                ],
              ),
            ),
          if (meal.notes != null && meal.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              meal.notes!.trim(),
              style: context.captionRegular.copyWith(
                color: AppColors.neutral600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i < items.length - 1 ? 10 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: iconColor),
                  const SizedBox(width: 10),
                  Expanded(child: Text(items[i], style: context.contentRegular)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

final class _SectionCard extends StatelessWidget {
  const _SectionCard({
    this.title,
    this.trailing,
    required this.child,
  });

  final String? title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(child: Text(title!, style: context.contentBold)),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}
