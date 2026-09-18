import 'package:flutter_test/flutter_test.dart';
import 'package:glory_gym/features/onboarding/data/mappers/onboarding_submit_mapper.dart';
import 'package:glory_gym/features/onboarding/domain/entities/onboarding_question_entity.dart';

void main() {
  const multiChoiceQuestion = OnboardingQuestionEntity(
    id: 'goals',
    questionEn: 'Goals',
    questionAr: 'Goals',
    type: OnboardingQuestionType.multiChoice,
    options: [],
    required: true,
    sortOrder: 1,
  );

  const photoQuestion = OnboardingQuestionEntity(
    id: 'photo',
    questionEn: 'Photo',
    questionAr: 'Photo',
    type: OnboardingQuestionType.photo,
    options: [],
    required: false,
    sortOrder: 2,
  );

  const booleanQuestion = OnboardingQuestionEntity(
    id: 'injuries',
    questionEn: 'Injuries',
    questionAr: 'Injuries',
    type: OnboardingQuestionType.boolean,
    options: [],
    required: true,
    sortOrder: 3,
  );

  test('maps multi choice answers to values field', () {
    final model = OnboardingSubmitMapper.toAnswerModel(
      multiChoiceQuestion,
      ['fat_loss'],
    );

    expect(model?.values, ['fat_loss']);
    expect(model?.value, isNull);
    expect(model?.fileUrls, isNull);
  });

  test('maps photo answers to fileUrls field', () {
    final model = OnboardingSubmitMapper.toAnswerModel(
      photoQuestion,
      ['https://example.com/photo.jpg'],
    );

    expect(model?.fileUrls, ['https://example.com/photo.jpg']);
    expect(model?.value, isNull);
    expect(model?.values, isNull);
  });

  test('maps boolean answers to string value field', () {
    final model = OnboardingSubmitMapper.toAnswerModel(
      booleanQuestion,
      false,
    );

    expect(model?.value, 'false');
  });
}
