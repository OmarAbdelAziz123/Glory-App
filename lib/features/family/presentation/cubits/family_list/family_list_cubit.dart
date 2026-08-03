import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/family_member_entity.dart';
import '../../../domain/repositories/family_repository.dart';

part 'family_list_state.dart';

final class FamilyListCubit extends Cubit<FamilyListState> {
  FamilyListCubit(this._repository) : super(const FamilyListState());

  final FamilyRepository _repository;
  static const _pageSize = 10;

  Future<void> loadMembers({bool refresh = false}) async {
    emit(
      state.copyWith(
        status: FamilyListStatus.loading,
        errorMessage: null,
        members: refresh ? [] : state.members,
        page: 1,
      ),
    );

    final result = await _repository.getFamilyMembers(page: 1, limit: _pageSize);

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: FamilyListStatus.loaded,
          members: page.items,
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: FamilyListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    emit(state.copyWith(status: FamilyListStatus.loadingMore));

    final nextPage = state.page + 1;
    final result = await _repository.getFamilyMembers(
      page: nextPage,
      limit: _pageSize,
    );

    result.fold(
      onSuccess: (page) => emit(
        state.copyWith(
          status: FamilyListStatus.loaded,
          members: [...state.members, ...page.items],
          page: page.page,
          totalPages: page.totalPages,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: FamilyListStatus.loaded,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<bool> deleteMember(String id) async {
    emit(
      state.copyWith(
        status: FamilyListStatus.deleting,
        deletingMemberId: id,
        errorMessage: null,
      ),
    );

    final result = await _repository.deleteFamilyMember(id);

    return result.when(
      success: (_) {
        final updatedMembers =
            state.members.where((member) => member.id != id).toList();
        emit(
          state.copyWith(
            status: FamilyListStatus.loaded,
            members: updatedMembers,
            clearDeletingMemberId: true,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: FamilyListStatus.loaded,
            errorMessage: failure.message,
            clearDeletingMemberId: true,
          ),
        );
        return false;
      },
    );
  }
}
