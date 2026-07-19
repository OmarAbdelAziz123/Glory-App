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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardHeader(issuedBy: data.issuedBy, date: data.date),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          ...data.rows.expand((row) => [
                const SizedBox(height: 12),
                _MetricRowWidget(row: row),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.neutral200),
              ]),
        ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          issuedBy,
          style: context.footnoteRegular.copyWith(color: AppColors.neutral500),
        ),
        Text(
          date,
          style: context.footnoteRegular.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}

final class _MetricRowWidget extends StatelessWidget {
  const _MetricRowWidget({required this.row});

  final MeasurementMetricRow row;

  @override
  Widget build(BuildContext context) {
    if (row.trailing == null) {
      return _MetricCell(metric: row.leading);
    }
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: _MetricCell(metric: row.leading)),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(child: _MetricCell(metric: row.trailing!)),
        ],
      ),
    );
  }
}

final class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.metric});

  final MeasurementMetric metric;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          metric.label,
          style: context.footnoteRegular.copyWith(color: AppColors.neutral400),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          metric.value,
          style: context.subtitleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
