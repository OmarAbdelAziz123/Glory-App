import '../../domain/entities/onboarding_question_entity.dart';

/// Local catalog used when the questions API is not deployed yet.
abstract final class OnboardingFallbackQuestions {
  static const questions = <OnboardingQuestionEntity>[
    OnboardingQuestionEntity(
      id: 'fallback_full_name',
      questionEn: 'Full name',
      questionAr: 'الاسم الكامل',
      type: OnboardingQuestionType.text,
      options: [],
      required: true,
      sortOrder: 1,
    ),
    OnboardingQuestionEntity(
      id: 'fallback_age',
      questionEn: 'Age',
      questionAr: 'العمر',
      type: OnboardingQuestionType.number,
      options: [],
      required: true,
      sortOrder: 2,
    ),
    OnboardingQuestionEntity(
      id: 'fallback_gender',
      questionEn: 'Gender',
      questionAr: 'الجنس',
      type: OnboardingQuestionType.singleChoice,
      options: [
        OnboardingQuestionOptionEntity(
          value: 'MALE',
          labelEn: 'Male',
          labelAr: 'ذكر',
        ),
        OnboardingQuestionOptionEntity(
          value: 'FEMALE',
          labelEn: 'Female',
          labelAr: 'أنثى',
        ),
      ],
      required: true,
      sortOrder: 3,
    ),
    OnboardingQuestionEntity(
      id: 'fallback_phone',
      questionEn: 'Phone number',
      questionAr: 'رقم الهاتف',
      type: OnboardingQuestionType.text,
      options: [],
      required: true,
      sortOrder: 4,
    ),
    OnboardingQuestionEntity(
      id: 'fallback_occupation',
      questionEn: 'Occupation',
      questionAr: 'المهنة',
      type: OnboardingQuestionType.text,
      options: [],
      required: true,
      sortOrder: 5,
    ),
  ];
}
