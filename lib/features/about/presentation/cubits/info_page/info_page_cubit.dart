import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/content_entities.dart';
import '../../../domain/repositories/content_repository.dart';

part 'info_page_state.dart';

final class InfoPageCubit extends Cubit<InfoPageState> {
  InfoPageCubit(this._repository) : super(const InfoPageState());

  final ContentRepository _repository;

  Future<void> loadPage(String key) async {
    emit(state.copyWith(status: InfoPageStatus.loading, errorMessage: null));

    final result = await _repository.getInfoPageByKey(key);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(status: InfoPageStatus.loaded, page: page),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: InfoPageStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
