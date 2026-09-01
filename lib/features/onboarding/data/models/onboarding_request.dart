import 'package:json_annotation/json_annotation.dart';

part 'onboarding_request.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
final class OnboardingRequest {
  const OnboardingRequest({
    required this.fullName,
    required this.age,
    required this.gender,
    this.phoneCountryCode,
    required this.phone,
    required this.occupation,
    required this.hasChronicDisease,
    required this.takesMedications,
    required this.hasInjuries,
    this.injuriesDetails,
    required this.hadSurgery,
    this.surgeryDetails,
    required this.currentlyExercising,
    this.exerciseDaysPerWeek,
    this.exerciseTypes,
    this.exercisingSince,
    required this.followsDiet,
    required this.mealsPerDay,
    required this.waterLitersPerDay,
    required this.usesSupplements,
    required this.sleepHours,
    required this.workNature,
    required this.stressLevel,
    this.bodyFatPct,
    required this.waistCm,
    required this.chestCm,
    required this.armCm,
    required this.thighCm,
    this.photoUrls,
    required this.committedDaysPerWeek,
    required this.preferredTime,
    required this.preferredExerciseType,
    required this.trainedWithCoachBefore,
    this.previousCoachDetails,
    required this.goals,
    this.otherGoal,
  });

  Map<String, dynamic> toJson() => _$OnboardingRequestToJson(this);

  final String fullName;
  final int age;
  final String gender;
  final String? phoneCountryCode;
  final String phone;
  final String occupation;
  final bool hasChronicDisease;
  final bool takesMedications;
  final bool hasInjuries;
  final String? injuriesDetails;
  final bool hadSurgery;
  final String? surgeryDetails;
  final bool currentlyExercising;
  final int? exerciseDaysPerWeek;
  final String? exerciseTypes;
  final String? exercisingSince;
  final bool followsDiet;
  final int mealsPerDay;
  final String waterLitersPerDay;
  final bool usesSupplements;
  final String sleepHours;
  final String workNature;
  final String stressLevel;
  final String? bodyFatPct;
  final String waistCm;
  final String chestCm;
  final String armCm;
  final String thighCm;
  final List<String>? photoUrls;
  final int committedDaysPerWeek;
  final String preferredTime;
  final String preferredExerciseType;
  final bool trainedWithCoachBefore;
  final String? previousCoachDetails;
  final List<String> goals;
  final String? otherGoal;
}
