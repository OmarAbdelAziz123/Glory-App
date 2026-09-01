import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/phone_utils.dart';
import '../../../../onboarding/data/models/onboarding_request.dart';
import '../../../../onboarding/domain/entities/onboarding_prefill_entity.dart';
import '../../../../onboarding/domain/repositories/onboarding_repository.dart';

part 'questionnaire_state.dart';

final class QuestionnaireCubit extends Cubit<QuestionnaireState> {
  QuestionnaireCubit() : super(const QuestionnaireState());

  void applyPrefill(OnboardingPrefillEntity? prefill) {
    if (prefill == null) return;

    final parsed = PhoneUtils.splitPhone(
      phone: prefill.phone ?? state.phone,
      phoneCountryCode: prefill.phoneCountryCode ?? state.phoneCountryCode,
    );

    emit(
      state.copyWith(
        fullName: prefill.fullName ?? state.fullName,
        gender: prefill.gender ?? state.gender,
        phone: parsed.localNumber,
        phoneCountryCode: parsed.dialCode,
      ),
    );
  }

  void nextStep() {
    if (!state.canProceed || state.isSubmitting) return;
    if (state.isLastStep) return;
    emit(state.copyWith(step: state.step + 1, clearError: true));
  }

  void previousStep() {
    if (state.step <= 0 || state.isSubmitting) return;
    emit(state.copyWith(step: state.step - 1, clearError: true));
  }

  Future<bool> submitOnboarding(OnboardingRepository repository) async {
    if (!state.canProceed || state.isSubmitting) return false;

    emit(
      state.copyWith(
        status: QuestionnaireStatus.submitting,
        clearError: true,
      ),
    );

    final result = await repository.submit(_toRequest());

    return result.when(
      success: (_) {
        emit(state.copyWith(status: QuestionnaireStatus.submitted));
        return true;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: QuestionnaireStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
    );
  }

  void markSubmittedLocally() {
    emit(state.copyWith(status: QuestionnaireStatus.submitted));
  }

  OnboardingRequest _toRequest() {
    final age = int.parse(state.age.trim());
    final meals = int.parse(state.mealsPerDay.trim());
    final committedDays = int.parse(state.commitmentDays.trim());
    final exercising = state.exercisesCurrently == true;
    final trainedBefore = state.trainedWithPersonalTrainer == true;
    final parsedPhone = PhoneUtils.splitPhone(
      phone: state.phone,
      phoneCountryCode: state.phoneCountryCode,
    );

    return OnboardingRequest(
      fullName: state.fullName.trim(),
      age: age,
      gender: state.gender!,
      phoneCountryCode: parsedPhone.dialCode,
      phone: parsedPhone.localNumber,
      occupation: state.profession.trim(),
      hasChronicDisease: state.hasChronicDisease!,
      takesMedications: state.hasMedications!,
      hasInjuries: state.hasInjuries!,
      injuriesDetails: state.hasInjuries == true
          ? state.injuriesDetails.trim()
          : null,
      hadSurgery: state.hasSurgery!,
      surgeryDetails:
          state.hasSurgery == true ? state.surgeryDetails.trim() : null,
      currentlyExercising: exercising,
      exerciseDaysPerWeek: exercising
          ? int.parse(state.exerciseDaysPerWeek.trim())
          : null,
      exerciseTypes:
          exercising && state.exerciseTypes.trim().isNotEmpty
              ? state.exerciseTypes.trim()
              : null,
      exercisingSince:
          exercising && state.exerciseDuration.trim().isNotEmpty
              ? state.exerciseDuration.trim()
              : null,
      followsDiet: state.followsDiet!,
      mealsPerDay: meals,
      waterLitersPerDay: state.waterLiters.trim(),
      usesSupplements: state.usesSupplements!,
      sleepHours: state.sleepHours.trim(),
      workNature: state.workNature!,
      stressLevel: state.stressLevel!,
      bodyFatPct:
          state.bodyFat.trim().isNotEmpty ? state.bodyFat.trim() : null,
      waistCm: state.waist.trim(),
      chestCm: state.chest.trim(),
      armCm: state.arm.trim(),
      thighCm: state.thigh.trim(),
      photoUrls: state.photoUrls.isEmpty ? null : state.photoUrls,
      committedDaysPerWeek: committedDays,
      preferredTime: state.preferredTime!,
      preferredExerciseType: state.preferredExercises!,
      trainedWithCoachBefore: trainedBefore,
      previousCoachDetails: trainedBefore
          ? state.personalTrainerDetails.trim()
          : null,
      goals: state.goals.toList(),
      otherGoal:
          state.otherGoal.trim().isNotEmpty ? state.otherGoal.trim() : null,
    );
  }

  void updateFullName(String value) => emit(state.copyWith(fullName: value));
  void updateAge(String value) => emit(state.copyWith(age: value));
  void updateGender(String value) => emit(state.copyWith(gender: value));
  void updatePhoneCountryCode(String value) =>
      emit(state.copyWith(phoneCountryCode: value));
  void updatePhone(String value) => emit(state.copyWith(phone: value));
  void updateProfession(String value) =>
      emit(state.copyWith(profession: value));

  void toggleGoal(String goal) {
    final next = Set<String>.from(state.goals);
    if (next.contains(goal)) {
      next.remove(goal);
    } else {
      next.add(goal);
    }
    emit(state.copyWith(goals: next));
  }

  void updateOtherGoal(String value) => emit(state.copyWith(otherGoal: value));

  void updateHasChronicDisease(bool value) =>
      emit(state.copyWith(hasChronicDisease: value));

  void updateHasMedications(bool value) =>
      emit(state.copyWith(hasMedications: value));

  void updateHasInjuries(bool value) => emit(
        state.copyWith(
          hasInjuries: value,
          injuriesDetails: value ? state.injuriesDetails : '',
        ),
      );

  void updateInjuriesDetails(String value) =>
      emit(state.copyWith(injuriesDetails: value));

  void updateHasSurgery(bool value) => emit(
        state.copyWith(
          hasSurgery: value,
          surgeryDetails: value ? state.surgeryDetails : '',
        ),
      );

  void updateSurgeryDetails(String value) =>
      emit(state.copyWith(surgeryDetails: value));

  void updateExercisesCurrently(bool value) => emit(
        state.copyWith(
          exercisesCurrently: value,
          exerciseDaysPerWeek: value ? state.exerciseDaysPerWeek : '',
          exerciseTypes: value ? state.exerciseTypes : '',
          exerciseDuration: value ? state.exerciseDuration : '',
        ),
      );

  void updateExerciseDaysPerWeek(String value) =>
      emit(state.copyWith(exerciseDaysPerWeek: value));

  void updateExerciseTypes(String value) =>
      emit(state.copyWith(exerciseTypes: value));

  void updateExerciseDuration(String value) =>
      emit(state.copyWith(exerciseDuration: value));

  void updateFollowsDiet(bool value) =>
      emit(state.copyWith(followsDiet: value));

  void updateMealsPerDay(String value) =>
      emit(state.copyWith(mealsPerDay: value));

  void updateWaterLiters(String value) =>
      emit(state.copyWith(waterLiters: value));

  void updateUsesSupplements(bool value) =>
      emit(state.copyWith(usesSupplements: value));

  void updateSleepHours(String value) =>
      emit(state.copyWith(sleepHours: value));

  void updateWorkNature(String value) =>
      emit(state.copyWith(workNature: value));

  void updateStressLevel(String value) =>
      emit(state.copyWith(stressLevel: value));

  void updateBodyFat(String value) => emit(state.copyWith(bodyFat: value));
  void updateWaist(String value) => emit(state.copyWith(waist: value));
  void updateChest(String value) => emit(state.copyWith(chest: value));
  void updateArm(String value) => emit(state.copyWith(arm: value));
  void updateThigh(String value) => emit(state.copyWith(thigh: value));

  void updateCommitmentDays(String value) =>
      emit(state.copyWith(commitmentDays: value));

  void updatePreferredTime(String value) =>
      emit(state.copyWith(preferredTime: value));

  void updatePreferredExercises(String value) =>
      emit(state.copyWith(preferredExercises: value));

  void updateTrainedWithPersonalTrainer(bool value) => emit(
        state.copyWith(
          trainedWithPersonalTrainer: value,
          personalTrainerDetails:
              value ? state.personalTrainerDetails : '',
        ),
      );

  void updatePersonalTrainerDetails(String value) =>
      emit(state.copyWith(personalTrainerDetails: value));
}
