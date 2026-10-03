import 'package:flutter_test/flutter_test.dart';
import 'package:glory_gym/features/nutrition_plans/data/models/nutrition_plan_models.dart';
import 'package:glory_gym/features/nutrition_plans/domain/entities/nutrition_plan_entities.dart';

void main() {
  group('readNutritionPlan', () {
    test('parses full plan payload', () {
      final plan = readNutritionPlan({
        'id': 'cm123',
        'testDate': '2026-10-02T21:00:00.000Z',
        'approvedAt': '2026-10-03T08:10:00.000Z',
        'coach': {'fullName': 'Coach Sara'},
        'coachNote': 'Great progress',
        'sandyConversationId': 'cm456',
        'plan': {
          'summary': 'Weight down 1.5 kg',
          'goal': 'RECOMPOSITION',
          'dailyCalories': 2200,
          'proteinG': 150,
          'carbsG': 250,
          'fatG': 65,
          'waterLiters': 3,
          'meals': [
            {
              'name': 'Breakfast',
              'time': '08:00',
              'items': ['Oats 60g'],
              'notes': null,
            },
          ],
          'guidelines': ['Eat protein each meal'],
          'avoid': ['Sugary drinks'],
        },
      });

      expect(plan.id, 'cm123');
      expect(plan.coach.fullName, 'Coach Sara');
      expect(plan.plan.goal, NutritionPlanGoal.recomposition);
      expect(plan.plan.dailyCalories, 2200);
      expect(plan.plan.meals, hasLength(1));
      expect(plan.plan.meals.first.items.first, 'Oats 60g');
    });

    test('readNutritionPlanNullable returns null for null', () {
      expect(readNutritionPlanNullable(null), isNull);
    });
  });

  group('readNutritionPlansPage', () {
    test('parses paginated list', () {
      final page = readNutritionPlansPage({
        'data': [
          {
            'id': 'a',
            'testDate': '2026-10-02T21:00:00.000Z',
            'approvedAt': '2026-10-03T08:10:00.000Z',
            'coach': {'fullName': 'Coach'},
            'plan': {
              'summary': '',
              'goal': 'MAINTENANCE',
              'dailyCalories': 2000,
              'proteinG': 120,
              'carbsG': 200,
              'fatG': 60,
              'waterLiters': 2.5,
              'meals': [],
              'guidelines': [],
              'avoid': [],
            },
          },
        ],
        'meta': {'page': 1, 'limit': 20, 'total': 1, 'totalPages': 1},
      });

      expect(page.items, hasLength(1));
      expect(page.hasMore, isFalse);
    });
  });
}
