part of 'create_password_cubit.dart';

enum CreatePasswordStatus { initial, loading, success, failure }

final class CreatePasswordState extends Equatable {
  const CreatePasswordState({
    this.status = CreatePasswordStatus.initial,
    this.member,
    this.successMessage,
    this.errorMessage,
  });

  final CreatePasswordStatus status;
  final MemberEntity? member;
  final String? successMessage;
  final String? errorMessage;

  bool get isLoading => status == CreatePasswordStatus.loading;

  CreatePasswordState copyWith({
    CreatePasswordStatus? status,
    MemberEntity? member,
    String? successMessage,
    String? errorMessage,
  }) =>
      CreatePasswordState(
        status: status ?? this.status,
        member: member ?? this.member,
        successMessage: successMessage ?? this.successMessage,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, member, successMessage, errorMessage];
}
