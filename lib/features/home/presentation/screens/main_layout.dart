import 'package:flutter/material.dart';

import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../bookings/presentation/screens/bookings_screen.dart';
import '../../../glory_ai/presentation/screens/glory_ai_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../workouts/presentation/screens/workouts_screen.dart';
import 'home_screen.dart';

final class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

final class _MainLayoutState extends State<MainLayout> {
  AppNavTab _currentTab = AppNavTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          HomeScreen(
            onOpenBookingsTab: () =>
                setState(() => _currentTab = AppNavTab.bookings),
          ),
          const BookingsScreen(),
          GloryAiScreen(),
          WorkoutsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentTab: _currentTab,
        onTabChanged: (tab) => setState(() => _currentTab = tab),
      ),
    );
  }
}
