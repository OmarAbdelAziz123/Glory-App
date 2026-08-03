import 'package:json_annotation/json_annotation.dart';

part 'qr_generate_model.g.dart';

@JsonSerializable()
final class QrGenerateModel {
  const QrGenerateModel({
    required this.id,
    required this.token,
    required this.expiresAt,
    required this.expiresInSeconds,
  });

  factory QrGenerateModel.fromJson(Map<String, dynamic> json) =>
      _$QrGenerateModelFromJson(json);

  final String id;
  final String token;
  final DateTime expiresAt;
  final int expiresInSeconds;
}
