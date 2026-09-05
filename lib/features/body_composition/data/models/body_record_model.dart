import 'package:json_annotation/json_annotation.dart';

part 'body_record_model.g.dart';

String? _readNullableString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

@JsonSerializable()
final class BodyRecordCreatedByModel {
  const BodyRecordCreatedByModel({
    required this.id,
    required this.fullName,
  });

  factory BodyRecordCreatedByModel.fromJson(Map<String, dynamic> json) =>
      _$BodyRecordCreatedByModelFromJson(json);

  final String id;
  final String fullName;
}

@JsonSerializable()
final class BodyRecordModel {
  const BodyRecordModel({
    required this.id,
    required this.type,
    this.weight,
    this.muscleMass,
    this.bodyFat,
    this.bodyWater,
    this.visceralFat,
    this.bmi,
    this.bmr,
    this.metabolicAge,
    this.pdfUrl,
    required this.source,
    required this.recordedAt,
    required this.createdBy,
  });

  factory BodyRecordModel.fromJson(Map<String, dynamic> json) =>
      _$BodyRecordModelFromJson(json);

  final String id;
  final String type;
  final String? weight;
  final String? muscleMass;
  final String? bodyFat;
  final String? bodyWater;
  final String? visceralFat;
  final String? bmi;
  final String? bmr;
  @JsonKey(fromJson: _readNullableString)
  final String? metabolicAge;
  final String? pdfUrl;
  final String source;
  final DateTime recordedAt;
  final BodyRecordCreatedByModel createdBy;
}
