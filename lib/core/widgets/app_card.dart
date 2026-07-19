import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

final class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: radius,
          border: Border.all(
            color: borderColor ?? AppColors.neutral200,
            width: 0.5,
          ),
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
