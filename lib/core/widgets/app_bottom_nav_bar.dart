import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

enum AppNavTab { home, bookings, gloryAi, workouts, settings }

final class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  final AppNavTab currentTab;
  final ValueChanged<AppNavTab> onTabChanged;

  static const _tabs = [
    (
      tab: AppNavTab.home,
      icon: 'assets/images/svgs/home_icon.svg',
      label: 'الرئيسية',
    ),
    (
      tab: AppNavTab.bookings,
      icon: 'assets/images/svgs/my_bookings_icon.svg',
      label: 'الحجوزات',
    ),
    (
      tab: AppNavTab.gloryAi,
      icon: 'assets/images/svgs/ai_icon.svg',
      label: 'ساندي AI',
    ),
    (
      tab: AppNavTab.workouts,
      icon: 'assets/images/svgs/my_exercises_icon.svg',
      label: 'تماريني',
    ),
    (
      tab: AppNavTab.settings,
      icon: 'assets/images/svgs/settings_icon.svg',
      label: 'الإعدادات',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.neutral200, width: 0.5),
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: _tabs.map((t) {
              final bool active = t.tab == currentTab;
              final color = active ? AppColors.primary : AppColors.neutral400;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(t.tab),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: active ? 1.12 : 1.0,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutBack,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: SvgPicture.asset(
                            t.icon,
                            key: ValueKey('${t.tab}-$active'),
                            width: 24,
                            height: 24,
                            colorFilter:
                                ColorFilter.mode(color, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        style: Styles.footnoteRegular(context).copyWith(
                          color: color,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w400,
                        ),
                        child: Text(t.label),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
