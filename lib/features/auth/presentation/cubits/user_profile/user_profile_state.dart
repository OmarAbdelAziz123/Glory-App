part of 'user_profile_cubit.dart';

enum UserProfileStatus {
  initial,
  loading,
  loaded,
  updatingNotifications,
  failure,
}

final class UserProfileState extends Equatable {
  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.member,
    this.errorMessage,
  });

  final UserProfileStatus status;
  final MemberEntity? member;
  final String? errorMessage;

  bool get isLoading => status == UserProfileStatus.loading;

  bool get isUpdatingNotifications =>
      status == UserProfileStatus.updatingNotifications;

  String get displayName => member?.fullName ?? 'اسم المستخدم';

  String get displayEmail => member?.email ?? '';

  String get displayPhone {
    final profile = member;
    if (profile == null) return '';
    return '${profile.phoneCountryCode} ${profile.phone}';
  }

  String get displayBirthDate => ProfileUtils.formatBirthDate(member?.dateOfBirth);

  String get displayMaritalStatus =>
      ProfileUtils.maritalStatusLabel(member?.maritalStatus);

  String get displayHealthNotes =>
      member?.healthNotes?.isNotEmpty == true
          ? member!.healthNotes!
          : 'لا توجد أمراض';

  bool get pushEnabled => member?.pushEnabled ?? false;

  UserProfileState copyWith({
    UserProfileStatus? status,
    MemberEntity? member,
    String? errorMessage,
  }) =>
      UserProfileState(
        status: status ?? this.status,
        member: member ?? this.member,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, member, errorMessage];
}
