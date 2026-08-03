import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import 'app_entrance.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';

final class AppHomeHeader extends StatelessWidget {
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

  static const _contentHeight = 76.0;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary800,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: AppEntrance(
              delay: const Duration(milliseconds: 40),
              offset: const Offset(-0.04, 0),
              duration: const Duration(milliseconds: 560),
              child: Opacity(
                opacity: 0.25,
                child: Image.asset(
                  'assets/images/pngs/bg_image_on_appbar.png',
                  height: topInset + _contentHeight + 40,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topInset),
            child: SizedBox(
              height: _contentHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppEntrance(
                        delay: const Duration(milliseconds: 80),
                        offset: const Offset(0.06, 0),
                        child: Row(
                          children: [
                            _Avatar(
                              assetPath: avatarAsset,
                              networkUrl: avatarUrl,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    greeting,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.subtitleMedium.copyWith(
                                      color: AppColors.neutral100,
                                    ),
                                  ),
                                  Text(
                                    username,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.highlightAccent.copyWith(
                                      color: AppColors.neutral100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppEntrance(
                      delay: const Duration(milliseconds: 160),
                      offset: const Offset(-0.08, 0),
                      child: _NotificationBell(
                        count: notificationCount,
                        onTap: onNotificationTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
      child: SizedBox(width: 52, height: 52, child: _image()),
    );
  }

  Widget _image() {
    if (networkUrl != null && networkUrl!.isNotEmpty) {
      return Image.network(
        networkUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() => ColoredBox(
        color: AppColors.primary600,
        child: Center(
          child: Icon(
            Iconsax.user,
            color: AppColors.white,
            size: 24,
          ),
        ),
      );
}

final class _NotificationBell extends StatefulWidget {
  const _NotificationBell({this.count = 0, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  State<_NotificationBell> createState() => _NotificationBellState();
}

final class _NotificationBellState extends State<_NotificationBell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.count > 0) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _NotificationBell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count > 0 && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (widget.count <= 0 && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset('assets/images/svgs/notification_icon.svg'),
          if (widget.count > 0)
            Positioned(
              top: -6,
              right: -6,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.08).animate(
                  CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.count}',
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
            ),
        ],
      ),
    );
  }
}
