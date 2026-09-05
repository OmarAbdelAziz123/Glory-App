import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/core/utils/camera_permission_utils.dart';
import 'package:glory_gym/features/checkin/presentation/cubits/qr_scan/qr_scan_cubit.dart';
import 'package:glory_gym/features/checkin/presentation/screens/qr_scanner_screen.dart';
import 'package:glory_gym/features/home/presentation/widgets/group_class_card.dart';
import 'package:glory_gym/features/workouts/presentation/cubits/workouts_list/workouts_list_cubit.dart';
import 'package:go_router/go_router.dart';

final class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

final class _WorkoutsScreenState extends State<WorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<WorkoutsListCubit>()..loadWorkouts()),
        BlocProvider(create: (_) => sl<QrScanCubit>()),
      ],
      child: const _WorkoutsBody(),
    );
  }
}

final class _WorkoutsBody extends StatefulWidget {
  const _WorkoutsBody();

  @override
  State<_WorkoutsBody> createState() => _WorkoutsBodyState();
}

final class _WorkoutsBodyState extends State<_WorkoutsBody> {
  int _selectedTabIndex = 0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !mounted) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      context.read<WorkoutsListCubit>().loadMore();
    }
  }

  List<String> _tabLabels(BuildContext context) => [
        context.l10n.groupClasses,
        context.l10n.individualSessions,
      ];

  Future<void> _openQrScanner(BuildContext context) async {
    final granted = await CameraPermissionUtils.ensureGranted(context);
    if (!granted || !context.mounted) return;

    final rawValue = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );

    if (rawValue == null || !context.mounted) return;

    final success = await context.read<QrScanCubit>().scan(rawValue);
    if (!context.mounted) return;

    if (success) {
      final result = context.read<QrScanCubit>().state.result;
      final days = result?.daysRemaining ?? 0;
      AppSuccessSheet.show(
        context,
        title: context.l10n.individualSessions,
        headline: context.l10n.qrScanSuccess,
        highlightWord: context.l10n.successfully,
        description: days > 0
            ? context.l10n.subscriptionDaysRemainingWelcome('$days')
            : context.l10n.qrScanSuccess,
        buttonLabel: context.l10n.home,
        badgeAsset:
            'assets/images/svgs/success_when_create_anew_password_icon.svg',
        onButtonPressed: () {
          context.read<QrScanCubit>().reset();
          Navigator.of(context).pop();
        },
      );
      return;
    }

    final error = context.read<QrScanCubit>().state.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutsListCubit, WorkoutsListState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      child: AppScaffold(
        appBar: AppPrimaryHeader(
          title: context.l10n.myWorkouts,
          showBack: false,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSegmentedTabBar(
                tabs: _tabLabels(context),
                selectedIndex: _selectedTabIndex,
                onSelected: (index) => setState(() => _selectedTabIndex = index),
                gap: 12,
                compactStyle: true,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        for (final child in previousChildren)
                          Positioned.fill(child: child),
                        if (currentChild != null)
                          Positioned.fill(child: currentChild),
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: slide,
                        child: child,
                      ),
                    );
                  },
                  child: _selectedTabIndex == 0
                      ? _WorkoutCardsTab(
                          key: const ValueKey('workouts-group-classes'),
                          scrollController: _scrollController,
                          showScanButton: false,
                        )
                      : _WorkoutCardsTab(
                          key: const ValueKey('workouts-individual-sessions'),
                          scrollController: _scrollController,
                          showScanButton: true,
                          onScanPressed: () => _openQrScanner(context),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _WorkoutCardsTab extends StatelessWidget {
  const _WorkoutCardsTab({
    super.key,
    required this.scrollController,
    required this.showScanButton,
    this.onScanPressed,
  });

  final ScrollController scrollController;
  final bool showScanButton;
  final VoidCallback? onScanPressed;

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n.localeName;
    final isScanning = context.watch<QrScanCubit>().state.isSubmitting;

    return BlocBuilder<WorkoutsListCubit, WorkoutsListState>(
      builder: (context, state) {
        Future<void> refresh() =>
            context.read<WorkoutsListCubit>().loadWorkouts(refresh: true);

        if (state.isLoading && state.workouts.isEmpty) {
          return AppPlatformRefreshScroll(
            onRefresh: refresh,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == WorkoutsListStatus.failure &&
            state.workouts.isEmpty) {
          return AppPlatformRefreshScroll(
            onRefresh: refresh,
            child: Center(
              child: Text(
                state.errorMessage ?? context.l10n.errorTryAgain,
                style: context.captionRegular,
              ),
            ),
          );
        }

        final cards = state.isEmpty
            ? <Widget>[
                Center(
                  child: Text(
                    context.l10n.noWorkouts,
                    style: context.captionRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ),
              ]
            : state.workouts.asMap().entries.map((entry) {
                final workout = entry.value;
                final item = WorkoutUtils.toGroupClassItem(
                  workout,
                  l10n: context.l10n,
                  locale: locale,
                  includeExtraDetail: false,
                );

                return AppEntrance(
                  key: ValueKey('workout-${workout.id}'),
                  delay: Duration(milliseconds: (entry.key.clamp(0, 5)) * 70),
                  offset: const Offset(0, 0.06),
                  child: GestureDetector(
                    onTap: () => context.push(
                      AppRoutes.workoutDetail.replaceFirst(':id', workout.id),
                    ),
                    child: GroupClassCard(
                      item: item,
                      showPlayButton: true,
                      useWorkoutMetricLabels: true,
                    ),
                  ),
                );
              }).toList();

        final hasPendingWorkout = state.workouts.any(
          (workout) => WorkoutUtils.isPendingStatus(workout.status),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AppPlatformRefreshListView(
                controller: scrollController,
                onRefresh: refresh,
                itemCount: cards.length + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 18),
                itemBuilder: (_, index) {
                  if (index >= cards.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return cards[index];
                },
              ),
            ),
            if (showScanButton && hasPendingWorkout) ...[
              const SizedBox(height: 16),
              AppButton(
                label: context.l10n.scanQrCode,
                isLoading: isScanning,
                onPressed: isScanning ? null : onScanPressed,
              ),
            ],
          ],
        );
      },
    );
  }
}
