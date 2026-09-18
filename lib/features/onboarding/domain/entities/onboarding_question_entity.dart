enum OnboardingQuestionType {
  text,
  number,
  boolean,
  singleChoice,
  multiChoice,
  photo;

  static OnboardingQuestionType? fromApi(String raw) => switch (raw.toUpperCase()) {
        'TEXT' => OnboardingQuestionType.text,
        'NUMBER' => OnboardingQuestionType.number,
        'BOOLEAN' => OnboardingQuestionType.boolean,
        'SINGLE_CHOICE' => OnboardingQuestionType.singleChoice,
        'MULTI_CHOICE' => OnboardingQuestionType.multiChoice,
        'PHOTO' => OnboardingQuestionType.photo,
        _ => null,
      };
}

final class OnboardingQuestionOptionEntity {
  const OnboardingQuestionOptionEntity({
    required this.value,
    required this.labelEn,
    required this.labelAr,
  });

  final String value;
  final String labelEn;
  final String labelAr;
}

final class OnboardingQuestionEntity {
  const OnboardingQuestionEntity({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.type,
    required this.options,
    required this.required,
    this.showOnlyIfQuestionId,
    this.showOnlyIfAnswerValue,
    required this.sortOrder,
  });

  final String id;
  final String questionEn;
  final String questionAr;
  final OnboardingQuestionType type;
  final List<OnboardingQuestionOptionEntity> options;
  final bool required;
  final String? showOnlyIfQuestionId;
  final dynamic showOnlyIfAnswerValue;
  final int sortOrder;

  String labelFor(String locale) =>
      locale.startsWith('ar') ? questionAr : questionEn;
}
