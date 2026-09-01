import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// Platform back chevron that mirrors automatically for LTR (English).
///
/// Asset SVGs point toward the trailing edge (correct for Arabic / RTL).
/// For English they are flipped horizontally so the chevron points back.
final class AppNavBackIcon extends StatelessWidget {
  const AppNavBackIcon({
    super.key,
    this.color,
    this.width,
    this.height,
    this.fit = BoxFit.scaleDown,
  });

  final Color? color;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final asset = Theme.of(context).platform == TargetPlatform.iOS
        ? 'assets/images/svgs/back_icon_for_ios.svg'
        : 'assets/images/svgs/back_icon_for_android.svg';

    final icon = SvgPicture.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    if (isRtl) return icon;

    return Transform.flip(flipX: true, child: icon);
  }
}

/// Defaults to neutral1000 when no color is passed — useful on light surfaces.
final class AppNavBackIconDark extends StatelessWidget {
  const AppNavBackIconDark({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.scaleDown,
  });

  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return AppNavBackIcon(
      color: AppColors.neutral1000,
      width: width,
      height: height,
      fit: fit,
    );
  }
}

/// White variant for primary / gradient headers.
final class AppNavBackIconLight extends StatelessWidget {
  const AppNavBackIconLight({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.scaleDown,
  });

  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return AppNavBackIcon(
      color: AppColors.white,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
