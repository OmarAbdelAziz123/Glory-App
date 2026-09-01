import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/l10n/app_localizations.dart';

import '../widgets/measurement_card.dart';

final class BodyCompositionScreen extends StatelessWidget {
  const BodyCompositionScreen({super.key});

  List<MeasurementCardData> _cards(AppLocalizations l10n) => [
        MeasurementCardData(
          issuedBy: l10n.issuedByAhmedHossam,
          date: 'Apr 2026.05',
          rows: [
            MeasurementMetricRow(
              leading: MeasurementMetric(label: l10n.weight, value: l10n.tenKilosLabel),
              trailing: MeasurementMetric(label: l10n.muscleMass, value: '000'),
            ),
            MeasurementMetricRow(
              leading: MeasurementMetric(
                label: l10n.bodyFatPercentage,
                value: '000',
              ),
              trailing: MeasurementMetric(
                label: l10n.visceralFatLevel,
                value: '000',
              ),
            ),
            MeasurementMetricRow(
              leading: MeasurementMetric(
                label: l10n.bmi,
                value: l10n.tenKilosLabel,
              ),
              trailing: MeasurementMetric(
                label: l10n.basalMetabolicRate,
                value: '000',
              ),
            ),
            MeasurementMetricRow(
              leading: MeasurementMetric(label: l10n.biologicalAge, value: '000'),
            ),
          ],
        ),
        MeasurementCardData(
          issuedBy: l10n.issuedByAhmedHossam,
          date: 'Apr 2026.05',
          rows: [
            MeasurementMetricRow(
              leading: MeasurementMetric(label: l10n.weight, value: l10n.tenKilosLabel),
              trailing: MeasurementMetric(label: l10n.muscleMass, value: '000'),
            ),
            MeasurementMetricRow(
              leading: MeasurementMetric(
                label: l10n.bodyFatPercentage,
                value: '000',
              ),
              trailing: MeasurementMetric(
                label: l10n.visceralFatLevel,
                value: '000',
              ),
            ),
            MeasurementMetricRow(
              leading: MeasurementMetric(
                label: l10n.bmi,
                value: l10n.tenKilosLabel,
              ),
              trailing: MeasurementMetric(
                label: l10n.basalMetabolicRate,
                value: '000',
              ),
            ),
            MeasurementMetricRow(
              leading: MeasurementMetric(label: l10n.biologicalAge, value: '000'),
            ),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final cards = _cards(context.l10n);

    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: context.l10n.bodyCompositionScan,
        showBack: true,
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) => MeasurementCard(data: cards[index]),
      ),
    );
  }
}
