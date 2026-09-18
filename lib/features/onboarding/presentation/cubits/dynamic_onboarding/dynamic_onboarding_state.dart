part of 'dynamic_onboarding_cubit.dart';

enum DynamicOnboardingStatus {
  loading,
  ready,
  submitting,
  submitted,
  failure,
  alreadyCompleted,
}

final class DynamicOnboardingState {
  const DynamicOnboardingState({
    this.status = DynamicOnboardingStatus.loading,
    this.questions = const [],
    this.answers = const {},
    this.step = 0,
    this.errorMessage,
    this.uploadingQuestionId,
  });

  final DynamicOnboardingStatus status;
  final List<OnboardingQuestionEntity> questions;
  final Map<String, dynamic> answers;
  final int step;
  final String? errorMessage;
  final String? uploadingQuestionId;

  List<OnboardingQuestionEntity> get visibleQuestions =>
      OnboardingQuestionLogic.visibleQuestions(questions, answers);

  OnboardingQuestionEntity? get currentQuestion {
    final visible = visibleQuestions;
    if (visible.isEmpty || step >= visible.length) return null;
    return visible[step];
  }

  int get totalSteps => visibleQuestions.length;
  bool get isLastStep => step >= totalSteps - 1;
  bool get isSubmitting => status == DynamicOnboardingStatus.submitting;
  bool get isUploading => uploadingQuestionId != null;

  bool get canProceed {
    final question = currentQuestion;
    if (question == null) return false;
    return OnboardingQuestionLogic.isAnswerValid(
      question,
      answers[question.id],
    );
  }

  DynamicOnboardingState copyWith({
    DynamicOnboardingStatus? status,
    List<OnboardingQuestionEntity>? questions,
    Map<String, dynamic>? answers,
    int? step,
    String? errorMessage,
    bool clearError = false,
    String? uploadingQuestionId,
    bool clearUploadingQuestionId = false,
  }) {
    return DynamicOnboardingState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      step: step ?? this.step,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      uploadingQuestionId: clearUploadingQuestionId
          ? null
          : (uploadingQuestionId ?? this.uploadingQuestionId),
    );
  }
}
