import 'package:json_annotation/json_annotation.dart';

part 'faq_model.g.dart';

@JsonSerializable()
final class FaqModel {
  const FaqModel({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.answerAr,
    required this.sortOrder,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) =>
      _$FaqModelFromJson(json);

  final String id;
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String answerAr;
  final int sortOrder;
}
