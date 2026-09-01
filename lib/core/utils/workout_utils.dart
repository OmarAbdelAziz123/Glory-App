import 'package:glory_gym/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../features/home/presentation/widgets/group_class_card.dart';
import '../../features/workouts/domain/entities/workout_entity.dart';

abstract final class WorkoutUtils {
  static String typeLabel(AppLocalizations l10n, String type) => switch (type) {
    'CARDIO' => l10n.cardio,
    'STRENGTH' => l10n.strength,
    'FLEXIBILITY' => l10n.flexibility,
    'HIIT' => 'HIIT',
    _ => type,
  };

  static GroupClassStatus cardStatus(String status) => switch (status) {
    'COMPLETED' => GroupClassStatus.completed,
    'IN_PROGRESS' => GroupClassStatus.ongoing,
    _ => GroupClassStatus.upcoming,
  };

  // static bool isPendingStatus(String status) => status == 'COMPLETED';
  static bool isPendingStatus(String status) => status == 'UPCOMING';

  static String workoutName(
    WorkoutAssignmentEntity assignment, {
    String locale = 'ar',
  }) {
    return locale == 'ar' ? assignment.workoutNameAr : assignment.workoutNameEn;
  }

  static String workoutNameFromDetail(
    WorkoutAssignmentDetailEntity detail, {
    String locale = 'ar',
  }) {
    return locale == 'ar' ? detail.workoutNameAr : detail.workoutNameEn;
  }

  static String formatDate(AppLocalizations l10n, DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM y', l10n.localeName).format(date.toLocal());
  }

  static String durationLabel(AppLocalizations l10n, int days) =>
      l10n.daysCountLabel('$days');

  static String remainingDaysLabel(AppLocalizations l10n, int? days) {
    if (days == null) return '';
    return l10n.daysCountLabel('$days');
  }

  static String weightLabel(AppLocalizations l10n, String? weight) {
    if (weight == null || weight.isEmpty) return '';
    return l10n.weightKilosLabel(weight);
  }

  static String instructionLabel(
    WorkoutInstructionEntity instruction, {
    String locale = 'ar',
  }) {
    return locale == 'ar'
        ? instruction.instructionAr
        : instruction.instructionEn;
  }

  static String displayOrFallback(String? value, String fallback) {
    if (value == null || value.isEmpty) return fallback;
    return value;
  }

  static String phaseLabel(AppLocalizations l10n, int stepNumber) =>
      switch (stepNumber) {
        1 => l10n.phaseOne,
        2 => l10n.phaseTwo,
        3 => l10n.phaseThree,
        4 => l10n.phaseFour,
        _ => l10n.phaseNumberLabel('$stepNumber'),
      };

  static GroupClassItem toGroupClassItem(
    WorkoutAssignmentEntity assignment, {
    required AppLocalizations l10n,
    required String locale,
    bool includeExtraDetail = true,
  }) {
    final status = cardStatus(assignment.status);
    final isUpcoming = assignment.status == 'UPCOMING';

    return GroupClassItem(
      className: workoutName(assignment, locale: locale),
      imageAsset: 'assets/images/pngs/classes_image.png',
      thumbnailUrl: assignment.previewThumbnailUrl,
      classType: typeLabel(l10n, assignment.workoutType),
      time: durationLabel(l10n, assignment.durationDays),
      startDate: includeExtraDetail && !isUpcoming
          ? formatDate(l10n, assignment.startDate)
          : null,
      issuedBy: includeExtraDetail && isUpcoming
          ? assignment.instructorName
          : null,
      status: status,
    );
  }

  static String localeFromAppLanguage(String? appLanguage) =>
      appLanguage == 'en' ? 'en' : 'ar';

  static String formatWeightForApi(String input) {
    final normalized = input.trim().replaceAll(',', '.');
    final value = double.tryParse(normalized);
    if (value == null) return input.trim();
    return value.toStringAsFixed(2);
  }
}
