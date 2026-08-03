import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/content_entities.dart';
import '../../../domain/repositories/content_repository.dart';

part 'contact_state.dart';

final class ContactCubit extends Cubit<ContactState> {
  ContactCubit(this._repository) : super(const ContactState());

  final ContentRepository _repository;

  Future<void> loadContactLinks() async {
    emit(state.copyWith(status: ContactStatus.loading, errorMessage: null));

    final result = await _repository.getContactLinks();

    result.fold(
      onSuccess: (links) => emit(
        state.copyWith(status: ContactStatus.loaded, links: links),
      ),
      onFailure: (failure) => emit(
        state.copyWith(
          status: ContactStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }
}
