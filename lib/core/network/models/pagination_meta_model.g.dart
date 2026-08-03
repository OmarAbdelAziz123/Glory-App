// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationMetaModel _$PaginationMetaModelFromJson(Map<String, dynamic> json) =>
    PaginationMetaModel(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationMetaModelToJson(
  PaginationMetaModel instance,
) => <String, dynamic>{
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'totalPages': instance.totalPages,
};
