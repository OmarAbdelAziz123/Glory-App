// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPackageModel _$SubscriptionPackageModelFromJson(
  Map<String, dynamic> json,
) => SubscriptionPackageModel(
  id: json['id'] as String,
  nameEn: json['nameEn'] as String,
  nameAr: json['nameAr'] as String,
  membershipType: json['membershipType'] as String,
  durationUnit: json['durationUnit'] as String,
  durationValue: (json['durationValue'] as num).toInt(),
);

Map<String, dynamic> _$SubscriptionPackageModelToJson(
  SubscriptionPackageModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameEn': instance.nameEn,
  'nameAr': instance.nameAr,
  'membershipType': instance.membershipType,
  'durationUnit': instance.durationUnit,
  'durationValue': instance.durationValue,
};

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: json['status'] as String,
      price: json['price'] as String,
      package: SubscriptionPackageModel.fromJson(
        json['package'] as Map<String, dynamic>,
      ),
      sessionCount: (json['sessionCount'] as num?)?.toInt(),
      remainingSessions: (json['remainingSessions'] as num?)?.toInt(),
      remainingDays: (json['remainingDays'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': instance.status,
      'price': instance.price,
      'package': instance.package,
      'sessionCount': instance.sessionCount,
      'remainingSessions': instance.remainingSessions,
      'remainingDays': instance.remainingDays,
    };
