// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingPackageModel _$BookingPackageModelFromJson(Map<String, dynamic> json) =>
    BookingPackageModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameAr: json['nameAr'] as String,
      membershipType: json['membershipType'] as String,
    );

Map<String, dynamic> _$BookingPackageModelToJson(
  BookingPackageModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameEn': instance.nameEn,
  'nameAr': instance.nameAr,
  'membershipType': instance.membershipType,
};

BookingBranchModel _$BookingBranchModelFromJson(Map<String, dynamic> json) =>
    BookingBranchModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
    );

Map<String, dynamic> _$BookingBranchModelToJson(BookingBranchModel instance) =>
    <String, dynamic>{'id': instance.id, 'nameEn': instance.nameEn};

BookingInstructorModel _$BookingInstructorModelFromJson(
  Map<String, dynamic> json,
) => BookingInstructorModel(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$BookingInstructorModelToJson(
  BookingInstructorModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'avatarUrl': instance.avatarUrl,
};

BookingSubscriptionModel _$BookingSubscriptionModelFromJson(
  Map<String, dynamic> json,
) => BookingSubscriptionModel(
  id: json['id'] as String,
  remainingSessions: (json['remainingSessions'] as num).toInt(),
);

Map<String, dynamic> _$BookingSubscriptionModelToJson(
  BookingSubscriptionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'remainingSessions': instance.remainingSessions,
};

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['id'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  channel: json['channel'] as String,
  dateTime: DateTime.parse(json['dateTime'] as String),
  checkedInAt: json['checkedInAt'] == null
      ? null
      : DateTime.parse(json['checkedInAt'] as String),
  package: BookingPackageModel.fromJson(
    json['package'] as Map<String, dynamic>,
  ),
  branch: BookingBranchModel.fromJson(json['branch'] as Map<String, dynamic>),
  instructor: BookingInstructorModel.fromJson(
    json['instructor'] as Map<String, dynamic>,
  ),
  subscription: BookingSubscriptionModel.fromJson(
    json['subscription'] as Map<String, dynamic>,
  ),
  canCancel: json['canCancel'] as bool,
  canCheckIn: json['canCheckIn'] as bool,
  canRate: json['canRate'] as bool,
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'status': instance.status,
      'channel': instance.channel,
      'dateTime': instance.dateTime.toIso8601String(),
      'checkedInAt': instance.checkedInAt?.toIso8601String(),
      'package': instance.package,
      'branch': instance.branch,
      'instructor': instance.instructor,
      'subscription': instance.subscription,
      'canCancel': instance.canCancel,
      'canCheckIn': instance.canCheckIn,
      'canRate': instance.canRate,
    };
