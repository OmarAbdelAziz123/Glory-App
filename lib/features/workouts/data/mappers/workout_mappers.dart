import '../../../../core/network/models/pagination_meta_model.dart';
import '../../domain/entities/workout_entity.dart';
import '../models/workout_api_responses.dart';
import '../models/workout_models.dart';

extension WorkoutAssignmentListModelX on WorkoutAssignmentListModel {
  WorkoutAssignmentEntity toEntity() => WorkoutAssignmentEntity(
        id: id,
        status: status,
        workoutNameAr: workout.nameAr,
        workoutNameEn: workout.nameEn,
        workoutType: workout.type,
        workoutLevel: workout.level,
        startDate: startDate,
        endDate: endDate,
        durationDays: durationDays,
        instructorName: instructor.fullName,
        instructorAvatarUrl: instructor.avatarUrl,
        previewVideoUrl: previewVideoUrl,
        previewThumbnailUrl: previewThumbnailUrl,
      );
}

extension WorkoutAssignmentDetailModelX on WorkoutAssignmentDetailModel {
  WorkoutAssignmentDetailEntity toEntity() => WorkoutAssignmentDetailEntity(
        id: id,
        status: status,
        startDate: startDate,
        endDate: endDate,
        durationDays: durationDays,
        remainingDays: remainingDays,
        suggestedWeight: suggestedWeight,
        suggestedWeightLast: suggestedWeightLast,
        userWeight: userWeight,
        userWeightLast: userWeightLast,
        canAddWeight: canAddWeight,
        instructorName: instructor.fullName,
        instructorAvatarUrl: instructor.avatarUrl,
        workoutNameAr: workout.nameAr,
        workoutNameEn: workout.nameEn,
        workoutType: workout.type,
        workoutLevel: workout.level,
        instructions: instructions.map((item) => item.toEntity()).toList(),
        createdAt: createdAt,
      );
}

extension WorkoutInstructionModelX on WorkoutInstructionModel {
  WorkoutInstructionEntity toEntity() => WorkoutInstructionEntity(
        id: id,
        stepNumber: stepNumber,
        instructionAr: instructionAr,
        instructionEn: instructionEn,
        videos: videos.map((video) => video.toEntity()).toList(),
      );
}

extension WorkoutVideoModelX on WorkoutVideoModel {
  WorkoutVideoEntity toEntity() => WorkoutVideoEntity(
        id: id,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        duration: duration,
        stepNumber: stepNumber,
        instructionAr: instructionAr,
        instructionEn: instructionEn,
      );
}

extension WorkoutAssignmentsApiResponseX on WorkoutAssignmentsApiResponse {
  WorkoutsPageEntity? toPageEntity() {
    if (data == null) return null;
    final meta = this.meta ??
        const PaginationMetaModel(page: 1, limit: 10, total: 0, totalPages: 1);
    return WorkoutsPageEntity(
      items: data!.map((item) => item.toEntity()).toList(),
      page: meta.page,
      totalPages: meta.totalPages,
    );
  }
}
