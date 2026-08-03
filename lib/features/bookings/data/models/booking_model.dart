import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable()
final class BookingPackageModel {
  const BookingPackageModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.membershipType,
  });

  factory BookingPackageModel.fromJson(Map<String, dynamic> json) =>
      _$BookingPackageModelFromJson(json);

  final String id;
  final String nameEn;
  final String nameAr;
  final String membershipType;
}

@JsonSerializable()
final class BookingBranchModel {
  const BookingBranchModel({
    required this.id,
    required this.nameEn,
  });

  factory BookingBranchModel.fromJson(Map<String, dynamic> json) =>
      _$BookingBranchModelFromJson(json);

  final String id;
  final String nameEn;
}

@JsonSerializable()
final class BookingInstructorModel {
  const BookingInstructorModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
  });

  factory BookingInstructorModel.fromJson(Map<String, dynamic> json) =>
      _$BookingInstructorModelFromJson(json);

  final String id;
  final String fullName;
  final String? avatarUrl;
}

@JsonSerializable()
final class BookingSubscriptionModel {
  const BookingSubscriptionModel({
    required this.id,
    required this.remainingSessions,
  });

  factory BookingSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$BookingSubscriptionModelFromJson(json);

  final String id;
  final int remainingSessions;
}

@JsonSerializable()
final class BookingModel {
  const BookingModel({
    required this.id,
    required this.type,
    required this.status,
    required this.channel,
    required this.dateTime,
    this.checkedInAt,
    required this.package,
    required this.branch,
    required this.instructor,
    required this.subscription,
    required this.canCancel,
    required this.canCheckIn,
    required this.canRate,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  final String id;
  final String type;
  final String status;
  final String channel;
  final DateTime dateTime;
  final DateTime? checkedInAt;
  final BookingPackageModel package;
  final BookingBranchModel branch;
  final BookingInstructorModel instructor;
  final BookingSubscriptionModel subscription;
  final bool canCancel;
  final bool canCheckIn;
  final bool canRate;
}
