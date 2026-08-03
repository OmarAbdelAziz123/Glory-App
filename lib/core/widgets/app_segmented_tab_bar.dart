import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';

/// Segmented tabs inside a rounded frame (light primary border).
///
/// Tabs share equal width. Use with [IndexedStack] or [AnimatedSwitcher]
/// for per-tab bodies. Order follows [tabs]; in RTL the first tab appears
/// at the visual start edge.
final class AppSegmentedTabBar extends StatelessWidget {
  AppSegmentedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
    this.gap = AppSpacing.sm,
  }) : assert(tabs.isNotEmpty, 'tabs must not be empty');

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedIndex.clamp(0, tabs.length - 1);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary100),
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Expanded(
              child: _SegmentedTabButton(
                label: tabs[i],
                selected: i == safeIndex,
                onTap: () => onSelected(i),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _SegmentedTabButton extends StatelessWidget {
  const _SegmentedTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _radius = AppSpacing.sm;
  static const _padding = EdgeInsets.symmetric(vertical: 10, horizontal: 8);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(_radius);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: _padding,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.white,
            borderRadius: radius,
            border: selected ? null : Border.all(color: AppColors.neutral200),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: context.subtitleMedium.copyWith(
                color: selected ? AppColors.white : AppColors.neutral600,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
