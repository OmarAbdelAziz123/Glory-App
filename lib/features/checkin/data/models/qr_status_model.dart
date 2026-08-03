import 'package:json_annotation/json_annotation.dart';

part 'qr_status_model.g.dart';

@JsonSerializable()
final class QrStatusModel {
  const QrStatusModel({
    required this.id,
    required this.status,
    required this.expiresAt,
    this.consumedAt,
    this.checkIn,
    this.daysRemaining,
  });

  factory QrStatusModel.fromJson(Map<String, dynamic> json) =>
      _$QrStatusModelFromJson(json);

  final String id;
  final String status;
  final DateTime expiresAt;
  final DateTime? consumedAt;
  final dynamic checkIn;
  final int? daysRemaining;
}
