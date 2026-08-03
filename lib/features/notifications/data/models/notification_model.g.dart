// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleAr: json['titleAr'] as String,
      bodyEn: json['bodyEn'] as String,
      bodyAr: json['bodyAr'] as String,
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String?,
      read: json['read'] as bool,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleEn': instance.titleEn,
      'titleAr': instance.titleAr,
      'bodyEn': instance.bodyEn,
      'bodyAr': instance.bodyAr,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'read': instance.read,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

UnreadCountModel _$UnreadCountModelFromJson(Map<String, dynamic> json) =>
    UnreadCountModel(count: (json['count'] as num).toInt());

Map<String, dynamic> _$UnreadCountModelToJson(UnreadCountModel instance) =>
    <String, dynamic>{'count': instance.count};

ReadAllModel _$ReadAllModelFromJson(Map<String, dynamic> json) =>
    ReadAllModel(updated: (json['updated'] as num).toInt());

Map<String, dynamic> _$ReadAllModelToJson(ReadAllModel instance) =>
    <String, dynamic>{'updated': instance.updated};
