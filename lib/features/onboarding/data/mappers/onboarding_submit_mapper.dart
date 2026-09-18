import '../../domain/entities/onboarding_question_entity.dart';
import '../models/onboarding_submit_request.dart';

abstract final class OnboardingSubmitMapper {
  static OnboardingAnswerModel? toAnswerModel(
    OnboardingQuestionEntity question,
    dynamic answer,
  ) {
    return switch (question.type) {
      OnboardingQuestionType.text => _textAnswer(question.id, answer),
      OnboardingQuestionType.number => _textAnswer(question.id, answer),
      OnboardingQuestionType.boolean => _booleanAnswer(question.id, answer),
      OnboardingQuestionType.singleChoice => _textAnswer(question.id, answer),
      OnboardingQuestionType.multiChoice => _multiChoiceAnswer(question.id, answer),
      OnboardingQuestionType.photo => _photoAnswer(question.id, answer),
    };
  }

  static OnboardingAnswerModel? _textAnswer(String questionId, dynamic answer) {
    if (answer == null) return null;
    final text = answer.toString().trim();
    if (text.isEmpty) return null;
    return OnboardingAnswerModel(questionId: questionId, value: text);
  }

  static OnboardingAnswerModel? _booleanAnswer(String questionId, dynamic answer) {
    if (answer is! bool) return null;
    return OnboardingAnswerModel(
      questionId: questionId,
      value: answer ? 'true' : 'false',
    );
  }

  static OnboardingAnswerModel? _multiChoiceAnswer(
    String questionId,
    dynamic answer,
  ) {
    if (answer is! List || answer.isEmpty) return null;
    return OnboardingAnswerModel(
      questionId: questionId,
      values: answer.map((item) => item.toString()).toList(growable: false),
    );
  }

  static OnboardingAnswerModel? _photoAnswer(String questionId, dynamic answer) {
    final urls = switch (answer) {
      final List list when list.isNotEmpty =>
        list.map((item) => item.toString()).toList(growable: false),
      final String url when url.isNotEmpty => <String>[url],
      _ => null,
    };
    if (urls == null || urls.isEmpty) return null;

    return OnboardingAnswerModel(
      questionId: questionId,
      fileUrls: urls,
    );
  }
}
