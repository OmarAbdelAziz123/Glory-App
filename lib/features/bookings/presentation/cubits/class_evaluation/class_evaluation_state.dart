part of 'class_evaluation_cubit.dart';

enum ClassEvaluationStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  failure,
}

final class ClassEvaluationState extends Equatable {
  const ClassEvaluationState({
    this.status = ClassEvaluationStatus.initial,
    this.questions = const [],
    this.answers = const {},
    this.errorMessage,
    this.result,
  });

  final ClassEvaluationStatus status;
  final List<AssessmentQuestionEntity> questions;
  final Map<String, int> answers;
  final String? errorMessage;
  final BookingCheckInResultEntity? result;

  bool get canSubmit =>
      questions.isNotEmpty && answers.length == questions.length;

  ClassEvaluationState copyWith({
    ClassEvaluationStatus? status,
    List<AssessmentQuestionEntity>? questions,
    Map<String, int>? answers,
    String? errorMessage,
    BookingCheckInResultEntity? result,
  }) {
    return ClassEvaluationState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      errorMessage: errorMessage,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, questions, answers, errorMessage, result];
}
