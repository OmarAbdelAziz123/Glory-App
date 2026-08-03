// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_generate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrGenerateModel _$QrGenerateModelFromJson(Map<String, dynamic> json) =>
    QrGenerateModel(
      id: json['id'] as String,
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$QrGenerateModelToJson(QrGenerateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'expiresInSeconds': instance.expiresInSeconds,
    };
