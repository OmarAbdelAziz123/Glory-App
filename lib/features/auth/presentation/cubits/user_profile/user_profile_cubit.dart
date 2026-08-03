import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/profile_utils.dart';
import '../../../domain/entities/member_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'user_profile_state.dart';

final class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this._repository) : super(const UserProfileState());

  final AuthRepository _repository;

  Future<void> fetchProfile() async {
    emit(state.copyWith(status: UserProfileStatus.loading, errorMessage: null));

    final result = await _repository.getProfile();

    result.fold(
      onSuccess: (member) => emit(
        state.copyWith(
          status: UserProfileStatus.loaded,
          member: member,
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: UserProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  void setMember(MemberEntity member) {
    emit(
      state.copyWith(
        status: UserProfileStatus.loaded,
        member: member,
      ),
    );
  }

  void clear() => emit(const UserProfileState());

  Future<void> updatePushNotifications(bool enabled) async {
    final current = state.member;
    if (current == null) return;

    final previousEnabled = current.pushEnabled;

    emit(
      state.copyWith(
        status: UserProfileStatus.updatingNotifications,
        member: current.copyWith(pushEnabled: enabled),
        errorMessage: null,
      ),
    );

    final result = await _repository.updatePushNotifications(enabled: enabled);

    result.fold(
      onSuccess: (pushEnabled) => emit(
        state.copyWith(
          status: UserProfileStatus.loaded,
          member: current.copyWith(pushEnabled: pushEnabled),
        ),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: UserProfileStatus.loaded,
          member: current.copyWith(pushEnabled: previousEnabled),
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
