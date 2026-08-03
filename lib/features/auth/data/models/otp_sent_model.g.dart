// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_sent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpSentModel _$OtpSentModelFromJson(Map<String, dynamic> json) => OtpSentModel(
  email: json['email'] as String,
  purpose: json['purpose'] as String,
  expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
  resendCooldownSeconds: (json['resendCooldownSeconds'] as num).toInt(),
);

Map<String, dynamic> _$OtpSentModelToJson(OtpSentModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'purpose': instance.purpose,
      'expiresInSeconds': instance.expiresInSeconds,
      'resendCooldownSeconds': instance.resendCooldownSeconds,
    };
