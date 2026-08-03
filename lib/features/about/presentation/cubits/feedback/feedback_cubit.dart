import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/content_repository.dart';

part 'feedback_state.dart';

final class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit(this._repository) : super(const FeedbackState());

  final ContentRepository _repository;

  Future<bool> submitFeedback(String message) async {
    emit(state.copyWith(status: FeedbackStatus.submitting, errorMessage: null));

    final result = await _repository.submitFeedback(message: message);

    return result.when(
      success: (_) {
        emit(state.copyWith(status: FeedbackStatus.success));
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: FeedbackStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  void reset() => emit(const FeedbackState());
}
