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
    this.compactStyle = false,
  }) : assert(tabs.isNotEmpty, 'tabs must not be empty');

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final double gap;
  final bool compactStyle;

  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedIndex.clamp(0, tabs.length - 1);
    final outerRadius = compactStyle ? 6.0 : AppSpacing.md;
    final innerRadius = compactStyle ? 4.0 : AppSpacing.sm;
    final outerBorder = compactStyle ? AppColors.primary10 : AppColors.primary100;
    final unselectedBorder =
        compactStyle ? AppColors.neutral400 : AppColors.neutral200;

    return Container(
      padding: EdgeInsets.all(compactStyle ? 8 : AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: outerBorder),
        borderRadius: BorderRadius.circular(outerRadius),
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
                borderRadius: innerRadius,
                unselectedBorderColor: unselectedBorder,
                compact: compactStyle,
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
    required this.borderRadius,
    required this.unselectedBorderColor,
    required this.compact,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double borderRadius;
  final Color unselectedBorderColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final padding = compact
        ? const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
        : const EdgeInsets.symmetric(vertical: 10, horizontal: 8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: padding,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.white,
            borderRadius: radius,
            border: selected ? null : Border.all(color: unselectedBorderColor),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: context.subtitleMedium.copyWith(
                fontSize: compact ? 14 : null,
                color: selected
                    ? AppColors.white
                    : (compact ? AppColors.neutral400 : AppColors.neutral600),
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
