import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/pagination_meta_model.dart';
import 'body_record_model.dart';

part 'body_record_api_responses.g.dart';

@JsonSerializable()
final class BodyRecordsApiResponse {
  const BodyRecordsApiResponse({
    required this.success,
    this.data,
    this.meta,
    this.message,
  });

  factory BodyRecordsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$BodyRecordsApiResponseFromJson(json);

  final bool success;
  final List<BodyRecordModel>? data;
  final PaginationMetaModel? meta;
  final String? message;
}
