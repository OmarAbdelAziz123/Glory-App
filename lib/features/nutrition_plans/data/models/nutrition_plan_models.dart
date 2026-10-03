import '../../domain/entities/nutrition_plan_entities.dart';

Map<String, dynamic> asStringKeyedMap(dynamic value) {
  if (value is! Map) return const {};
  return value.map((key, item) => MapEntry(key.toString(), item));
}

NutritionPlanGoal readNutritionPlanGoal(dynamic value) {
  return switch (value?.toString().toUpperCase()) {
    'FAT_LOSS' => NutritionPlanGoal.fatLoss,
    'MUSCLE_GAIN' => NutritionPlanGoal.muscleGain,
    'RECOMPOSITION' => NutritionPlanGoal.recomposition,
    'MAINTENANCE' => NutritionPlanGoal.maintenance,
    _ => NutritionPlanGoal.unknown,
  };
}

int readNutritionInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.round();
  return int.tryParse(value.toString()) ?? 0;
}

double readNutritionDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

DateTime? readNutritionDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

List<String> readStringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList(growable: false);
}

NutritionPlanCoachEntity readNutritionCoach(dynamic value) {
  final map = asStringKeyedMap(value);
  return NutritionPlanCoachEntity(
    fullName: map['fullName']?.toString() ?? '',
  );
}

NutritionPlanMealEntity readNutritionMeal(dynamic value) {
  final map = asStringKeyedMap(value);
  return NutritionPlanMealEntity(
    name: map['name']?.toString() ?? '',
    time: map['time']?.toString() ?? '',
    items: readStringList(map['items']),
    notes: map['notes']?.toString(),
  );
}

NutritionPlanDetailsEntity readNutritionPlanDetails(dynamic value) {
  final map = asStringKeyedMap(value);
  final meals = (map['meals'] as List?)
          ?.map(readNutritionMeal)
          .toList(growable: false) ??
      const <NutritionPlanMealEntity>[];

  return NutritionPlanDetailsEntity(
    summary: map['summary']?.toString() ?? '',
    goal: readNutritionPlanGoal(map['goal']),
    dailyCalories: readNutritionInt(map['dailyCalories']),
    proteinG: readNutritionInt(map['proteinG']),
    carbsG: readNutritionInt(map['carbsG']),
    fatG: readNutritionInt(map['fatG']),
    waterLiters: readNutritionDouble(map['waterLiters']),
    meals: meals,
    guidelines: readStringList(map['guidelines']),
    avoid: readStringList(map['avoid']),
  );
}

NutritionPlanEntity readNutritionPlan(dynamic value) {
  final map = asStringKeyedMap(value);
  final testDate = readNutritionDate(map['testDate']);
  final approvedAt = readNutritionDate(map['approvedAt']);

  return NutritionPlanEntity(
    id: map['id']?.toString() ?? '',
    testDate: testDate ?? DateTime.fromMillisecondsSinceEpoch(0),
    approvedAt: approvedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    coach: readNutritionCoach(map['coach']),
    coachNote: map['coachNote']?.toString(),
    sandyConversationId: map['sandyConversationId']?.toString(),
    plan: readNutritionPlanDetails(map['plan']),
  );
}

NutritionPlanEntity? readNutritionPlanNullable(dynamic value) {
  if (value == null) return null;
  if (value is Map && value.isEmpty) return null;
  return readNutritionPlan(value);
}

NutritionPlansPageEntity readNutritionPlansPage(dynamic value) {
  final map = asStringKeyedMap(value);
  final items = (map['data'] as List?)
          ?.map(readNutritionPlan)
          .toList(growable: false) ??
      const <NutritionPlanEntity>[];
  final meta = asStringKeyedMap(map['meta']);

  return NutritionPlansPageEntity(
    items: items,
    page: (meta['page'] as num?)?.toInt() ?? 1,
    limit: (meta['limit'] as num?)?.toInt() ?? items.length,
    total: (meta['total'] as num?)?.toInt() ?? items.length,
    totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
  );
}
