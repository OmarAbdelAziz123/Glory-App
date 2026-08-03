import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import '../../../notifications/presentation/cubits/notifications_unread/notifications_unread_cubit.dart';
import '../../../../core/widgets/app_animated_indexed_stack.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_entrance.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileCubit>().fetchProfile();
      context.read<NotificationsUnreadCubit>().fetchUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppAnimatedIndexedStack(
        index: _currentTab.index,
        children: [
          HomeScreen(
            onOpenBookingsTab: () =>
                setState(() => _currentTab = AppNavTab.bookings),
            onOpenWorkoutsTab: () =>
                setState(() => _currentTab = AppNavTab.workouts),
          ),
          const BookingsScreen(),
          GloryAiScreen(),
          WorkoutsScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: AppEntrance(
        delay: const Duration(milliseconds: 180),
        offset: const Offset(0, 0.2),
        duration: const Duration(milliseconds: 480),
        child: AppBottomNavBar(
          currentTab: _currentTab,
          onTabChanged: (tab) => setState(() => _currentTab = tab),
        ),
      ),
    );
  }
}
