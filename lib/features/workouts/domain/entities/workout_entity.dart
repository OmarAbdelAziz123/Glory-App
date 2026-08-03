final class WorkoutAssignmentEntity {
  const WorkoutAssignmentEntity({
    required this.id,
    required this.status,
    required this.workoutNameAr,
    required this.workoutNameEn,
    required this.workoutType,
    required this.workoutLevel,
    this.startDate,
    this.endDate,
    required this.durationDays,
    required this.instructorName,
    this.instructorAvatarUrl,
    this.previewVideoUrl,
    this.previewThumbnailUrl,
  });

  final String id;
  final String status;
  final String workoutNameAr;
  final String workoutNameEn;
  final String workoutType;
  final String workoutLevel;
  final DateTime? startDate;
  final DateTime? endDate;
  final int durationDays;
  final String instructorName;
  final String? instructorAvatarUrl;
  final String? previewVideoUrl;
  final String? previewThumbnailUrl;
}

final class WorkoutInstructionEntity {
  const WorkoutInstructionEntity({
    required this.id,
    required this.stepNumber,
    required this.instructionAr,
    required this.instructionEn,
    required this.videos,
  });

  final String id;
  final int stepNumber;
  final String instructionAr;
  final String instructionEn;
  final List<WorkoutVideoEntity> videos;
}

final class WorkoutVideoEntity {
  const WorkoutVideoEntity({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    this.stepNumber,
    this.instructionAr,
    this.instructionEn,
  });

  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String duration;
  final int? stepNumber;
  final String? instructionAr;
  final String? instructionEn;
}

final class WorkoutAssignmentDetailEntity {
  const WorkoutAssignmentDetailEntity({
    required this.id,
    required this.status,
    this.startDate,
    this.endDate,
    required this.durationDays,
    this.remainingDays,
    this.suggestedWeight,
    this.suggestedWeightLast,
    this.userWeight,
    this.userWeightLast,
    required this.canAddWeight,
    required this.instructorName,
    this.instructorAvatarUrl,
    required this.workoutNameAr,
    required this.workoutNameEn,
    required this.workoutType,
    required this.workoutLevel,
    required this.instructions,
    required this.createdAt,
  });

  final String id;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int durationDays;
  final int? remainingDays;
  final String? suggestedWeight;
  final String? suggestedWeightLast;
  final String? userWeight;
  final String? userWeightLast;
  final bool canAddWeight;
  final String instructorName;
  final String? instructorAvatarUrl;
  final String workoutNameAr;
  final String workoutNameEn;
  final String workoutType;
  final String workoutLevel;
  final List<WorkoutInstructionEntity> instructions;
  final DateTime createdAt;
}

final class WorkoutsPageEntity {
  const WorkoutsPageEntity({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  final List<WorkoutAssignmentEntity> items;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
