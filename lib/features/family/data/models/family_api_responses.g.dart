// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberApiResponse _$FamilyMemberApiResponseFromJson(
  Map<String, dynamic> json,
) => FamilyMemberApiResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : FamilyMemberModel.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$FamilyMemberApiResponseToJson(
  FamilyMemberApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

FamilyMembersApiResponse _$FamilyMembersApiResponseFromJson(
  Map<String, dynamic> json,
) => FamilyMembersApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => FamilyMemberModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : PaginationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

Map<String, dynamic> _$FamilyMembersApiResponseToJson(
  FamilyMembersApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'meta': instance.meta,
  'message': instance.message,
};

FamilyActionApiResponse _$FamilyActionApiResponseFromJson(
  Map<String, dynamic> json,
) => FamilyActionApiResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
);

Map<String, dynamic> _$FamilyActionApiResponseToJson(
  FamilyActionApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
