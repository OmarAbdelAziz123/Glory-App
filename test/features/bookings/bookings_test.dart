import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:glory_gym/core/error/app_failure.dart';
import 'package:glory_gym/core/result/result.dart';
import 'package:glory_gym/core/utils/booking_utils.dart';
import 'package:glory_gym/features/bookings/data/mappers/booking_mappers.dart';
import 'package:glory_gym/features/bookings/data/models/booking_api_responses.dart';
import 'package:glory_gym/features/bookings/data/models/booking_model.dart';
import 'package:glory_gym/features/bookings/domain/entities/booking_entity.dart';
import 'package:glory_gym/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/bookings_list/bookings_list_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/class_evaluation/class_evaluation_cubit.dart';

import '../../helpers/fixtures.dart';

BookingEntity _bookingEntityFromJson(Map<String, dynamic> json) =>
    BookingModel.fromJson(json).toEntity();

final class _FakeBookingsRepository implements BookingsRepository {
  _FakeBookingsRepository({
    this.bookings = const [],
    this.checkInResult,
    this.questions = const [],
    this.rateResult,
    this.cancelResult,
  });

  final List<BookingEntity> bookings;
  final BookingCheckInResultEntity? checkInResult;
  final List<AssessmentQuestionEntity> questions;
  final BookingCheckInResultEntity? rateResult;
  final BookingEntity? cancelResult;

  @override
  Future<Result<BookingsPageEntity>> getBookings({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortOrder,
  }) async {
    return Success(
      BookingsPageEntity(
        items: bookings,
        page: 1,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<Result<BookingEntity>> getBookingById(String id) async {
    final booking = bookings.firstWhere((b) => b.id == id);
    return Success(booking);
  }

  @override
  Future<Result<BookingEntity>> cancelBooking(String id) async {
    return Success(cancelResult ?? _bookingEntityFromJson({
      ...bookingJson,
      'id': id,
      'status': 'CANCELED',
      'canCancel': false,
      'canCheckIn': false,
    }));
  }

  @override
  Future<Result<BookingCheckInResultEntity>> checkInBooking(String id) async {
    return Success(
      checkInResult ??
          BookingCheckInModel.fromJson({
            'id': id,
            'checkedInAt': '2026-08-01T18:22:00.000Z',
            'canCheckIn': false,
            'canRate': true,
            'package': bookingJson['package'],
            'instructor': bookingJson['instructor'],
            'subscription': bookingJson['subscription'],
          }).toResultEntity(),
    );
  }

  @override
  Future<Result<List<AssessmentQuestionEntity>>> getAssessmentQuestions() async {
    if (questions.isEmpty) {
      return Success([
        AssessmentQuestionModel.fromJson(assessmentQuestionJson).toEntity(),
      ]);
    }
    return Success(questions);
  }

  @override
  Future<Result<BookingCheckInResultEntity>> rateBooking({
    required String bookingId,
    required Map<String, int> answers,
  }) async {
    return Success(
      rateResult ??
          BookingCheckInModel.fromJson({
            'id': bookingId,
            'checkedInAt': '2026-08-01T18:22:00.000Z',
            'canCheckIn': false,
            'canRate': false,
            'package': bookingJson['package'],
            'instructor': bookingJson['instructor'],
            'subscription': bookingJson['subscription'],
          }).toResultEntity(),
    );
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
  });

  group('Booking models', () {
    test('parses booking list item', () {
      final model = BookingModel.fromJson(bookingJson);
      final entity = model.toEntity();

      expect(model.type, 'PT');
      expect(model.canCheckIn, isTrue);
      expect(model.canCancel, isTrue);
      expect(entity.packageNameAr, 'باقة تدريب شخصي');
      expect(entity.instructorName, 'احمد حسام');
    });

    test('maps check-in response', () {
      final result = BookingCheckInModel.fromJson({
        'id': 'booking-1',
        'checkedInAt': '2026-08-01T18:22:00.000Z',
        'canCheckIn': false,
        'canRate': true,
        'package': bookingJson['package'],
        'instructor': bookingJson['instructor'],
        'subscription': bookingJson['subscription'],
      }).toResultEntity();

      expect(result.remainingSessions, 3);
      expect(result.instructorName, 'احمد حسام');
    });
  });

  group('BookingUtils', () {
    test('localizes booking type labels', () {
      expect(BookingUtils.typeLabel('PT'), 'تدريب شخصي');
      expect(BookingUtils.typeLabel('CLASS'), 'حصة جماعية');
    });

    test('maps entity flags to booking card item', () {
      final entity = _bookingEntityFromJson(bookingJson);
      final item = BookingUtils.toBookingItem(
        entity,
        locale: 'ar',
        onCheckIn: () {},
        onCancel: () {},
      );

      expect(item.canCheckIn, isTrue);
      expect(item.canCancel, isTrue);
      expect(item.canRate, isFalse);
      expect(item.packageName, 'باقة تدريب شخصي');
    });
  });

  group('BookingsListCubit', () {
    test('loadBookings populates list from repository', () async {
      final booking = _bookingEntityFromJson(bookingJson);
      final cubit = BookingsListCubit(
        _FakeBookingsRepository(bookings: [booking]),
      );

      await cubit.loadBookings();

      expect(cubit.state.bookings, hasLength(1));
      expect(cubit.state.bookings.first.id, 'booking-1');

      await cubit.close();
    });

    test('cancelBooking updates booking flags', () async {
      final booking = _bookingEntityFromJson(bookingJson);
      final cubit = BookingsListCubit(
        _FakeBookingsRepository(bookings: [booking]),
      );

      await cubit.loadBookings();
      final success = await cubit.cancelBooking('booking-1');

      expect(success, isTrue);
      expect(cubit.state.bookings.first.canCancel, isFalse);
      expect(cubit.state.bookings.first.status, 'CANCELED');

      await cubit.close();
    });

    test('checkInBooking stores success result', () async {
      final booking = _bookingEntityFromJson(bookingJson);
      final cubit = BookingsListCubit(
        _FakeBookingsRepository(
          bookings: [booking],
          cancelResult: _bookingEntityFromJson(bookingCheckedInJson),
        ),
      );

      await cubit.loadBookings();
      final success = await cubit.checkInBooking('booking-1');

      expect(success, isTrue);
      expect(cubit.state.lastCheckInResult?.remainingSessions, 3);

      await cubit.close();
    });
  });

  group('ClassEvaluationCubit', () {
    test('loads questions and requires all answers before submit', () async {
      final cubit = ClassEvaluationCubit(
        _FakeBookingsRepository(),
        bookingId: 'booking-1',
      );

      await cubit.loadQuestions();

      expect(cubit.state.questions, hasLength(1));
      expect(cubit.state.canSubmit, isFalse);

      cubit.setAnswer('q1', 5);
      expect(cubit.state.canSubmit, isTrue);

      await cubit.close();
    });

    test('submit sends rating successfully', () async {
      final cubit = ClassEvaluationCubit(
        _FakeBookingsRepository(),
        bookingId: 'booking-1',
      );

      await cubit.loadQuestions();
      cubit.setAnswer('q1', 4);

      final success = await cubit.submit();

      expect(success, isTrue);
      expect(cubit.state.status, ClassEvaluationStatus.success);

      await cubit.close();
    });
  });
}
