// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrStatusModel _$QrStatusModelFromJson(Map<String, dynamic> json) =>
    QrStatusModel(
      id: json['id'] as String,
      status: json['status'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      consumedAt: json['consumedAt'] == null
          ? null
          : DateTime.parse(json['consumedAt'] as String),
      checkIn: json['checkIn'],
      daysRemaining: (json['daysRemaining'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QrStatusModelToJson(QrStatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'consumedAt': instance.consumedAt?.toIso8601String(),
      'checkIn': instance.checkIn,
      'daysRemaining': instance.daysRemaining,
    };
