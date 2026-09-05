import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/booking_entity.dart';
import '../../../domain/repositories/bookings_repository.dart';

part 'class_evaluation_state.dart';

final class ClassEvaluationCubit extends Cubit<ClassEvaluationState> {
  ClassEvaluationCubit(this._repository, {required this.bookingId})
      : super(const ClassEvaluationState());

  final BookingsRepository _repository;
  final String bookingId;

  Future<void> loadQuestions() async {
    emit(
      state.copyWith(
        status: ClassEvaluationStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await _repository.getAssessmentQuestions();

    result.fold(
      onSuccess: (questions) {
        final sorted = [...questions]
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        emit(
          state.copyWith(
            status: ClassEvaluationStatus.loaded,
            questions: sorted,
          ),
        );
      },
      onFailure: (failure) => emit(
        state.copyWith(
          status: ClassEvaluationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void setAnswer(String questionId, int rating) {
    emit(
      state.copyWith(
        answers: {...state.answers, questionId: rating},
      ),
    );
  }

  Future<bool> submit() async {
    if (!state.canSubmit) return false;

    emit(
      state.copyWith(
        status: ClassEvaluationStatus.submitting,
        errorMessage: null,
      ),
    );

    final result = await _repository.rateBooking(
      bookingId: bookingId,
      answers: state.answers,
    );

    return result.when(
      success: (checkInResult) {
        emit(
          state.copyWith(
            status: ClassEvaluationStatus.success,
            result: checkInResult,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: ClassEvaluationStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }
}
