import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_colors.dart';

final class AppMemberAvatar extends StatelessWidget {
  const AppMemberAvatar({
    super.key,
    this.avatarUrl,
    this.size = 60,
    this.borderRadius = 99,
    this.backgroundColor = AppColors.primary600,
    this.iconColor = AppColors.white,
  });

  final String? avatarUrl;
  final double size;
  final double borderRadius;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    final url = avatarUrl;
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (_, _) => _fallback(),
        errorWidget: (_, _, _) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: Icon(
          Iconsax.user,
          color: iconColor,
          size: size * 0.45,
        ),
      ),
    );
  }
}
