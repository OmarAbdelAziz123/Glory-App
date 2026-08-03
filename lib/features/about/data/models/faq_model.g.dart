// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqModel _$FaqModelFromJson(Map<String, dynamic> json) => FaqModel(
  id: json['id'] as String,
  questionEn: json['questionEn'] as String,
  questionAr: json['questionAr'] as String,
  answerEn: json['answerEn'] as String,
  answerAr: json['answerAr'] as String,
  sortOrder: (json['sortOrder'] as num).toInt(),
);

Map<String, dynamic> _$FaqModelToJson(FaqModel instance) => <String, dynamic>{
  'id': instance.id,
  'questionEn': instance.questionEn,
  'questionAr': instance.questionAr,
  'answerEn': instance.answerEn,
  'answerAr': instance.answerAr,
  'sortOrder': instance.sortOrder,
};
