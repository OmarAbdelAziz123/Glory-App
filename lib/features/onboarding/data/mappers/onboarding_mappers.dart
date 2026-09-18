import '../../domain/entities/onboarding_prefill_entity.dart';
import '../../domain/entities/onboarding_question_entity.dart';
import '../models/onboarding_prefill_model.dart';
import '../models/onboarding_question_model.dart';

extension OnboardingQuestionOptionModelX on OnboardingQuestionOptionModel {
  OnboardingQuestionOptionEntity toEntity() => OnboardingQuestionOptionEntity(
        value: value,
        labelEn: labelEn,
        labelAr: labelAr,
      );
}

extension OnboardingQuestionModelX on OnboardingQuestionModel {
  OnboardingQuestionEntity? toEntity() {
    final parsedType = OnboardingQuestionType.fromApi(type);
    if (parsedType == null) return null;

    return OnboardingQuestionEntity(
      id: id,
      questionEn: questionEn,
      questionAr: questionAr,
      type: parsedType,
      options: options.map((option) => option.toEntity()).toList(),
      required: required,
      showOnlyIfQuestionId: showOnlyIfQuestionId,
      showOnlyIfAnswerValue: showOnlyIfAnswerValue,
      sortOrder: sortOrder,
    );
  }
}

extension OnboardingPrefillModelX on OnboardingPrefillModel {
  OnboardingPrefillEntity toEntity() => OnboardingPrefillEntity(
        fullName: fullName,
        gender: gender,
        phone: phone,
        phoneCountryCode: phoneCountryCode,
      );
}

extension OnboardingStatusModelX on OnboardingStatusModel {
  OnboardingStatusEntity toEntity() => OnboardingStatusEntity(
        completed: completed,
        prefill: prefill?.toEntity(),
      );
}
