part of 'faqs_cubit.dart';

enum FaqsStatus { initial, loading, loaded, failure }

final class FaqsState extends Equatable {
  const FaqsState({
    this.status = FaqsStatus.initial,
    this.faqs = const [],
    this.errorMessage,
  });

  final FaqsStatus status;
  final List<FaqEntity> faqs;
  final String? errorMessage;

  bool get isLoading => status == FaqsStatus.loading;

  FaqsState copyWith({
    FaqsStatus? status,
    List<FaqEntity>? faqs,
    String? errorMessage,
  }) =>
      FaqsState(
        status: status ?? this.status,
        faqs: faqs ?? this.faqs,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, faqs, errorMessage];
}
