import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/pagination_meta_model.dart';
import 'family_member_model.dart';

part 'family_api_responses.g.dart';

@JsonSerializable()
final class FamilyMemberApiResponse {
  const FamilyMemberApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory FamilyMemberApiResponse.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberApiResponseFromJson(json);

  final bool success;
  final FamilyMemberModel? data;
  final String? message;
}

@JsonSerializable()
final class FamilyMembersApiResponse {
  const FamilyMembersApiResponse({
    required this.success,
    this.data,
    this.meta,
    this.message,
  });

  factory FamilyMembersApiResponse.fromJson(Map<String, dynamic> json) =>
      _$FamilyMembersApiResponseFromJson(json);

  final bool success;
  final List<FamilyMemberModel>? data;
  final PaginationMetaModel? meta;
  final String? message;
}

@JsonSerializable()
final class FamilyActionApiResponse {
  const FamilyActionApiResponse({
    required this.success,
    this.message,
  });

  factory FamilyActionApiResponse.fromJson(Map<String, dynamic> json) =>
      _$FamilyActionApiResponseFromJson(json);

  final bool success;
  final String? message;
}
