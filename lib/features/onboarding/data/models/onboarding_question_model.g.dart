// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingQuestionOptionModel _$OnboardingQuestionOptionModelFromJson(
  Map<String, dynamic> json,
) => OnboardingQuestionOptionModel(
  value: json['value'] as String,
  labelEn: json['labelEn'] as String,
  labelAr: json['labelAr'] as String,
);

Map<String, dynamic> _$OnboardingQuestionOptionModelToJson(
  OnboardingQuestionOptionModel instance,
) => <String, dynamic>{
  'value': instance.value,
  'labelEn': instance.labelEn,
  'labelAr': instance.labelAr,
};

OnboardingQuestionModel _$OnboardingQuestionModelFromJson(
  Map<String, dynamic> json,
) => OnboardingQuestionModel(
  id: json['id'] as String,
  questionEn: json['questionEn'] as String,
  questionAr: json['questionAr'] as String,
  type: json['type'] as String,
  options:
      (json['options'] as List<dynamic>?)
          ?.map(
            (e) => OnboardingQuestionOptionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  required: json['required'] as bool,
  showOnlyIfQuestionId: json['showIfQuestionId'] as String?,
  showOnlyIfAnswerValue: json['showIfValue'],
  sortOrder: (json['sortOrder'] as num).toInt(),
);

Map<String, dynamic> _$OnboardingQuestionModelToJson(
  OnboardingQuestionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'questionEn': instance.questionEn,
  'questionAr': instance.questionAr,
  'type': instance.type,
  'options': instance.options,
  'required': instance.required,
  'showIfQuestionId': instance.showOnlyIfQuestionId,
  'showIfValue': instance.showOnlyIfAnswerValue,
  'sortOrder': instance.sortOrder,
};

OnboardingQuestionsApiResponse _$OnboardingQuestionsApiResponseFromJson(
  Map<String, dynamic> json,
) => OnboardingQuestionsApiResponse(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => OnboardingQuestionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$OnboardingQuestionsApiResponseToJson(
  OnboardingQuestionsApiResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};
