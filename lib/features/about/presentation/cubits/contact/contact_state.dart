part of 'contact_cubit.dart';

enum ContactStatus { initial, loading, loaded, failure }

final class ContactState extends Equatable {
  const ContactState({
    this.status = ContactStatus.initial,
    this.links,
    this.errorMessage,
  });

  final ContactStatus status;
  final ContactLinksEntity? links;
  final String? errorMessage;

  bool get isLoading => status == ContactStatus.loading;

  ContactState copyWith({
    ContactStatus? status,
    ContactLinksEntity? links,
    String? errorMessage,
  }) =>
      ContactState(
        status: status ?? this.status,
        links: links ?? this.links,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, links, errorMessage];
}
