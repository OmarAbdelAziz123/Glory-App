import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/core/utils/greeting_utils.dart';
import 'package:glory_gym/features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/bookings_list/bookings_list_cubit.dart';
import 'package:glory_gym/features/checkin/presentation/cubits/gym_qr/gym_qr_cubit.dart';
import 'package:glory_gym/features/home/presentation/widgets/home_tab_contents.dart';
import 'package:glory_gym/features/notifications/presentation/cubits/notifications_unread/notifications_unread_cubit.dart';
import 'package:glory_gym/features/workouts/presentation/cubits/workouts_list/workouts_list_cubit.dart';
import 'package:go_router/go_router.dart';

final class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.onOpenBookingsTab,
    this.onOpenWorkoutsTab,
  });

  final VoidCallback? onOpenBookingsTab;
  final VoidCallback? onOpenWorkoutsTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  List<String> _tabLabels(BuildContext context) => [
        context.l10n.gymCheckIn,
        context.l10n.appointments,
        context.l10n.groupClasses,
      ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GymQrCubit>()),
        BlocProvider(
          create: (_) => sl<BookingsListCubit>()..loadBookings(limit: 2),
        ),
        BlocProvider(
          create: (_) => sl<WorkoutsListCubit>()..loadWorkouts(limit: 1),
        ),
      ],
      child: Builder(
        builder: (providerContext) {
          return MultiBlocListener(
            listeners: [
              BlocListener<GymQrCubit, GymQrState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status &&
                    current.status == GymQrStatus.consumed,
                listener: (context, state) {
                  final days = state.daysRemaining ?? 0;
                  AppSuccessSheet.show(
                    context,
                    title: context.l10n.gymCheckIn,
                    headline: context.l10n.gymCheckInSuccess,
                    highlightWord: context.l10n.successfully,
                    description:
                        context.l10n.subscriptionDaysRemainingWelcome('$days'),
                    buttonLabel: context.l10n.home,
                    badgeAsset:
                        'assets/images/svgs/success_when_create_anew_password_icon.svg',
                    onButtonPressed: () => Navigator.of(context).pop(),
                  );
                },
              ),
              BlocListener<BookingsListCubit, BookingsListState>(
                listenWhen: (previous, current) =>
                    previous.lastCheckInResult != current.lastCheckInResult &&
                    current.lastCheckInResult != null,
                listener: (context, state) {
                  final result = state.lastCheckInResult;
                  if (result == null) return;

                  AppSuccessSheet.show(
                    context,
                    title: context.l10n.trainingCheckIn,
                    headline: context.l10n.classCheckInSuccess,
                    highlightWord: context.l10n.successfully,
                    description:
                        '${context.l10n.checkinClassWelcomePrefix(result.packageNameAr)}'
                        '${context.l10n.checkinClassWelcomeSuffix(result.instructorName, '${result.remainingSessions}')}',
                    buttonLabel: context.l10n.home,
                    badgeAsset:
                        'assets/images/svgs/success_when_create_anew_password_icon.svg',
                    onButtonPressed: () {
                      context.read<BookingsListCubit>().clearCheckInResult();
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
            child: _HomeBody(
              selectedTabIndex: _selectedTabIndex,
              tabLabels: _tabLabels(providerContext),
              onOpenBookingsTab: widget.onOpenBookingsTab,
              onOpenWorkoutsTab: widget.onOpenWorkoutsTab,
              onTabSelected: (index) =>
                  setState(() => _selectedTabIndex = index),
            ),
          );
        },
      ),
    );
  }
}

final class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.selectedTabIndex,
    required this.tabLabels,
    required this.onTabSelected,
    this.onOpenBookingsTab,
    this.onOpenWorkoutsTab,
  });

  final int selectedTabIndex;
  final List<String> tabLabels;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onOpenBookingsTab;
  final VoidCallback? onOpenWorkoutsTab;

  Widget _tabContent(BuildContext context) {
    final qrState = context.watch<GymQrCubit>().state;
    final bookingsState = context.watch<BookingsListCubit>().state;
    final locale = context.l10n.localeName;

    return switch (selectedTabIndex) {
      0 => HomeGymRegistrationTabContent(
          key: const ValueKey('home-tab-qr'),
          hasQr: qrState.hasActiveQr,
          qrData: qrState.qrToken,
          secondsLeft: qrState.secondsLeft,
          isGenerating: qrState.isGenerating,
          canRegenerate: qrState.canRegenerate,
          onGenerateQr: () => context.read<GymQrCubit>().generateQr(),
        ),
      1 => SingleChildScrollView(
          key: const ValueKey('home-tab-appointments'),
          child: HomeAppointmentsTabContent(
            bookings: bookingsState.bookings,
            locale: locale,
            isLoading: bookingsState.isLoading,
            onViewAll: onOpenBookingsTab,
            onCheckIn: (id) =>
                context.read<BookingsListCubit>().checkInBooking(id),
            onCancel: (id) => _confirmCancel(context, id),
            onEvaluate: (id) => context.push(
              AppRoutes.classEvaluation,
              extra: id,
            ),
          ),
        ),
      _ => SingleChildScrollView(
          key: const ValueKey('home-tab-classes'),
          child: HomeGroupClassesTabContent(
            onViewAll: onOpenWorkoutsTab,
          ),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileCubit>().state;
    final unreadCount = context.watch<NotificationsUnreadCubit>().state.count;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHomeHeader(
            username: profile.displayName(context.l10n),
            greeting: GreetingUtils.greeting(context.l10n),
            notificationCount: unreadCount,
            avatarUrl: profile.member?.avatarUrl,
            onNotificationTap: () async {
              await context.push(AppRoutes.notifications);
              if (context.mounted) {
                context.read<NotificationsUnreadCubit>().fetchUnreadCount();
              }
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppEntrance(
                    delay: const Duration(milliseconds: 120),
                    offset: const Offset(0, 0.05),
                    child: AppSegmentedTabBar(
                      tabs: tabLabels,
                      selectedIndex: selectedTabIndex,
                      onSelected: onTabSelected,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      child: _tabContent(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, String bookingId) async {
    final shouldCancel = await AppConfirmDialog.show(
      context,
      title: context.l10n.cancelClass,
      message: context.l10n.confirmCancelClass,
      confirmLabel: context.l10n.cancelClass,
    );

    if (shouldCancel != true || !context.mounted) return;

    final success =
        await context.read<BookingsListCubit>().cancelBooking(bookingId);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.classCancelledSuccess)),
      );
      return;
    }

    final error = context.read<BookingsListCubit>().state.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}
