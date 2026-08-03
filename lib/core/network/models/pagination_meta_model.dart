import 'package:json_annotation/json_annotation.dart';

part 'pagination_meta_model.g.dart';

@JsonSerializable()
final class PaginationMetaModel {
  const PaginationMetaModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaModelFromJson(json);

  final int page;
  final int limit;
  final int total;
  final int totalPages;
}
