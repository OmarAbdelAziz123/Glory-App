// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyRecordCreatedByModel _$BodyRecordCreatedByModelFromJson(
  Map<String, dynamic> json,
) => BodyRecordCreatedByModel(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
);

Map<String, dynamic> _$BodyRecordCreatedByModelToJson(
  BodyRecordCreatedByModel instance,
) => <String, dynamic>{'id': instance.id, 'fullName': instance.fullName};

BodyRecordModel _$BodyRecordModelFromJson(Map<String, dynamic> json) =>
    BodyRecordModel(
      id: json['id'] as String,
      type: json['type'] as String,
      weight: json['weight'] as String?,
      muscleMass: json['muscleMass'] as String?,
      bodyFat: json['bodyFat'] as String?,
      bodyWater: json['bodyWater'] as String?,
      visceralFat: json['visceralFat'] as String?,
      bmi: json['bmi'] as String?,
      bmr: json['bmr'] as String?,
      metabolicAge: _readNullableString(json['metabolicAge']),
      pdfUrl: json['pdfUrl'] as String?,
      source: json['source'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      createdBy: BodyRecordCreatedByModel.fromJson(
        json['createdBy'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BodyRecordModelToJson(BodyRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'weight': instance.weight,
      'muscleMass': instance.muscleMass,
      'bodyFat': instance.bodyFat,
      'bodyWater': instance.bodyWater,
      'visceralFat': instance.visceralFat,
      'bmi': instance.bmi,
      'bmr': instance.bmr,
      'metabolicAge': instance.metabolicAge,
      'pdfUrl': instance.pdfUrl,
      'source': instance.source,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };
