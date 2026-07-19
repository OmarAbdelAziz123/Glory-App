import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';

final class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  static const _subscriptions = [
    _SubscriptionData(
      packageName: 'اسم الباقة',
      packageType: 'حصص',
      startDate: '١٠ يونيو ٢٠٢٦',
      endDate: '١ مايو ٢٠٢٦',
    ),
    _SubscriptionData(
      packageName: 'اسم الباقة',
      packageType: 'حصص',
      startDate: '١٠ يونيو ٢٠٢٦',
      endDate: '١ مايو ٢٠٢٦',
    ),
    _SubscriptionData(
      packageName: 'اسم الباقة',
      packageType: 'حصص',
      startDate: '١٠ يونيو ٢٠٢٦',
      endDate: '١ مايو ٢٠٢٦',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'اشتراكاتي',
        showBack: true,
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: _subscriptions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) =>
            _SubscriptionCard(data: _subscriptions[index]),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

final class _SubscriptionData {
  const _SubscriptionData({
    required this.packageName,
    required this.packageType,
    required this.startDate,
    required this.endDate,
  });

  final String packageName;
  final String packageType;
  final String startDate;
  final String endDate;
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({required this.data});

  final _SubscriptionData data;

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
          _PackageHeader(name: data.packageName),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: 12),
          _PackageDetails(data: data),
        ],
      ),
    );
  }
}

final class _PackageHeader extends StatelessWidget {
  const _PackageHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.neutral200,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        12.horizontal,
        Expanded(
          child: Text(
            name,
            style: context.captionBold.copyWith(color: AppColors.neutral900),
          ),
        ),
      ],
    );
  }
}

final class _PackageDetails extends StatelessWidget {
  const _PackageDetails({required this.data});

  final _SubscriptionData data;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _DetailCell(label: 'تاريخ البداية', value: data.startDate),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailCell(label: 'تاريخ الانتهاء', value: data.endDate),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailCell(label: 'نوع الباقة', value: data.packageType),
          ),
        ],
      ),
    );
  }
}

final class _DetailCell extends StatelessWidget {
  const _DetailCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: context.footnoteRegular.copyWith(color: AppColors.neutral400),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(value, style: context.subtitleMedium, textAlign: TextAlign.center),
      ],
    );
  }
}
