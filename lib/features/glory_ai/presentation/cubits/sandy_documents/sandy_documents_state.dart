part of 'sandy_documents_cubit.dart';

enum SandyDocumentsStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  deleting,
  failure,
}

final class SandyDocumentsState extends Equatable {
  const SandyDocumentsState({
    this.status = SandyDocumentsStatus.initial,
    this.documents = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
    this.deletingDocumentId,
  });

  final SandyDocumentsStatus status;
  final List<SandyMedicalDocumentEntity> documents;
  final int page;
  final int totalPages;
  final String? errorMessage;
  final String? deletingDocumentId;

  bool get isLoading => status == SandyDocumentsStatus.loading;
  bool get isLoadingMore => status == SandyDocumentsStatus.loadingMore;
  bool get hasMore => page < totalPages;
  bool get isEmpty => documents.isEmpty && !isLoading;

  SandyDocumentsState copyWith({
    SandyDocumentsStatus? status,
    List<SandyMedicalDocumentEntity>? documents,
    int? page,
    int? totalPages,
    String? errorMessage,
    String? deletingDocumentId,
    bool clearDeletingDocumentId = false,
  }) {
    return SandyDocumentsState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
      deletingDocumentId: clearDeletingDocumentId
          ? null
          : deletingDocumentId ?? this.deletingDocumentId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        documents,
        page,
        totalPages,
        errorMessage,
        deletingDocumentId,
      ];
}
