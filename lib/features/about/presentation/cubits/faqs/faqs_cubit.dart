import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/content_entities.dart';
import '../../../domain/repositories/content_repository.dart';

part 'faqs_state.dart';

final class FaqsCubit extends Cubit<FaqsState> {
  FaqsCubit(this._repository) : super(const FaqsState());

  final ContentRepository _repository;

  Future<void> loadFaqs() async {
    emit(state.copyWith(status: FaqsStatus.loading, errorMessage: null));

    final result = await _repository.getFaqs();

    result.fold(
      onSuccess: (faqs) => emit(
        state.copyWith(status: FaqsStatus.loaded, faqs: faqs),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: FaqsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
