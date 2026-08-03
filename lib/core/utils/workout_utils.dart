import 'package:intl/intl.dart';

import '../../features/home/presentation/widgets/group_class_card.dart';
import '../../features/workouts/domain/entities/workout_entity.dart';

abstract final class WorkoutUtils {
  static String typeLabel(String type) => switch (type) {
        'CARDIO' => 'كارديو',
        'STRENGTH' => 'قوة',
        'FLEXIBILITY' => 'مرونة',
        'HIIT' => 'HIIT',
        _ => type,
      };

  static GroupClassStatus cardStatus(String status) => switch (status) {
        'COMPLETED' => GroupClassStatus.completed,
        'IN_PROGRESS' => GroupClassStatus.ongoing,
        _ => GroupClassStatus.upcoming,
      };

  static String workoutName(WorkoutAssignmentEntity assignment,
      {String locale = 'ar'}) {
    return locale == 'ar'
        ? assignment.workoutNameAr
        : assignment.workoutNameEn;
  }

  static String workoutNameFromDetail(
    WorkoutAssignmentDetailEntity detail, {
    String locale = 'ar',
  }) {
    return locale == 'ar' ? detail.workoutNameAr : detail.workoutNameEn;
  }

  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM y', 'ar').format(date.toLocal());
  }

  static String durationLabel(int days) => '$days يوم';

  static String remainingDaysLabel(int? days) {
    if (days == null) return '';
    return '$days يوم';
  }

  static String weightLabel(String? weight) {
    if (weight == null || weight.isEmpty) return '';
    return '$weight كيلو';
  }

  static String phaseLabel(int stepNumber) => switch (stepNumber) {
        1 => 'المرحلة الاولى',
        2 => 'المرحلة الثانية',
        3 => 'المرحلة الثالثة',
        4 => 'المرحلة الرابعة',
        _ => 'المرحلة $stepNumber',
      };

  static GroupClassItem toGroupClassItem(
    WorkoutAssignmentEntity assignment, {
    required String locale,
  }) {
    final status = cardStatus(assignment.status);
    final isUpcoming = assignment.status == 'UPCOMING';

    return GroupClassItem(
      className: workoutName(assignment, locale: locale),
      imageAsset: 'assets/images/pngs/classes_image.png',
      thumbnailUrl: assignment.previewThumbnailUrl,
      classType: typeLabel(assignment.workoutType),
      time: durationLabel(assignment.durationDays),
      startDate: isUpcoming ? null : formatDate(assignment.startDate),
      issuedBy: isUpcoming ? assignment.instructorName : null,
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
