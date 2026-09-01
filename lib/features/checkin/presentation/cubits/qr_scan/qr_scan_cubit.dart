import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/l10n/fallback_messages.dart';
import '../../../domain/entities/qr_session_entity.dart';
import '../../../domain/repositories/checkin_repository.dart';

part 'qr_scan_state.dart';

final class QrScanCubit extends Cubit<QrScanState> {
  QrScanCubit(this._repository) : super(const QrScanState());

  final CheckinRepository _repository;

  Future<bool> scan(String rawValue) async {
    final token = _extractToken(rawValue);
    if (token.isEmpty) {
      emit(
        state.copyWith(
          status: QrScanStatus.failure,
          errorMessage: FallbackMessages.invalidQrCode,
        ),
      );
      return false;
    }

    emit(state.copyWith(status: QrScanStatus.submitting, errorMessage: null));

    final result = await _repository.scanQr(token);

    return result.when(
      success: (status) {
        emit(
          state.copyWith(
            status: QrScanStatus.success,
            result: status,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: QrScanStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  void reset() {
    emit(const QrScanState());
  }

  String _extractToken(String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return trimmed;

    final queryToken = uri.queryParameters['token'] ??
        uri.queryParameters['code'] ??
        uri.queryParameters['qr'];
    if (queryToken != null && queryToken.isNotEmpty) {
      return queryToken;
    }

    if (uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }

    return trimmed;
  }
}
