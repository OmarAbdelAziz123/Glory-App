import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/inbody_entities.dart';
import '../../../domain/repositories/inbody_repository.dart';

part 'inbody_detail_state.dart';

final class InbodyDetailCubit extends Cubit<InbodyDetailState> {
  InbodyDetailCubit(this._repository, {required this.testId})
      : super(const InbodyDetailState());

  final InbodyRepository _repository;
  final String testId;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: InbodyDetailStatus.loading,
        clearError: true,
      ),
    );

    final result = await _repository.getTest(testId);
    if (isClosed) return;

    result.fold(
      onSuccess: (test) => emit(
        state.copyWith(
          status: InbodyDetailStatus.ready,
          test: test,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: InbodyDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
