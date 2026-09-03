import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';

// ── Data models ───────────────────────────────────────────────────────────────

final class MeasurementMetric {
  const MeasurementMetric({required this.label, required this.value});

  final String label;
  final String value;
}

final class MeasurementMetricRow {
  const MeasurementMetricRow({required this.leading, this.trailing});

  final MeasurementMetric leading;
  final MeasurementMetric? trailing;
}

final class MeasurementCardData {
  const MeasurementCardData({
    required this.issuedBy,
    required this.date,
    required this.rows,
  });

  final String issuedBy;
  final String date;
  final List<MeasurementMetricRow> rows;
}

// ── Widget ────────────────────────────────────────────────────────────────────

final class MeasurementCard extends StatelessWidget {
  const MeasurementCard({super.key, required this.data});

  final MeasurementCardData data;

  static const _radius = 8.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(issuedBy: data.issuedBy, date: data.date),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (var i = 0; i < data.rows.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    _MetricRowWidget(row: data.rows[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.issuedBy, required this.date});

  final String issuedBy;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: AppColors.primary10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: context.captionRegular.copyWith(color: AppColors.primary),
          ),
          Text(
            issuedBy,
            style: context.subtitleMedium.copyWith(color: AppColors.neutral600),
          ),
        ],
      ),
    );
  }
}

final class _MetricRowWidget extends StatelessWidget {
  const _MetricRowWidget({required this.row});

  final MeasurementMetricRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _MetricCell(metric: row.leading)),
        const SizedBox(width: 16),
        Expanded(
          child: row.trailing == null
              ? const SizedBox.shrink()
              : _MetricCell(metric: row.trailing!),
        ),
      ],
    );
  }
}

final class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.metric});

  final MeasurementMetric metric;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metric.label,
          style: context.captionRegular.copyWith(color: AppColors.neutral400),
        ),
        const SizedBox(height: 4),
        Text(metric.value, style: context.contentSemibold),
      ],
    );
  }
}
