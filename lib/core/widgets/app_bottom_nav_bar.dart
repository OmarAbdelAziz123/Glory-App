import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/l10n_extension.dart';
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

  static const _tabIcons = [
    (tab: AppNavTab.home, icon: 'assets/images/svgs/home_icon.svg'),
    (tab: AppNavTab.bookings, icon: 'assets/images/svgs/my_bookings_icon.svg'),
    (tab: AppNavTab.gloryAi, icon: 'assets/images/svgs/ai_icon.svg'),
    (tab: AppNavTab.workouts, icon: 'assets/images/svgs/my_exercises_icon.svg'),
    (tab: AppNavTab.settings, icon: 'assets/images/svgs/settings_icon.svg'),
  ];

  String _labelFor(AppNavTab tab, AppLocalizations l10n) => switch (tab) {
        AppNavTab.home => l10n.home,
        AppNavTab.bookings => l10n.bookings,
        AppNavTab.gloryAi => l10n.sandyAi,
        AppNavTab.workouts => l10n.myWorkouts,
        AppNavTab.settings => l10n.settings,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
            children: _tabIcons.map((t) {
              final bool active = t.tab == currentTab;
              final color = active ? AppColors.primary : AppColors.neutral400;
              final label = _labelFor(t.tab, l10n);
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
                        child: Text(label),
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
