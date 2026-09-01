part of 'questionnaire_cubit.dart';

enum QuestionnaireStatus { editing, submitting, submitted, failure }

final class QuestionnaireState {
  const QuestionnaireState({
    this.step = 0,
    this.status = QuestionnaireStatus.editing,
    this.errorMessage,
    // Step 1 — Personal
    this.fullName = '',
    this.age = '',
    this.gender,
    this.phoneCountryCode = '+966',
    this.phone = '',
    this.profession = '',
    // Step 8 — Goals
    this.goals = const {},
    this.otherGoal = '',
    // Step 2 — Medical
    this.hasChronicDisease,
    this.hasMedications,
    this.hasInjuries,
    this.injuriesDetails = '',
    this.hasSurgery,
    this.surgeryDetails = '',
    // Step 3 — Activity
    this.exercisesCurrently,
    this.exerciseDaysPerWeek = '',
    this.exerciseTypes = '',
    this.exerciseDuration = '',
    // Step 4 — Nutrition
    this.followsDiet,
    this.mealsPerDay = '',
    this.waterLiters = '',
    this.usesSupplements,
    // Step 5 — Lifestyle
    this.sleepHours = '',
    this.workNature,
    this.stressLevel,
    // Step 6 — Measurements
    this.bodyFat = '',
    this.waist = '',
    this.chest = '',
    this.arm = '',
    this.thigh = '',
    this.photoUrls = const [],
    // Step 7 — Training
    this.commitmentDays = '',
    this.preferredTime,
    this.preferredExercises,
    this.trainedWithPersonalTrainer,
    this.personalTrainerDetails = '',
  });

  static const totalSteps = 8;

  final int step;
  final QuestionnaireStatus status;
  final String? errorMessage;

  final String fullName;
  final String age;
  final String? gender;
  final String phoneCountryCode;
  final String phone;
  final String profession;

  final Set<String> goals;
  final String otherGoal;

  final bool? hasChronicDisease;
  final bool? hasMedications;
  final bool? hasInjuries;
  final String injuriesDetails;
  final bool? hasSurgery;
  final String surgeryDetails;

  final bool? exercisesCurrently;
  final String exerciseDaysPerWeek;
  final String exerciseTypes;
  final String exerciseDuration;

  final bool? followsDiet;
  final String mealsPerDay;
  final String waterLiters;
  final bool? usesSupplements;

  final String sleepHours;
  final String? workNature;
  final String? stressLevel;

  final String bodyFat;
  final String waist;
  final String chest;
  final String arm;
  final String thigh;
  final List<String> photoUrls;

  final String commitmentDays;
  final String? preferredTime;
  final String? preferredExercises;
  final bool? trainedWithPersonalTrainer;
  final String personalTrainerDetails;

  bool get isLastStep => step >= totalSteps - 1;
  bool get isSubmitting => status == QuestionnaireStatus.submitting;

  bool get canProceed => switch (step) {
        0 =>
          fullName.trim().isNotEmpty &&
              _isValidAge(age) &&
              gender != null &&
              phone.trim().length >= 6 &&
              profession.trim().isNotEmpty,
        1 =>
          hasChronicDisease != null &&
              hasMedications != null &&
              hasInjuries != null &&
              hasSurgery != null &&
              (hasInjuries != true || injuriesDetails.trim().isNotEmpty) &&
              (hasSurgery != true || surgeryDetails.trim().isNotEmpty),
        2 =>
          exercisesCurrently != null &&
              (exercisesCurrently != true ||
                  _isValidDays(exerciseDaysPerWeek)),
        3 =>
          followsDiet != null &&
              _isValidMeals(mealsPerDay) &&
              waterLiters.trim().isNotEmpty &&
              usesSupplements != null,
        4 =>
          sleepHours.trim().isNotEmpty &&
              workNature != null &&
              stressLevel != null,
        5 =>
          waist.trim().isNotEmpty &&
              chest.trim().isNotEmpty &&
              arm.trim().isNotEmpty &&
              thigh.trim().isNotEmpty,
        6 =>
          _isValidDays(commitmentDays) &&
              preferredTime != null &&
              preferredExercises != null &&
              trainedWithPersonalTrainer != null &&
              (trainedWithPersonalTrainer != true ||
                  personalTrainerDetails.trim().isNotEmpty),
        7 => goals.isNotEmpty,
        _ => false,
      };

  static bool _isValidAge(String value) {
    final parsed = int.tryParse(value.trim());
    return parsed != null && parsed >= 10 && parsed <= 100;
  }

  static bool _isValidDays(String value) {
    final parsed = int.tryParse(value.trim());
    return parsed != null && parsed >= 1 && parsed <= 7;
  }

  static bool _isValidMeals(String value) {
    final parsed = int.tryParse(value.trim());
    return parsed != null && parsed >= 1 && parsed <= 12;
  }

  QuestionnaireState copyWith({
    int? step,
    QuestionnaireStatus? status,
    String? errorMessage,
    bool clearError = false,
    String? fullName,
    String? age,
    String? gender,
    bool clearGender = false,
    String? phoneCountryCode,
    String? phone,
    String? profession,
    Set<String>? goals,
    String? otherGoal,
    bool? hasChronicDisease,
    bool clearHasChronicDisease = false,
    bool? hasMedications,
    bool clearHasMedications = false,
    bool? hasInjuries,
    bool clearHasInjuries = false,
    String? injuriesDetails,
    bool? hasSurgery,
    bool clearHasSurgery = false,
    String? surgeryDetails,
    bool? exercisesCurrently,
    bool clearExercisesCurrently = false,
    String? exerciseDaysPerWeek,
    String? exerciseTypes,
    String? exerciseDuration,
    bool? followsDiet,
    bool clearFollowsDiet = false,
    String? mealsPerDay,
    String? waterLiters,
    bool? usesSupplements,
    bool clearUsesSupplements = false,
    String? sleepHours,
    String? workNature,
    bool clearWorkNature = false,
    String? stressLevel,
    bool clearStressLevel = false,
    String? bodyFat,
    String? waist,
    String? chest,
    String? arm,
    String? thigh,
    List<String>? photoUrls,
    String? commitmentDays,
    String? preferredTime,
    bool clearPreferredTime = false,
    String? preferredExercises,
    bool clearPreferredExercises = false,
    bool? trainedWithPersonalTrainer,
    bool clearTrainedWithPersonalTrainer = false,
    String? personalTrainerDetails,
  }) {
    return QuestionnaireState(
      step: step ?? this.step,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: clearGender ? null : (gender ?? this.gender),
      phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
      phone: phone ?? this.phone,
      profession: profession ?? this.profession,
      goals: goals ?? this.goals,
      otherGoal: otherGoal ?? this.otherGoal,
      hasChronicDisease: clearHasChronicDisease
          ? null
          : (hasChronicDisease ?? this.hasChronicDisease),
      hasMedications: clearHasMedications
          ? null
          : (hasMedications ?? this.hasMedications),
      hasInjuries:
          clearHasInjuries ? null : (hasInjuries ?? this.hasInjuries),
      injuriesDetails: injuriesDetails ?? this.injuriesDetails,
      hasSurgery: clearHasSurgery ? null : (hasSurgery ?? this.hasSurgery),
      surgeryDetails: surgeryDetails ?? this.surgeryDetails,
      exercisesCurrently: clearExercisesCurrently
          ? null
          : (exercisesCurrently ?? this.exercisesCurrently),
      exerciseDaysPerWeek: exerciseDaysPerWeek ?? this.exerciseDaysPerWeek,
      exerciseTypes: exerciseTypes ?? this.exerciseTypes,
      exerciseDuration: exerciseDuration ?? this.exerciseDuration,
      followsDiet:
          clearFollowsDiet ? null : (followsDiet ?? this.followsDiet),
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      waterLiters: waterLiters ?? this.waterLiters,
      usesSupplements: clearUsesSupplements
          ? null
          : (usesSupplements ?? this.usesSupplements),
      sleepHours: sleepHours ?? this.sleepHours,
      workNature: clearWorkNature ? null : (workNature ?? this.workNature),
      stressLevel:
          clearStressLevel ? null : (stressLevel ?? this.stressLevel),
      bodyFat: bodyFat ?? this.bodyFat,
      waist: waist ?? this.waist,
      chest: chest ?? this.chest,
      arm: arm ?? this.arm,
      thigh: thigh ?? this.thigh,
      photoUrls: photoUrls ?? this.photoUrls,
      commitmentDays: commitmentDays ?? this.commitmentDays,
      preferredTime:
          clearPreferredTime ? null : (preferredTime ?? this.preferredTime),
      preferredExercises: clearPreferredExercises
          ? null
          : (preferredExercises ?? this.preferredExercises),
      trainedWithPersonalTrainer: clearTrainedWithPersonalTrainer
          ? null
          : (trainedWithPersonalTrainer ?? this.trainedWithPersonalTrainer),
      personalTrainerDetails:
          personalTrainerDetails ?? this.personalTrainerDetails,
    );
  }
}
