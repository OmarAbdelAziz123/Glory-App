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

  String displayName(AppLocalizations l10n) =>
      member?.fullName ?? l10n.username;

  String get displayEmail => member?.email ?? '';

  String get displayPhone {
    final profile = member;
    if (profile == null) return '';
    return '${profile.phoneCountryCode} ${profile.phone}';
  }

  String displayBirthDate(AppLocalizations l10n) =>
      ProfileUtils.formatBirthDate(l10n, member?.dateOfBirth);

  String displayMaritalStatus(AppLocalizations l10n) =>
      ProfileUtils.maritalStatusLabel(l10n, member?.maritalStatus);

  String displayHealthNotes(AppLocalizations l10n) =>
      member?.healthNotes?.isNotEmpty == true
          ? member!.healthNotes!
          : l10n.noDiseases;

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
