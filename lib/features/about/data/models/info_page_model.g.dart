// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoPageModel _$InfoPageModelFromJson(Map<String, dynamic> json) =>
    InfoPageModel(
      id: json['id'] as String,
      key: json['key'] as String,
      titleEn: json['titleEn'] as String,
      titleAr: json['titleAr'] as String,
      contentEn: json['contentEn'] as String,
      contentAr: json['contentAr'] as String,
      imageUrl: json['imageUrl'] as String?,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$InfoPageModelToJson(InfoPageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'titleEn': instance.titleEn,
      'titleAr': instance.titleAr,
      'contentEn': instance.contentEn,
      'contentAr': instance.contentAr,
      'imageUrl': instance.imageUrl,
      'updatedAt': instance.updatedAt,
    };
