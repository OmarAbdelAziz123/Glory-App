import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../../core/widgets/app_platform_refresh_scroll.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_segmented_tab_bar.dart';
import '../../domain/entities/inbody_entities.dart';
import '../cubits/inbody_history/inbody_history_cubit.dart';
import '../utils/inbody_format.dart';
import '../widgets/inbody_trend_chart.dart';

final class InbodyHistoryScreen extends StatelessWidget {
  const InbodyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InbodyHistoryCubit>()..load(),
      child: const _InbodyHistoryView(),
    );
  }
}

final class _InbodyHistoryView extends StatefulWidget {
  const _InbodyHistoryView();

  @override
  State<_InbodyHistoryView> createState() => _InbodyHistoryViewState();
}

final class _InbodyHistoryViewState extends State<_InbodyHistoryView>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  var _chartIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<InbodyHistoryCubit>().load(refresh: true);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<InbodyHistoryCubit>().loadMore();
    }
  }

  Future<void> _pickDates(BuildContext context, InbodyHistoryState state) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: state.dateFrom != null && state.dateTo != null
          ? DateTimeRange(start: state.dateFrom!, end: state.dateTo!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onPrimary: AppColors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (range == null || !context.mounted) return;
    await context.read<InbodyHistoryCubit>().applyFilters(
          dateFrom: range.start,
          dateTo: range.end,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InbodyHistoryCubit, InbodyHistoryState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      builder: (context, state) {
        return AppScaffold(
          appBar: AppPrimaryHeader(
            title: context.l10n.bodyCompositionScan,
            centerTitle: true,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Future<void> _refresh() =>
      context.read<InbodyHistoryCubit>().load(refresh: true);

  Widget _refreshable({required Widget child}) {
    return AppPlatformRefreshScroll(
      onRefresh: _refresh,
      child: child,
    );
  }

  Widget _refreshableSlivers(List<Widget> slivers) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: _refresh),
          ...slivers,
        ],
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _refresh,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: slivers,
      ),
    );
  }

  Widget _buildBody(BuildContext context, InbodyHistoryState state) {
    if (state.isLoading && state.tests.isEmpty && state.summary == null) {
      return _refreshable(child: const _HistorySkeleton());
    }

    if (state.status == InbodyHistoryStatus.failure && state.isEmpty) {
      return _refreshable(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.warning_2, color: AppColors.red, size: 40),
                const SizedBox(height: 12),
                Text(
                  state.errorMessage ?? context.l10n.errorTryAgain,
                  textAlign: TextAlign.center,
                  style: context.captionRegular.copyWith(color: AppColors.red),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.summary?.isEmpty ?? state.tests.isEmpty && !state.hasDateFilter) {
      if (state.source == null && !state.hasDateFilter) {
        return _refreshable(
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: _EmptyState(),
            ),
          ),
        );
      }
    }

    return _refreshableSlivers([
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverList.list(
            children: [
              if (state.summary != null && !state.summary!.isEmpty)
                AppEntrance(child: _SummaryCard(summary: state.summary!)),
              if (state.trends.points.length >= 2) ...[
                const SizedBox(height: 16),
                AppEntrance(
                  delay: const Duration(milliseconds: 80),
                  child: _ChartsCard(
                    trends: state.trends,
                    selectedIndex: _chartIndex,
                    onSelected: (index) => setState(() => _chartIndex = index),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _FiltersBar(
                state: state,
                onPickDates: () => _pickDates(context, state),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.inbodyHistorySection,
                style: context.highlightBold.copyWith(
                  color: AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        if (state.tests.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.l10n.inbodyEmptyFilter,
                  textAlign: TextAlign.center,
                  style: context.captionRegular.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList.separated(
              itemCount: state.tests.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= state.tests.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }
                return AppEntrance(
                  delay: Duration(milliseconds: 40 + (index * 40).clamp(0, 240)),
                  child: _TestCard(test: state.tests[index]),
                );
              },
            ),
          ),
    ]);
  }
}

final class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final fakeSummary = InbodySummaryEntity(
      total: 12,
      firstAt: now,
      latestAt: now,
      latest: InbodyTestEntity(
        id: 'skeleton',
        recordedAt: now,
        source: InbodySource.inbody,
        device: 'InBody770',
        metrics: const InbodyMetricsEntity(
          weight: 80.5,
          muscleMass: 32.1,
          bodyFat: 18.4,
        ),
      ),
      sinceFirst: const {
        InbodyMetricKey.weight: InbodyDeltaEntity(previous: 84, delta: -3.5),
        InbodyMetricKey.muscleMass: InbodyDeltaEntity(previous: 31, delta: 1.1),
        InbodyMetricKey.bodyFat: InbodyDeltaEntity(previous: 20, delta: -1.6),
      },
    );
    final fakeTest = InbodyTestEntity(
      id: 'skeleton-test',
      recordedAt: now,
      source: InbodySource.inbody,
      device: 'InBody770',
      metrics: const InbodyMetricsEntity(
        weight: 80.5,
        muscleMass: 32.1,
        bodyFat: 18.4,
      ),
      changes: const InbodyChangesEntity(
        metrics: {
          InbodyMetricKey.weight: InbodyDeltaEntity(previous: 82, delta: -1.5),
          InbodyMetricKey.muscleMass: InbodyDeltaEntity(previous: 31, delta: 1.0),
          InbodyMetricKey.bodyFat: InbodyDeltaEntity(previous: 19, delta: -0.6),
        },
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: IgnorePointer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            _SummaryCard(summary: fakeSummary),
            const SizedBox(height: 16),
            _SkeletonChartCard(),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final label in [
                  context.l10n.inbodyFilterAll,
                  context.l10n.inbodyFilterDevice,
                  context.l10n.inbodyFilterManual,
                  context.l10n.inbodyDateRange,
                ])
                  _FilterChip(label: label, selected: false, onTap: () {}),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.inbodyHistorySection,
              style: context.highlightBold.copyWith(color: AppColors.neutral900),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _TestCard(test: fakeTest),
            ],
            ],
          ),
        ),
      ),
    );
  }
}

final class _SkeletonChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            context.l10n.inbodyProgress,
            style: context.highlightBold.copyWith(color: AppColors.neutral900),
          ),
          const SizedBox(height: 12),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 168,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}

final class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return AppEntrance(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primary100, AppColors.primary200],
              ),
            ),
            child: const Icon(
              Iconsax.chart_2,
              size: 42,
              color: AppColors.primary800,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.inbodyEmptyTitle,
            textAlign: TextAlign.center,
            style: context.highlightBold.copyWith(color: AppColors.neutral900),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.inbodyEmptyDescription,
            textAlign: TextAlign.center,
            style: context.captionRegular.copyWith(
              color: AppColors.neutral500,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

final class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final InbodySummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final latest = summary.latest;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary500, AppColors.primary700],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.inbodySubtitle,
            style: context.captionRegular.copyWith(
              color: AppColors.white.withValues(alpha: 0.92),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SummaryStat(
                label: l10n.inbodyTotalTests,
                value: '${summary.total}',
              ),
              _SummaryStat(
                label: l10n.inbodyFirstTest,
                value: InbodyFormat.date(l10n, summary.firstAt),
              ),
              _SummaryStat(
                label: l10n.inbodyLatestTest,
                value: InbodyFormat.date(l10n, summary.latestAt),
              ),
            ],
          ),
          if (latest != null) ...[
            const SizedBox(height: 16),
            Text(
              l10n.inbodyLatestValues,
              style: context.footnoteRegular.copyWith(
                color: AppColors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final key in InbodyMetricKey.chartKeys)
                  if (latest.metrics.valueOf(key) != null)
                    _HeroMetricChip(
                      label: InbodyFormat.metricLabel(l10n, key),
                      value: InbodyFormat.metricValue(
                        l10n,
                        key,
                        latest.metrics.valueOf(key),
                      ),
                    ),
              ],
            ),
          ],
          if (summary.sinceFirst.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              l10n.inbodySinceStarted,
              style: context.footnoteRegular.copyWith(
                color: AppColors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final key in InbodyMetricKey.chartKeys)
                  if (summary.sinceFirst[key]?.delta != null)
                    _DeltaChip(
                      label: InbodyFormat.metricLabel(l10n, key),
                      metricKey: key,
                      delta: summary.sinceFirst[key]!.delta!,
                      light: true,
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

final class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.footnoteRegular.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.contentSemibold.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

final class _HeroMetricChip extends StatelessWidget {
  const _HeroMetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.footnoteRegular.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          Text(
            value,
            style: context.captionBold.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

final class _ChartsCard extends StatelessWidget {
  const _ChartsCard({
    required this.trends,
    required this.selectedIndex,
    required this.onSelected,
  });

  final InbodyTrendsEntity trends;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final keys = InbodyMetricKey.chartKeys;
    final key = keys[selectedIndex.clamp(0, keys.length - 1)];

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
            context.l10n.inbodyProgress,
            style: context.highlightBold.copyWith(color: AppColors.neutral900),
          ),
          const SizedBox(height: 12),
          AppSegmentedTabBar(
            compactStyle: true,
            tabs: [
              context.l10n.inbodyChartWeight,
              context.l10n.inbodyChartMuscle,
              context.l10n.inbodyChartFat,
            ],
            selectedIndex: selectedIndex,
            onSelected: onSelected,
          ),
          const SizedBox(height: 12),
          InbodyTrendChart(
            points: trends.points,
            metricKey: key,
            localeName: context.l10n.localeName,
          ),
        ],
      ),
    );
  }
}

final class _FiltersBar extends StatelessWidget {
  const _FiltersBar({required this.state, required this.onPickDates});

  final InbodyHistoryState state;
  final VoidCallback onPickDates;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InbodyHistoryCubit>();
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: l10n.inbodyFilterAll,
              selected: state.source == null,
              onTap: () => cubit.applyFilters(clearSource: true),
            ),
            _FilterChip(
              label: l10n.inbodyFilterDevice,
              selected: state.source == InbodySource.inbody,
              onTap: () => cubit.applyFilters(source: InbodySource.inbody),
            ),
            _FilterChip(
              label: l10n.inbodyFilterManual,
              selected: state.source == InbodySource.manual,
              onTap: () => cubit.applyFilters(source: InbodySource.manual),
            ),
            _FilterChip(
              label: state.hasDateFilter
                  ? '${InbodyFormat.shortDate(l10n.localeName, state.dateFrom ?? state.dateTo!)} – ${InbodyFormat.shortDate(l10n.localeName, state.dateTo ?? state.dateFrom!)}'
                  : l10n.inbodyDateRange,
              selected: state.hasDateFilter,
              icon: Iconsax.calendar_1,
              onTap: onPickDates,
            ),
            if (state.hasDateFilter)
              _FilterChip(
                label: l10n.inbodyClearDates,
                selected: false,
                onTap: () => cubit.applyFilters(clearDates: true),
              ),
          ],
        ),
      ],
    );
  }
}

final class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.neutral200,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? AppColors.white : AppColors.primary800,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: context.footnoteRegular.copyWith(
                  color: selected ? AppColors.white : AppColors.neutral800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _TestCard extends StatelessWidget {
  const _TestCard({required this.test});

  final InbodyTestEntity test;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.inbodyDetail.replaceFirst(':id', test.id),
        ),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        test.isDevice ? Iconsax.cpu : Iconsax.edit_2,
                        size: 20,
                        color: AppColors.primary800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            InbodyFormat.dateTime(l10n, test.recordedAt),
                            style: context.captionBold.copyWith(
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            test.isDevice
                                ? (test.device ?? l10n.inbodyDeviceBadge)
                                : (test.enteredBy == null
                                    ? l10n.inbodyManualBadge
                                    : l10n.inbodyEnteredBy(
                                        test.enteredBy!.fullName,
                                      )),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.footnoteRegular.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _SourceBadge(isDevice: test.isDevice),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    for (final key in InbodyMetricKey.chartKeys)
                      Expanded(
                        child: _MetricCell(
                          metricKey: key,
                          value: test.metrics.valueOf(key),
                          delta: test.changes?.of(key)?.delta,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.metricKey,
    required this.value,
    this.delta,
  });

  final String metricKey;
  final double? value;
  final double? delta;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          InbodyFormat.metricLabel(l10n, metricKey),
          textAlign: TextAlign.center,
          style: context.footnoteRegular.copyWith(color: AppColors.neutral500),
        ),
        const SizedBox(height: 4),
        Text(
          InbodyFormat.metricValue(l10n, metricKey, value),
          textAlign: TextAlign.center,
          style: context.contentSemibold.copyWith(color: AppColors.neutral900),
        ),
        if (delta != null) ...[
          const SizedBox(height: 4),
          _DeltaChip(metricKey: metricKey, delta: delta!, compact: true),
        ],
      ],
    );
  }
}

final class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.isDevice});

  final bool isDevice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDevice ? AppColors.primary100 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isDevice
            ? context.l10n.inbodyDeviceBadge
            : context.l10n.inbodyManualBadge,
        style: context.footnoteRegular.copyWith(
          color: isDevice ? AppColors.primary800 : AppColors.neutral700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

final class _DeltaChip extends StatelessWidget {
  const _DeltaChip({
    required this.metricKey,
    required this.delta,
    this.label,
    this.light = false,
    this.compact = false,
  });

  final String metricKey;
  final double delta;
  final String? label;
  final bool light;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = light ? AppColors.white : InbodyFormat.deltaColor(metricKey, delta);
    final icon = delta == 0
        ? Icons.remove
        : delta > 0
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 5,
      ),
      decoration: BoxDecoration(
        color: light
            ? AppColors.white.withValues(alpha: 0.16)
            : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            [
              if (label != null) label,
              InbodyFormat.signedDelta(delta),
            ].whereType<String>().join(' '),
            style: context.footnoteRegular.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
