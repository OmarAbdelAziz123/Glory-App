import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import '../../../coach_chat/data/datasources/coach_chat_socket_service.dart';
import '../../../coach_chat/presentation/cubits/coach_chat_unread/coach_chat_unread_cubit.dart';
import '../../../notifications/presentation/cubits/notifications_unread/notifications_unread_cubit.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/app_animated_indexed_stack.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_coach_chat_fab_overlay.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../bookings/presentation/screens/bookings_screen.dart';
import '../../../glory_ai/presentation/cubits/sandy_chat/sandy_chat_cubit.dart';
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
      MainShellTabNotifier.current.value = _currentTab;
      context.read<UserProfileCubit>().fetchProfile();
      context.read<NotificationsUnreadCubit>().fetchUnreadCount();
      context.read<CoachChatUnreadCubit>().fetchUnreadCount();
      sl<CoachChatSocketService>().connect();
    });
  }

  @override
  void dispose() {
    if (MainShellTabNotifier.current.value == _currentTab) {
      MainShellTabNotifier.current.value = null;
    }
    super.dispose();
  }

  void _onTabChanged(AppNavTab tab) {
    setState(() => _currentTab = tab);
    MainShellTabNotifier.current.value = tab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppAnimatedIndexedStack(
        index: _currentTab.index,
        children: [
          HomeScreen(
            onOpenBookingsTab: () => _onTabChanged(AppNavTab.bookings),
            onOpenWorkoutsTab: () => _onTabChanged(AppNavTab.workouts),
          ),
          const BookingsScreen(),
          BlocProvider.value(
            value: sl<SandyChatCubit>()..initialize(),
            child: const GloryAiScreen(),
          ),
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
          onTabChanged: _onTabChanged,
        ),
      ),
    );
  }
}
