import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/family_member_entity.dart';
import '../../../domain/repositories/family_repository.dart';

part 'family_form_state.dart';

final class FamilyFormCubit extends Cubit<FamilyFormState> {
  FamilyFormCubit(this._repository) : super(const FamilyFormState());

  final FamilyRepository _repository;

  Future<bool> submit({
    FamilyMemberEntity? existingMember,
    required String fullName,
    required DateTime dateOfBirth,
    required String gender,
    required String relation,
  }) async {
    emit(state.copyWith(status: FamilyFormStatus.submitting, errorMessage: null));

    final result = existingMember == null
        ? await _repository.addFamilyMember(
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            relation: relation,
          )
        : await _repository.updateFamilyMember(
            id: existingMember.id,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            gender: gender,
            relation: relation,
          );

    return result.when(
      success: (member) {
        emit(
          state.copyWith(
            status: FamilyFormStatus.success,
            member: member,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: FamilyFormStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  void reset() => emit(const FamilyFormState());
}
