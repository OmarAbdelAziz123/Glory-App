import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/result/result.dart';
import '../../../data/mappers/onboarding_fallback_mapper.dart';
import '../../../data/mappers/onboarding_submit_mapper.dart';
import '../../../data/models/onboarding_submit_request.dart';
import '../../../domain/entities/onboarding_prefill_entity.dart';
import '../../../domain/entities/onboarding_question_entity.dart';
import '../../../domain/repositories/onboarding_repository.dart';
import '../../utils/onboarding_question_logic.dart';

part 'dynamic_onboarding_state.dart';

final class DynamicOnboardingCubit extends Cubit<DynamicOnboardingState> {
  DynamicOnboardingCubit(this._repository) : super(const DynamicOnboardingState());

  final OnboardingRepository _repository;

  Future<void> load({OnboardingPrefillEntity? prefill}) async {
    emit(state.copyWith(status: DynamicOnboardingStatus.loading, clearError: true));

    final statusResult = await _repository.getStatus();
    if (statusResult case Success(:final data) when data.completed) {
      emit(state.copyWith(status: DynamicOnboardingStatus.alreadyCompleted));
      return;
    }

    final result = await _repository.getQuestions();
    result.when(
      success: (questions) {
        final sorted = [...questions]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        emit(
          state.copyWith(
            status: DynamicOnboardingStatus.ready,
            questions: sorted,
            answers: _initialAnswers(sorted, prefill),
            step: 0,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: DynamicOnboardingStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
    );
  }

  Map<String, dynamic> _initialAnswers(
    List<OnboardingQuestionEntity> questions,
    OnboardingPrefillEntity? prefill,
  ) {
    if (prefill == null) return const {};

    final answers = <String, dynamic>{};
    for (final question in questions) {
      final value = _prefillValueForQuestion(question, prefill);
      if (value != null) {
        answers[question.id] = value;
      }
    }
    return answers;
  }

  dynamic _prefillValueForQuestion(
    OnboardingQuestionEntity question,
    OnboardingPrefillEntity prefill,
  ) {
    final combined = '${question.questionEn} ${question.questionAr}'.toLowerCase();

    if (question.type == OnboardingQuestionType.text &&
        prefill.fullName != null &&
        (combined.contains('name') || combined.contains('اسم'))) {
      return prefill.fullName;
    }

    if (question.type == OnboardingQuestionType.text &&
        prefill.phone != null &&
        (combined.contains('phone') || combined.contains('هاتف'))) {
      return prefill.phone;
    }

    if (question.type == OnboardingQuestionType.singleChoice &&
        prefill.gender != null) {
      final hasGenderOption = question.options.any(
        (option) => option.value.toUpperCase() == prefill.gender!.toUpperCase(),
      );
      if (hasGenderOption) return prefill.gender;
    }

    return null;
  }

  void setAnswer(String questionId, dynamic value) {
    final nextAnswers = Map<String, dynamic>.from(state.answers)
      ..[questionId] = value;

    final cleared = _clearHiddenDependents(nextAnswers);
    final nextVisibleCount =
        OnboardingQuestionLogic.visibleQuestions(state.questions, cleared).length;
    final nextStep = state.step.clamp(0, nextVisibleCount == 0 ? 0 : nextVisibleCount - 1);

    emit(
      state.copyWith(
        answers: cleared,
        step: nextStep,
        clearError: true,
      ),
    );
  }

  Map<String, dynamic> _clearHiddenDependents(Map<String, dynamic> answers) {
    final visibleIds = OnboardingQuestionLogic.visibleQuestions(
      state.questions,
      answers,
    ).map((question) => question.id).toSet();

    return Map.fromEntries(
      answers.entries.where((entry) => visibleIds.contains(entry.key)),
    );
  }

  void nextStep() {
    if (!state.canProceed || state.isSubmitting || state.isUploading) return;
    if (state.isLastStep) return;

    emit(state.copyWith(step: state.step + 1, clearError: true));
  }

  void previousStep() {
    if (state.step <= 0 || state.isSubmitting || state.isUploading) return;
    emit(state.copyWith(step: state.step - 1, clearError: true));
  }

  Future<bool> uploadPhoto(String questionId, String filePath) async {
    emit(
      state.copyWith(
        uploadingQuestionId: questionId,
        clearError: true,
      ),
    );

    final result = await _repository.uploadPhoto(filePath);
    return result.when(
      success: (url) {
        emit(
          state.copyWith(
            answers: {...state.answers, questionId: [url]},
            clearUploadingQuestionId: true,
          ),
        );
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: DynamicOnboardingStatus.failure,
            errorMessage: failure.message,
            clearUploadingQuestionId: true,
          ),
        );
        return false;
      },
    );
  }

  void removePhoto(String questionId, String url) {
    final current = state.answers[questionId];
    if (current is! List) return;

    final urls = List<String>.from(current.cast<String>())..remove(url);
    emit(
      state.copyWith(
        answers: {...state.answers, questionId: urls},
        clearError: true,
      ),
    );
  }

  Future<bool> submit() async {
    if (state.isSubmitting || state.isUploading) return false;

    final visible = state.visibleQuestions;
    final missingRequired = visible.where(
      (question) => !OnboardingQuestionLogic.isAnswerValid(
        question,
        state.answers[question.id],
      ),
    );
    if (missingRequired.isNotEmpty) return false;

    emit(
      state.copyWith(
        status: DynamicOnboardingStatus.submitting,
        clearError: true,
      ),
    );

    final payload = <OnboardingAnswerModel>[];
    for (final question in visible) {
      if (!state.answers.containsKey(question.id)) continue;

      final answerModel = OnboardingSubmitMapper.toAnswerModel(
        question,
        state.answers[question.id],
      );
      if (answerModel == null) continue;

      payload.add(answerModel);
    }

    final usesFallback = OnboardingFallbackMapper.usesFallbackQuestions(
      visible.map((question) => question.id),
    );

    final result = usesFallback
        ? await _repository.submitLegacy(
            OnboardingFallbackMapper.toLegacyRequest(state.answers),
          )
        : await _repository.submit(
            OnboardingSubmitRequest(answers: payload),
          );

    return result.when(
      success: (_) {
        emit(state.copyWith(status: DynamicOnboardingStatus.submitted));
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: DynamicOnboardingStatus.ready,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }
}
