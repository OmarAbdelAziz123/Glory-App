import 'package:json_annotation/json_annotation.dart';

import 'qr_generate_model.dart';
import 'qr_status_model.dart';

part 'checkin_api_responses.g.dart';

@JsonSerializable()
final class QrGenerateApiResponse {
  const QrGenerateApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory QrGenerateApiResponse.fromJson(Map<String, dynamic> json) =>
      _$QrGenerateApiResponseFromJson(json);

  final bool success;
  final QrGenerateModel? data;
  final String? message;
}

@JsonSerializable()
final class QrStatusApiResponse {
  const QrStatusApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory QrStatusApiResponse.fromJson(Map<String, dynamic> json) =>
      _$QrStatusApiResponseFromJson(json);

  final bool success;
  final QrStatusModel? data;
  final String? message;
}
