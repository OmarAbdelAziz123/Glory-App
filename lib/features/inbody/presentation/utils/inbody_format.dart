import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/inbody_entities.dart';

abstract final class InbodyFormat {
  static String metricLabel(AppLocalizations l10n, String key) {
    return switch (key) {
      InbodyMetricKey.weight => l10n.weight,
      InbodyMetricKey.muscleMass => l10n.muscleMass,
      InbodyMetricKey.bodyFat => l10n.bodyFatPercentage,
      InbodyMetricKey.bodyWater => l10n.inbodyBodyWater,
      InbodyMetricKey.visceralFat => l10n.visceralFatLevel,
      InbodyMetricKey.bmi => l10n.bmi,
      InbodyMetricKey.bmr => l10n.basalMetabolicRate,
      InbodyMetricKey.metabolicAge => l10n.biologicalAge,
      InbodyMetricKey.inbodyScore => l10n.inbodyScore,
      InbodyMetricKey.height => l10n.inbodyHeight,
      InbodyMetricKey.bodyFatMass => l10n.inbodyBodyFatMass,
      _ => key,
    };
  }

  static String metricUnit(AppLocalizations l10n, String key) {
    return switch (key) {
      InbodyMetricKey.weight ||
      InbodyMetricKey.muscleMass ||
      InbodyMetricKey.bodyFatMass =>
        l10n.inbodyUnitKg,
      InbodyMetricKey.bodyFat || InbodyMetricKey.bodyWater => '%',
      InbodyMetricKey.height => l10n.inbodyUnitCm,
      InbodyMetricKey.bmr => l10n.inbodyUnitKcal,
      _ => '',
    };
  }

  static String number(double? value, {int decimals = 1}) {
    if (value == null) return '—';
    if (value == value.roundToDouble() && decimals <= 1) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(decimals);
  }

  static String metricValue(AppLocalizations l10n, String key, double? value) {
    if (value == null) return '—';
    final unit = metricUnit(l10n, key);
    final text = number(value);
    return unit.isEmpty ? text : '$text $unit';
  }

  static String date(AppLocalizations l10n, DateTime? value) {
    if (value == null) return '—';
    return DateFormat('d MMM yyyy', l10n.localeName).format(value.toLocal());
  }

  static String dateTime(AppLocalizations l10n, DateTime? value) {
    if (value == null) return '—';
    return DateFormat('d MMM yyyy · HH:mm', l10n.localeName)
        .format(value.toLocal());
  }

  static String shortDate(String localeName, DateTime value) {
    return DateFormat('d/M', localeName).format(value.toLocal());
  }

  static String signedDelta(double delta) {
    final prefix = delta > 0 ? '+' : '';
    return '$prefix${delta.toStringAsFixed(1)}';
  }

  static Color deltaColor(String key, double? delta) {
    if (delta == null || delta == 0) return AppColors.neutral500;
    final improved = switch (inbodyMetricTone(key)) {
      InbodyMetricTone.higherIsBetter => delta > 0,
      InbodyMetricTone.lowerIsBetter => delta < 0,
      InbodyMetricTone.neutral => false,
    };
    if (inbodyMetricTone(key) == InbodyMetricTone.neutral) {
      return AppColors.neutral600;
    }
    return improved ? AppColors.green200 : AppColors.red200;
  }
}
