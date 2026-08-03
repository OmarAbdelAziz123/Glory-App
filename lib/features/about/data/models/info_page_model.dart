import 'package:json_annotation/json_annotation.dart';

part 'info_page_model.g.dart';

@JsonSerializable()
final class InfoPageModel {
  const InfoPageModel({
    required this.id,
    required this.key,
    required this.titleEn,
    required this.titleAr,
    required this.contentEn,
    required this.contentAr,
    this.imageUrl,
    required this.updatedAt,
  });

  factory InfoPageModel.fromJson(Map<String, dynamic> json) =>
      _$InfoPageModelFromJson(json);

  final String id;
  final String key;
  final String titleEn;
  final String titleAr;
  final String contentEn;
  final String contentAr;
  final String? imageUrl;
  final String updatedAt;
}
