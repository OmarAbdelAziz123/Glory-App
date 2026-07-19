import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glory_gym/core/router/app_routes.dart';
import 'package:glory_gym/core/widgets/app_home_header.dart';
import 'package:glory_gym/core/widgets/app_scaffold.dart';
import 'package:glory_gym/core/widgets/app_segmented_tab_bar.dart';
import 'package:glory_gym/features/home/presentation/widgets/home_tab_contents.dart';
import 'package:go_router/go_router.dart';

final class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onOpenBookingsTab});

  /// Switches main bottom nav to the bookings tab (index 1).
  final VoidCallback? onOpenBookingsTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final class _HomeScreenState extends State<HomeScreen> {
  static const _countdownSeconds = 15;

  static const _tabLabels = <String>[
    'تسجيل للجيم',
    'المواعيد',
    'الحصص الجماعية',
  ];

  int _selectedTabIndex = 0;

  String? _qrData;
  int _secondsLeft = 0;
  Timer? _timer;

  bool get _hasQr => _qrData != null;
  bool get _isCountingDown => _secondsLeft > 0;

  void _generateQr() {
    _timer?.cancel();
    setState(() {
      _qrData = 'glory-gym-${DateTime.now().millisecondsSinceEpoch}';
      _secondsLeft = _countdownSeconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppHomeHeader(
        username: 'احمد حسام',
        greeting: 'صباح الخير',
        notificationCount: 3,
        avatarAsset: 'assets/images/pngs/profile_image.png',
        onNotificationTap: () => context.push(AppRoutes.notifications),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSegmentedTabBar(
                tabs: _tabLabels,
                selectedIndex: _selectedTabIndex,
                onSelected: (i) => setState(() => _selectedTabIndex = i),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: IndexedStack(
                  index: _selectedTabIndex,
                  sizing: StackFit.expand,
                  children: [
                    HomeGymRegistrationTabContent(
                      hasQr: _hasQr,
                      qrData: _qrData,
                      secondsLeft: _secondsLeft,
                      isCountingDown: _isCountingDown,
                      onGenerateQr: _generateQr,
                    ),
                    SingleChildScrollView(
                      child: HomeAppointmentsTabContent(
                        onViewAll: widget.onOpenBookingsTab,
                      ),
                    ),
                    SingleChildScrollView(
                      child: HomeGroupClassesTabContent(
                        onViewAll: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
