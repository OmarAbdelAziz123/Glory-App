enum NutritionPlanGoal {
  fatLoss,
  muscleGain,
  recomposition,
  maintenance,
  unknown,
}

final class NutritionPlanCoachEntity {
  const NutritionPlanCoachEntity({required this.fullName});

  final String fullName;
}

final class NutritionPlanMealEntity {
  const NutritionPlanMealEntity({
    required this.name,
    required this.time,
    required this.items,
    this.notes,
  });

  final String name;
  final String time;
  final List<String> items;
  final String? notes;
}

final class NutritionPlanDetailsEntity {
  const NutritionPlanDetailsEntity({
    required this.summary,
    required this.goal,
    required this.dailyCalories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.waterLiters,
    required this.meals,
    required this.guidelines,
    required this.avoid,
  });

  final String summary;
  final NutritionPlanGoal goal;
  final int dailyCalories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final double waterLiters;
  final List<NutritionPlanMealEntity> meals;
  final List<String> guidelines;
  final List<String> avoid;
}

final class NutritionPlanEntity {
  const NutritionPlanEntity({
    required this.id,
    required this.testDate,
    required this.approvedAt,
    required this.coach,
    this.coachNote,
    this.sandyConversationId,
    required this.plan,
  });

  final String id;
  final DateTime testDate;
  final DateTime approvedAt;
  final NutritionPlanCoachEntity coach;
  final String? coachNote;
  final String? sandyConversationId;
  final NutritionPlanDetailsEntity plan;
}

final class NutritionPlansPageEntity {
  const NutritionPlansPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final List<NutritionPlanEntity> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
