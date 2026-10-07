part of 'contact_cubit.dart';

enum ContactStatus { initial, loading, loaded, failure }

final class ContactState extends Equatable {
  const ContactState({
    this.status = ContactStatus.initial,
    this.channels = const [],
    this.errorMessage,
  });

  final ContactStatus status;
  final List<ContactChannelEntity> channels;
  final String? errorMessage;

  bool get isLoading => status == ContactStatus.loading;

  ContactState copyWith({
    ContactStatus? status,
    List<ContactChannelEntity>? channels,
    String? errorMessage,
  }) =>
      ContactState(
        status: status ?? this.status,
        channels: channels ?? this.channels,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, channels, errorMessage];
}
