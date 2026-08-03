part of 'family_form_cubit.dart';

enum FamilyFormStatus { initial, submitting, success, failure }

final class FamilyFormState extends Equatable {
  const FamilyFormState({
    this.status = FamilyFormStatus.initial,
    this.member,
    this.errorMessage,
  });

  final FamilyFormStatus status;
  final FamilyMemberEntity? member;
  final String? errorMessage;

  bool get isSubmitting => status == FamilyFormStatus.submitting;

  FamilyFormState copyWith({
    FamilyFormStatus? status,
    FamilyMemberEntity? member,
    String? errorMessage,
  }) =>
      FamilyFormState(
        status: status ?? this.status,
        member: member ?? this.member,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, member, errorMessage];
}
