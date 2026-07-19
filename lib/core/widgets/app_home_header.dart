import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';

final class AppHomeHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const AppHomeHeader({
    super.key,
    required this.username,
    this.greeting = 'صباح الخير',
    this.notificationCount = 0,
    this.avatarAsset,
    this.avatarUrl,
    this.onNotificationTap,
  });

  final String username;
  final String greeting;
  final int notificationCount;
  final String? avatarAsset;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;

  @override
  Size get preferredSize => const Size.fromHeight(137);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      child: Container(
        color: AppColors.primary800,
        child: SizedBox(
          height: 137,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: -12,
                bottom: 0,
                child: Opacity(
                  opacity: 0.25,
                  child: Image.asset(
                    'assets/images/pngs/bg_image_on_appbar.png',
                    height: 220,
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _Avatar(
                              assetPath: avatarAsset,
                              networkUrl: avatarUrl,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              spacing: 6,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$greeting ',
                                  style: context.subtitleMedium.copyWith(
                                    color: AppColors.neutral100,
                                  ),
                                ),
                                Text(
                                  username,
                                  style: context.highlightAccent.copyWith(
                                    color: AppColors.neutral100,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      _NotificationBell(
                        count: notificationCount,
                        onTap: onNotificationTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Private widgets ──────────────────────────────────────────────────────────

final class _Avatar extends StatelessWidget {
  const _Avatar({this.assetPath, this.networkUrl});

  final String? assetPath;
  final String? networkUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(width: 66, height: 66, child: _image()),
    );
  }

  Widget _image() {
    if (assetPath != null) {
      return Image.asset(assetPath!, fit: BoxFit.cover);
    }
    if (networkUrl != null) {
      return Image.network(networkUrl!, fit: BoxFit.cover);
    }
    return Container(
      color: AppColors.primary600,
      child: const Icon(Icons.person, color: AppColors.white, size: 32),
    );
  }
}

final class _NotificationBell extends StatelessWidget {
  const _NotificationBell({this.count = 0, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset('assets/images/svgs/notification_icon.svg'),
          if (count > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
