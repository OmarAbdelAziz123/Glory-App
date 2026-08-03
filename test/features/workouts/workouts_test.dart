import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:glory_gym/core/result/result.dart';
import 'package:glory_gym/core/utils/workout_utils.dart';
import 'package:glory_gym/features/home/presentation/widgets/group_class_card.dart';
import 'package:glory_gym/features/workouts/data/mappers/workout_mappers.dart';
import 'package:glory_gym/features/workouts/data/models/workout_models.dart';
import 'package:glory_gym/features/workouts/domain/entities/workout_entity.dart';
import 'package:glory_gym/features/workouts/domain/repositories/workouts_repository.dart';
import 'package:glory_gym/features/workouts/presentation/cubits/workout_detail/workout_detail_cubit.dart';
import 'package:glory_gym/features/workouts/presentation/cubits/workouts_list/workouts_list_cubit.dart';

import '../../helpers/fixtures.dart';

WorkoutAssignmentEntity _assignmentFromJson(Map<String, dynamic> json) =>
    WorkoutAssignmentListModel.fromJson(json).toEntity();

WorkoutAssignmentDetailEntity _detailFromJson(Map<String, dynamic> json) =>
    WorkoutAssignmentDetailModel.fromJson(json).toEntity();

final class _FakeWorkoutsRepository implements WorkoutsRepository {
  _FakeWorkoutsRepository({
    this.assignments = const [],
    this.detail,
    this.videos = const [],
    this.addWeightResult,
  });

  final List<WorkoutAssignmentEntity> assignments;
  final WorkoutAssignmentDetailEntity? detail;
  final List<WorkoutVideoEntity> videos;
  final WorkoutAssignmentDetailEntity? addWeightResult;

  @override
  Future<Result<WorkoutsPageEntity>> getWorkouts({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortOrder,
  }) async {
    return Success(
      WorkoutsPageEntity(
        items: assignments,
        page: page,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<Result<WorkoutAssignmentDetailEntity>> getWorkoutById(String id) async {
    return Success(
      detail ?? _detailFromJson({
        ...workoutDetailJson,
        'id': id,
      }),
    );
  }

  @override
  Future<Result<List<WorkoutVideoEntity>>> getWorkoutVideos(String id) async {
    if (videos.isEmpty) {
      return Success([WorkoutVideoModel.fromJson(workoutVideoJson).toEntity()]);
    }
    return Success(videos);
  }

  @override
  Future<Result<WorkoutAssignmentDetailEntity>> addWorkoutWeight({
    required String assignmentId,
    required String weight,
  }) async {
    return Success(
      addWeightResult ??
          _detailFromJson({
            ...workoutDetailAfterWeightJson,
            'id': assignmentId,
            'userWeight': weight,
          }),
    );
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  group('Workout models', () {
    test('parses in-progress assignment list item', () {
      final model = WorkoutAssignmentListModel.fromJson(workoutListItemJson);
      final entity = model.toEntity();

      expect(model.status, 'IN_PROGRESS');
      expect(model.workout.type, 'CARDIO');
      expect(entity.workoutNameAr, 'برنامج كارديو');
      expect(entity.instructorName, 'احمد حسام محمد');
      expect(entity.previewThumbnailUrl, isNotNull);
    });

    test('parses upcoming assignment with null dates', () {
      final model =
          WorkoutAssignmentListModel.fromJson(workoutUpcomingListItemJson);

      expect(model.startDate, isNull);
      expect(model.endDate, isNull);
      expect(model.status, 'UPCOMING');
    });

    test('parses detail with instructions and weight fields', () {
      final entity = _detailFromJson(workoutDetailJson);

      expect(entity.remainingDays, 22);
      expect(entity.canAddWeight, isTrue);
      expect(entity.suggestedWeight, '10.00');
      expect(entity.instructions, hasLength(2));
      expect(entity.instructions.first.videos.first.duration, '02:10');
    });

    test('parses flattened workout video', () {
      final video = WorkoutVideoModel.fromJson(workoutVideoJson).toEntity();

      expect(video.stepNumber, 1);
      expect(video.instructionAr, 'كارديو');
    });
  });

  group('WorkoutUtils', () {
    test('localizes workout type labels', () {
      expect(WorkoutUtils.typeLabel('CARDIO'), 'كارديو');
      expect(WorkoutUtils.typeLabel('STRENGTH'), 'قوة');
    });

    test('maps status to card badge', () {
      expect(
        WorkoutUtils.cardStatus('COMPLETED'),
        GroupClassStatus.completed,
      );
      expect(
        WorkoutUtils.cardStatus('IN_PROGRESS'),
        GroupClassStatus.ongoing,
      );
      expect(
        WorkoutUtils.cardStatus('UPCOMING'),
        GroupClassStatus.upcoming,
      );
    });

    test('maps in-progress entity to group class card item', () {
      final entity = _assignmentFromJson(workoutListItemJson);
      final item = WorkoutUtils.toGroupClassItem(entity, locale: 'ar');

      expect(item.className, 'برنامج كارديو');
      expect(item.classType, 'كارديو');
      expect(item.time, '40 يوم');
      expect(item.startDate, isNotEmpty);
      expect(item.issuedBy, isNull);
      expect(item.status, GroupClassStatus.ongoing);
    });

    test('maps upcoming entity with issuedBy instead of startDate', () {
      final entity = _assignmentFromJson(workoutUpcomingListItemJson);
      final item = WorkoutUtils.toGroupClassItem(entity, locale: 'ar');

      expect(item.startDate, isNull);
      expect(item.issuedBy, 'سارة علي');
      expect(item.status, GroupClassStatus.upcoming);
    });

    test('formats weight for API as decimal string', () {
      expect(WorkoutUtils.formatWeightForApi('20'), '20.00');
      expect(WorkoutUtils.formatWeightForApi('20.5'), '20.50');
    });

    test('formats weight labels with unit', () {
      expect(WorkoutUtils.weightLabel('10.00'), '10.00 كيلو');
      expect(WorkoutUtils.weightLabel(null), isEmpty);
    });
  });

  group('WorkoutsListCubit', () {
    test('loadWorkouts populates list from repository', () async {
      final assignment = _assignmentFromJson(workoutListItemJson);
      final cubit = WorkoutsListCubit(
        _FakeWorkoutsRepository(assignments: [assignment]),
      );

      await cubit.loadWorkouts();

      expect(cubit.state.workouts, hasLength(1));
      expect(cubit.state.workouts.first.id, 'assignment-1');

      await cubit.close();
    });
  });

  group('WorkoutDetailCubit', () {
    test('loadDetail loads assignment detail', () async {
      final cubit = WorkoutDetailCubit(
        _FakeWorkoutsRepository(),
        assignmentId: 'assignment-1',
      );

      await cubit.loadDetail();

      expect(cubit.state.detail?.id, 'assignment-1');
      expect(cubit.state.detail?.canAddWeight, isTrue);
      expect(cubit.state.detail?.instructions, hasLength(2));

      await cubit.close();
    });

    test('addWeight updates detail from response', () async {
      final cubit = WorkoutDetailCubit(
        _FakeWorkoutsRepository(
          addWeightResult: _detailFromJson(workoutDetailWithPreviousWeightJson),
        ),
        assignmentId: 'assignment-1',
      );

      await cubit.loadDetail();
      final success = await cubit.addWeight('25.00');

      expect(success, isTrue);
      expect(cubit.state.detail?.userWeight, '25.00');
      expect(cubit.state.detail?.userWeightLast, '20.00');

      await cubit.close();
    });
  });
}
