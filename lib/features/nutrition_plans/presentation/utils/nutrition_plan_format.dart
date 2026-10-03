import 'package:glory_gym/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/nutrition_plan_entities.dart';

abstract final class NutritionPlanFormat {
  static String goalLabel(AppLocalizations l10n, NutritionPlanGoal goal) {
    return switch (goal) {
      NutritionPlanGoal.fatLoss => l10n.nutritionPlanGoalFatLoss,
      NutritionPlanGoal.muscleGain => l10n.nutritionPlanGoalMuscleGain,
      NutritionPlanGoal.recomposition => l10n.nutritionPlanGoalRecomposition,
      NutritionPlanGoal.maintenance => l10n.nutritionPlanGoalMaintenance,
      NutritionPlanGoal.unknown => l10n.nutritionPlanGoalUnknown,
    };
  }

  static String formatDate(AppLocalizations l10n, DateTime date) {
    return DateFormat('d MMMM y', l10n.localeName).format(date.toLocal());
  }

  static String formatDateTime(AppLocalizations l10n, DateTime date) {
    return DateFormat('d MMM y · HH:mm', l10n.localeName).format(date.toLocal());
  }

  static String waterLabel(AppLocalizations l10n, double liters) {
    final value = liters == liters.roundToDouble()
        ? liters.toInt().toString()
        : liters.toStringAsFixed(1);
    return l10n.nutritionPlanWaterLiters(value);
  }
}
