import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/sandy_entities.dart';
import '../../../domain/repositories/sandy_repository.dart';

part 'sandy_documents_state.dart';

final class SandyDocumentsCubit extends Cubit<SandyDocumentsState> {
  SandyDocumentsCubit(this._repository) : super(const SandyDocumentsState());

  final SandyRepository _repository;
  static const _pageSize = 20;

  Future<void> loadDocuments({bool refresh = false}) async {
    emit(
      state.copyWith(
        status: SandyDocumentsStatus.loading,
        errorMessage: null,
        documents: refresh ? [] : state.documents,
        page: 1,
      ),
    );

    final result = await _repository.getDocuments(page: 1, limit: _pageSize);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: SandyDocumentsStatus.loaded,
          documents: page.items,
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: SandyDocumentsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: SandyDocumentsStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getDocuments(
      page: nextPage,
      limit: _pageSize,
    );

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: SandyDocumentsStatus.loaded,
          documents: [...state.documents, ...page.items],
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: SandyDocumentsStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<bool> deleteDocument(String id) async {
    emit(
      state.copyWith(
        status: SandyDocumentsStatus.deleting,
        deletingDocumentId: id,
        errorMessage: null,
      ),
    );

    final result = await _repository.deleteDocument(id);

    return result.when(
      success: (_) {
        emit(
          state.copyWith(
            status: SandyDocumentsStatus.loaded,
            documents: state.documents.where((doc) => doc.id != id).toList(),
            clearDeletingDocumentId: true,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: SandyDocumentsStatus.loaded,
            errorMessage: failure.message,
            clearDeletingDocumentId: true,
          ),
        );
        return false;
      },
    );
  }
}
