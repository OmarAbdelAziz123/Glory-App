import 'package:glory_gym/l10n/app_localizations.dart';

abstract final class OnboardingUtils {
  static const genderKeys = ['MALE', 'FEMALE'];

  static const goalKeys = [
    'FAT_LOSS',
    'STRENGTH_GAIN',
    'FITNESS_IMPROVEMENT',
    'REHABILITATION',
    'BODY_TONING',
    'MUSCLE_GAIN',
  ];

  static const workNatureKeys = ['DESK', 'MODERATE', 'PHYSICAL'];

  static const stressKeys = ['LOW', 'MEDIUM', 'HIGH'];

  static const timeKeys = ['MORNING', 'NOON', 'EVENING', 'NIGHT'];

  static const preferredExerciseKeys = ['MACHINES', 'FREE_WEIGHTS', 'BOTH'];

  static Map<String, String> genderLabels(AppLocalizations l10n) => {
        'MALE': l10n.genderMale,
        'FEMALE': l10n.genderFemale,
      };

  static Map<String, String> goalOptions(AppLocalizations l10n) => {
        'FAT_LOSS': l10n.goalFatLoss,
        'STRENGTH_GAIN': l10n.goalIncreaseStrength,
        'FITNESS_IMPROVEMENT': l10n.goalImproveFitness,
        'REHABILITATION': l10n.goalInjuryRehab,
        'BODY_TONING': l10n.goalBodyToning,
        'MUSCLE_GAIN': l10n.goalMuscleGain,
      };

  static Map<String, String> workNatureOptions(AppLocalizations l10n) => {
        'DESK': l10n.deskJob,
        'MODERATE': l10n.activityModerate,
        'PHYSICAL': l10n.physicalEffort,
      };

  static Map<String, String> stressOptions(AppLocalizations l10n) => {
        'LOW': l10n.low,
        'MEDIUM': l10n.average,
        'HIGH': l10n.high,
      };

  static Map<String, String> timeOptions(AppLocalizations l10n) => {
        'MORNING': l10n.morning,
        'NOON': l10n.afternoon,
        'EVENING': l10n.evening,
        'NIGHT': l10n.night,
      };

  static Map<String, String> preferredExerciseOptions(AppLocalizations l10n) =>
      {
        'MACHINES': l10n.equipmentMachines,
        'FREE_WEIGHTS': l10n.freeWeights,
        'BOTH': l10n.genderBoth,
      };

  static String? genderLabel(AppLocalizations l10n, String? value) =>
      genderLabels(l10n)[value];

  static String? genderValue(AppLocalizations l10n, String label) {
    for (final entry in genderLabels(l10n).entries) {
      if (entry.value == label) return entry.key;
    }
    return null;
  }

  static String goalLabel(AppLocalizations l10n, String value) =>
      goalOptions(l10n)[value] ?? value;

  static String workNatureLabel(AppLocalizations l10n, String value) =>
      workNatureOptions(l10n)[value] ?? value;

  static String stressLabel(AppLocalizations l10n, String value) =>
      stressOptions(l10n)[value] ?? value;

  static String timeLabel(AppLocalizations l10n, String value) =>
      timeOptions(l10n)[value] ?? value;

  static String preferredExerciseLabel(AppLocalizations l10n, String value) =>
      preferredExerciseOptions(l10n)[value] ?? value;
}
