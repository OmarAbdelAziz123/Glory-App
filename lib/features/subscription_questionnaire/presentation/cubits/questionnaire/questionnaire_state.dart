part of 'questionnaire_cubit.dart';

enum QuestionnaireStatus { editing, submitted }

final class QuestionnaireState {
  const QuestionnaireState({
    this.step = 0,
    this.status = QuestionnaireStatus.editing,
    // Step 1 — Personal
    this.fullName = '',
    this.age = '',
    this.gender,
    this.phone = '',
    this.profession = '',
    // Step 2 — Goals
    this.goals = const {},
    this.otherGoal = '',
    // Step 3 — Medical
    this.hasChronicDisease,
    this.chronicDiseaseDetails = '',
    this.hasMedications,
    this.medicationsDetails = '',
    this.hasInjuries,
    this.injuriesDetails = '',
    this.hasSurgery,
    this.surgeryDetails = '',
    // Step 4 — Activity
    this.exercisesCurrently,
    this.exerciseDaysPerWeek = '',
    this.exerciseTypes = '',
    this.exerciseDuration = '',
    // Step 5 — Nutrition
    this.followsDiet,
    this.mealsPerDay = '',
    this.waterLiters = '',
    this.usesSupplements,
    this.supplementsDetails = '',
    // Step 6 — Lifestyle
    this.sleepHours = '',
    this.workNature,
    this.stressLevel,
    // Step 7 — Measurements
    this.bodyFat = '',
    this.waist = '',
    this.chest = '',
    this.arm = '',
    this.thigh = '',
    // Step 8 — Training
    this.commitmentDays = '',
    this.preferredTime,
    this.preferredExercises,
    this.trainedWithPersonalTrainer,
    this.personalTrainerDetails = '',
  });

  static const totalSteps = 8;

  final int step;
  final QuestionnaireStatus status;

  final String fullName;
  final String age;
  final String? gender;
  final String phone;
  final String profession;

  final Set<String> goals;
  final String otherGoal;

  final bool? hasChronicDisease;
  final String chronicDiseaseDetails;
  final bool? hasMedications;
  final String medicationsDetails;
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
  final String supplementsDetails;

  final String sleepHours;
  final String? workNature;
  final String? stressLevel;

  final String bodyFat;
  final String waist;
  final String chest;
  final String arm;
  final String thigh;

  final String commitmentDays;
  final String? preferredTime;
  final String? preferredExercises;
  final bool? trainedWithPersonalTrainer;
  final String personalTrainerDetails;

  bool get isLastStep => step >= totalSteps - 1;

  bool get canProceed => switch (step) {
        0 =>
          fullName.trim().isNotEmpty &&
              age.trim().isNotEmpty &&
              gender != null &&
              phone.trim().isNotEmpty &&
              profession.trim().isNotEmpty,
        1 => goals.isNotEmpty,
        2 =>
          hasChronicDisease != null &&
              hasMedications != null &&
              hasInjuries != null &&
              hasSurgery != null &&
              (hasChronicDisease != true ||
                  chronicDiseaseDetails.trim().isNotEmpty) &&
              (hasMedications != true ||
                  medicationsDetails.trim().isNotEmpty) &&
              (hasInjuries != true || injuriesDetails.trim().isNotEmpty) &&
              (hasSurgery != true || surgeryDetails.trim().isNotEmpty),
        3 =>
          exercisesCurrently != null &&
              (exercisesCurrently != true ||
                  exerciseDaysPerWeek.trim().isNotEmpty),
        4 =>
          followsDiet != null &&
              mealsPerDay.trim().isNotEmpty &&
              waterLiters.trim().isNotEmpty &&
              usesSupplements != null &&
              (usesSupplements != true ||
                  supplementsDetails.trim().isNotEmpty),
        5 =>
          sleepHours.trim().isNotEmpty &&
              workNature != null &&
              stressLevel != null,
        6 =>
          bodyFat.trim().isNotEmpty &&
              waist.trim().isNotEmpty &&
              chest.trim().isNotEmpty &&
              arm.trim().isNotEmpty &&
              thigh.trim().isNotEmpty,
        7 =>
          commitmentDays.trim().isNotEmpty &&
              preferredTime != null &&
              preferredExercises != null &&
              trainedWithPersonalTrainer != null &&
              (trainedWithPersonalTrainer != true ||
                  personalTrainerDetails.trim().isNotEmpty),
        _ => false,
      };

  QuestionnaireState copyWith({
    int? step,
    QuestionnaireStatus? status,
    String? fullName,
    String? age,
    String? gender,
    bool clearGender = false,
    String? phone,
    String? profession,
    Set<String>? goals,
    String? otherGoal,
    bool? hasChronicDisease,
    bool clearHasChronicDisease = false,
    String? chronicDiseaseDetails,
    bool? hasMedications,
    bool clearHasMedications = false,
    String? medicationsDetails,
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
    String? supplementsDetails,
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
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: clearGender ? null : (gender ?? this.gender),
      phone: phone ?? this.phone,
      profession: profession ?? this.profession,
      goals: goals ?? this.goals,
      otherGoal: otherGoal ?? this.otherGoal,
      hasChronicDisease: clearHasChronicDisease
          ? null
          : (hasChronicDisease ?? this.hasChronicDisease),
      chronicDiseaseDetails:
          chronicDiseaseDetails ?? this.chronicDiseaseDetails,
      hasMedications: clearHasMedications
          ? null
          : (hasMedications ?? this.hasMedications),
      medicationsDetails: medicationsDetails ?? this.medicationsDetails,
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
      supplementsDetails: supplementsDetails ?? this.supplementsDetails,
      sleepHours: sleepHours ?? this.sleepHours,
      workNature: clearWorkNature ? null : (workNature ?? this.workNature),
      stressLevel:
          clearStressLevel ? null : (stressLevel ?? this.stressLevel),
      bodyFat: bodyFat ?? this.bodyFat,
      waist: waist ?? this.waist,
      chest: chest ?? this.chest,
      arm: arm ?? this.arm,
      thigh: thigh ?? this.thigh,
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
