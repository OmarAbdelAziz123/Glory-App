import '../../../../core/utils/phone_utils.dart';
import '../models/onboarding_request.dart';

abstract final class OnboardingFallbackMapper {
  static bool isFallbackQuestionId(String id) => id.startsWith('fallback_');

  static bool usesFallbackQuestions(Iterable<String> questionIds) =>
      questionIds.any(isFallbackQuestionId);

  static OnboardingRequest toLegacyRequest(Map<String, dynamic> answers) {
    final phoneRaw = answers['fallback_phone']?.toString() ?? '';
    final parsedPhone = PhoneUtils.splitPhone(phone: phoneRaw);

    return OnboardingRequest(
      fullName: answers['fallback_full_name']?.toString().trim() ?? '',
      age: int.parse(answers['fallback_age']?.toString().trim() ?? '0'),
      gender: answers['fallback_gender']?.toString() ?? 'MALE',
      phoneCountryCode: parsedPhone.dialCode,
      phone: parsedPhone.localNumber,
      occupation: answers['fallback_occupation']?.toString().trim() ?? '',
      hasChronicDisease: false,
      takesMedications: false,
      hasInjuries: false,
      hadSurgery: false,
      currentlyExercising: false,
      followsDiet: false,
      mealsPerDay: 3,
      waterLitersPerDay: '2',
      usesSupplements: false,
      sleepHours: '7',
      workNature: 'DESK',
      stressLevel: 'MEDIUM',
      waistCm: '80',
      chestCm: '90',
      armCm: '30',
      thighCm: '50',
      committedDaysPerWeek: 3,
      preferredTime: 'MORNING',
      preferredExerciseType: 'BOTH',
      trainedWithCoachBefore: false,
      goals: const ['FITNESS_IMPROVEMENT'],
    );
  }
}
