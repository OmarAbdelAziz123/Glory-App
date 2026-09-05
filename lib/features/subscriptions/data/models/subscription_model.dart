import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
final class SubscriptionPackageModel {
  const SubscriptionPackageModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.membershipType,
    required this.durationUnit,
    required this.durationValue,
  });

  factory SubscriptionPackageModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPackageModelFromJson(json);

  final String id;
  final String nameEn;
  final String nameAr;
  final String membershipType;
  final String durationUnit;
  final int durationValue;
}

@JsonSerializable()
final class SubscriptionModel {
  const SubscriptionModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.price,
    required this.package,
    this.sessionCount,
    this.remainingSessions,
    this.remainingDays,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String price;
  final SubscriptionPackageModel package;
  final int? sessionCount;
  final int? remainingSessions;
  final int? remainingDays;
}
