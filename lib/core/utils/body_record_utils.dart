import 'package:glory_gym/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../features/body_composition/domain/entities/body_measurement_entity.dart';
import '../../features/body_composition/presentation/widgets/measurement_card.dart';

abstract final class BodyRecordUtils {
  static const _emptyMetricPlaceholder = '000';

  static String formatRecordedDate(AppLocalizations l10n, DateTime date) {
    return DateFormat('MMM y dd', l10n.localeName).format(date.toLocal());
  }

  static String issuedByLabel(AppLocalizations l10n, String fullName) {
    return '${l10n.issuedBy}: $fullName';
  }

  static String metricValue(
    AppLocalizations l10n,
    String? value, {
    bool isWeight = false,
  }) {
    if (value == null || value.isEmpty) return _emptyMetricPlaceholder;
    if (isWeight) return l10n.weightKilosLabel(value);
    return value;
  }

  static MeasurementCardData toMeasurementCardData(
    BodyRecordEntity record,
    AppLocalizations l10n,
  ) {
    return MeasurementCardData(
      issuedBy: issuedByLabel(l10n, record.createdBy.fullName),
      date: formatRecordedDate(l10n, record.recordedAt),
      rows: [
        MeasurementMetricRow(
          leading: MeasurementMetric(
            label: l10n.weight,
            value: metricValue(l10n, record.weight, isWeight: true),
          ),
          trailing: MeasurementMetric(
            label: l10n.muscleMass,
            value: metricValue(l10n, record.muscleMass),
          ),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(
            label: l10n.bodyFatPercentage,
            value: metricValue(l10n, record.bodyFat),
          ),
          trailing: MeasurementMetric(
            label: l10n.visceralFatLevel,
            value: metricValue(l10n, record.visceralFat),
          ),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(
            label: l10n.bmi,
            value: metricValue(l10n, record.bmi),
          ),
          trailing: MeasurementMetric(
            label: l10n.basalMetabolicRate,
            value: metricValue(l10n, record.bmr),
          ),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(
            label: l10n.biologicalAge,
            value: metricValue(l10n, record.metabolicAge),
          ),
        ),
      ],
    );
  }
}
