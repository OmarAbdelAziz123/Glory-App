part of 'info_page_cubit.dart';

enum InfoPageStatus { initial, loading, loaded, failure }

final class InfoPageState extends Equatable {
  const InfoPageState({
    this.status = InfoPageStatus.initial,
    this.page,
    this.errorMessage,
  });

  final InfoPageStatus status;
  final InfoPageEntity? page;
  final String? errorMessage;

  bool get isLoading => status == InfoPageStatus.loading;

  InfoPageState copyWith({
    InfoPageStatus? status,
    InfoPageEntity? page,
    String? errorMessage,
  }) =>
      InfoPageState(
        status: status ?? this.status,
        page: page ?? this.page,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, page, errorMessage];
}
