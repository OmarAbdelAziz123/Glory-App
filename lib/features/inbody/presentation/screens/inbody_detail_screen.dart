import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/inbody_entities.dart';
import '../cubits/inbody_detail/inbody_detail_cubit.dart';
import '../utils/inbody_format.dart';

final class InbodyDetailScreen extends StatelessWidget {
  const InbodyDetailScreen({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InbodyDetailCubit>(param1: testId)..load(),
      child: const _InbodyDetailView(),
    );
  }
}

final class _InbodyDetailView extends StatelessWidget {
  const _InbodyDetailView();

  Future<void> _openPdf(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: context.l10n.inbodyDetailTitle,
        centerTitle: true,
      ),
      body: BlocBuilder<InbodyDetailCubit, InbodyDetailState>(
        builder: (context, state) {
          if (state.isLoading || state.test == null) {
            if (state.status == InbodyDetailStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.errorMessage ?? context.l10n.errorTryAgain,
                    textAlign: TextAlign.center,
                    style: context.captionRegular.copyWith(color: AppColors.red),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final test = state.test!;
          final l10n = context.l10n;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              _HeaderCard(test: test),
              const SizedBox(height: 16),
              _MetricsGrid(test: test),
              if (test.extras.hasAny) ...[
                const SizedBox(height: 16),
                _ExtrasCard(extras: test.extras),
              ],
              if (test.hasPdf) ...[
                const SizedBox(height: 16),
                _ActionTile(
                  icon: Iconsax.document_text,
                  label: l10n.inbodyOpenPdf,
                  onTap: () => _openPdf(test.pdfUrl!),
                ),
              ],
              if (test.hasRaw) ...[
                const SizedBox(height: 16),
                _RawDeviceCard(raw: test.raw!),
              ],
            ],
          );
        },
      ),
    );
  }
}

final class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.test});

  final InbodyTestEntity test;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  test.isDevice ? Iconsax.cpu : Iconsax.edit_2,
                  color: AppColors.primary800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      InbodyFormat.dateTime(l10n, test.recordedAt),
                      style: context.highlightBold.copyWith(
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      test.isDevice
                          ? (test.device ?? l10n.inbodyDeviceBadge)
                          : (test.enteredBy == null
                              ? l10n.inbodyManualBadge
                              : l10n.inbodyEnteredBy(test.enteredBy!.fullName)),
                      style: context.captionRegular.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: test.isDevice
                      ? AppColors.primary100
                      : AppColors.neutral100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  test.isDevice
                      ? l10n.inbodyDeviceBadge
                      : l10n.inbodyManualBadge,
                  style: context.footnoteRegular.copyWith(
                    color: test.isDevice
                        ? AppColors.primary800
                        : AppColors.neutral700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.test});

  final InbodyTestEntity test;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          for (final key in InbodyMetricKey.primaryKeys)
            _MetricTile(
              label: InbodyFormat.metricLabel(l10n, key),
              value: InbodyFormat.metricValue(
                l10n,
                key,
                test.metrics.valueOf(key),
              ),
              delta: test.changes?.of(key)?.delta,
              metricKey: key,
            ),
        ],
      ),
    );
  }
}

final class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.metricKey,
    this.delta,
  });

  final String label;
  final String value;
  final String metricKey;
  final double? delta;

  @override
  Widget build(BuildContext context) {
    final color = InbodyFormat.deltaColor(metricKey, delta);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.captionRegular.copyWith(color: AppColors.neutral600),
            ),
          ),
          Text(
            value,
            style: context.contentSemibold.copyWith(color: AppColors.neutral900),
          ),
          if (delta != null) ...[
            const SizedBox(width: 8),
            Icon(
              delta == 0
                  ? Icons.remove
                  : delta! > 0
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
              size: 14,
              color: color,
            ),
            Text(
              InbodyFormat.signedDelta(delta!),
              style: context.footnoteRegular.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _ExtrasCard extends StatelessWidget {
  const _ExtrasCard({required this.extras});

  final InbodyExtrasEntity extras;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (extras.inbodyScore != null)
            _MetricTile(
              label: l10n.inbodyScore,
              value: InbodyFormat.number(extras.inbodyScore),
              metricKey: InbodyMetricKey.inbodyScore,
            ),
          if (extras.height != null)
            _MetricTile(
              label: l10n.inbodyHeight,
              value: InbodyFormat.metricValue(
                l10n,
                InbodyMetricKey.height,
                extras.height,
              ),
              metricKey: InbodyMetricKey.height,
            ),
          if (extras.bodyFatMass != null)
            _MetricTile(
              label: l10n.inbodyBodyFatMass,
              value: InbodyFormat.metricValue(
                l10n,
                InbodyMetricKey.bodyFatMass,
                extras.bodyFatMass,
              ),
              metricKey: InbodyMetricKey.bodyFatMass,
            ),
        ],
      ),
    );
  }
}

final class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary800),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: context.contentSemibold.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.neutral400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _RawDeviceCard extends StatelessWidget {
  const _RawDeviceCard({required this.raw});

  final Map<String, dynamic> raw;

  @override
  Widget build(BuildContext context) {
    final entries = raw.entries
        .where((entry) => '${entry.value}'.trim().isNotEmpty)
        .take(24)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.inbodyMoreFromDevice,
            style: context.highlightBold.copyWith(color: AppColors.neutral900),
          ),
          const SizedBox(height: 8),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: context.captionRegular.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value}',
                    style: context.captionRegular.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
