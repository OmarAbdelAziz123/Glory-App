import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';

import '../widgets/measurement_card.dart';

final class BodyCompositionScreen extends StatelessWidget {
  const BodyCompositionScreen({super.key});

  static const _cards = [
    MeasurementCardData(
      issuedBy: 'اصدار بواسطة: احمد حسام',
      date: 'Apr 2026.05',
      rows: [
        MeasurementMetricRow(
          leading: MeasurementMetric(label: 'الوزن', value: '10 كيلو'),
          trailing: MeasurementMetric(label: 'التكتله العضليه', value: '000'),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(
            label: 'نسبة الدهون في الجسم',
            value: '000',
          ),
          trailing: MeasurementMetric(
            label: 'كستواه الدهون الحشويه',
            value: '000',
          ),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(
            label: 'مؤشر كتلة الجسم',
            value: '10 كيلو',
          ),
          trailing: MeasurementMetric(
            label: 'معدل الايض الاساسي',
            value: '000',
          ),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(label: 'العمر البيضي', value: '000'),
        ),
      ],
    ),
    MeasurementCardData(
      issuedBy: 'اصدار بواسطة: احمد حسام',
      date: 'Apr 2026.05',
      rows: [
        MeasurementMetricRow(
          leading: MeasurementMetric(label: 'الوزن', value: '10 كيلو'),
          trailing: MeasurementMetric(label: 'التكتله العضليه', value: '000'),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(
            label: 'نسبة الدهون في الجسم',
            value: '000',
          ),
          trailing: MeasurementMetric(
            label: 'كستواه الدهون الحشويه',
            value: '000',
          ),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(
            label: 'مؤشر كتلة الجسم',
            value: '10 كيلو',
          ),
          trailing: MeasurementMetric(
            label: 'معدل الايض الاساسي',
            value: '000',
          ),
        ),
        MeasurementMetricRow(
          leading: MeasurementMetric(label: 'العمر البيضي', value: '000'),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'فحص تكوين الجسم',
        showBack: true,
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: _cards.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) => MeasurementCard(data: _cards[index]),
      ),
    );
  }
}
