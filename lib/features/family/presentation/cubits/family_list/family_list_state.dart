part of 'family_list_cubit.dart';

enum FamilyListStatus { initial, loading, loaded, loadingMore, deleting, failure }

final class FamilyListState extends Equatable {
  const FamilyListState({
    this.status = FamilyListStatus.initial,
    this.members = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
    this.deletingMemberId,
  });

  final FamilyListStatus status;
  final List<FamilyMemberEntity> members;
  final int page;
  final int totalPages;
  final String? errorMessage;
  final String? deletingMemberId;

  bool get isLoading => status == FamilyListStatus.loading;
  bool get isLoadingMore => status == FamilyListStatus.loadingMore;
  bool get hasMore => page < totalPages;
  bool get isEmpty => members.isEmpty && !isLoading;

  FamilyListState copyWith({
    FamilyListStatus? status,
    List<FamilyMemberEntity>? members,
    int? page,
    int? totalPages,
    String? errorMessage,
    String? deletingMemberId,
    bool clearDeletingMemberId = false,
  }) =>
      FamilyListState(
        status: status ?? this.status,
        members: members ?? this.members,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        errorMessage: errorMessage,
        deletingMemberId: clearDeletingMemberId
            ? null
            : deletingMemberId ?? this.deletingMemberId,
      );

  @override
  List<Object?> get props =>
      [status, members, page, totalPages, errorMessage, deletingMemberId];
}
