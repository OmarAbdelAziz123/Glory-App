import 'dart:ui';

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
    this.greeting,
    this.notificationCount = 0,
    this.avatarAsset,
    this.avatarUrl,
    this.onNotificationTap,
  });

  final String username;
  final String? greeting;
  final int notificationCount;
  final String? avatarAsset;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;

  static const _goldAccent = Color(0xFFFFB03B);
  static const _headerTop = Color(0xFF1C1E22);
  static const _headerBottom = Color(0xFF0A0B0D);
  static const _badgeRed = Color(0xFFE6314A);
  static const _logoAsset = 'assets/images/pngs/glory_image.png';
  static const _bottomShapeAsset =
      'assets/images/svgs/home_header_bottom_shape.svg';

  static const _designWidth = 390.0;
  static const _bottomShapeHeight = 33.9661;
  static const _logoWidth = 101.0;
  static const _logoHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomShapeHeight =
        MediaQuery.sizeOf(context).width / _designWidth * _bottomShapeHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.15, -1),
              end: Alignment(0.55, 1.1),
              colors: [_headerTop, _headerBottom],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -60,
                top: -60,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _goldAccent.withValues(alpha: 0.35),
                          _goldAccent.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.65],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -50,
                bottom: 21,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _goldAccent.withValues(alpha: 0.22),
                          _goldAccent.withValues(alpha: 0),
                        ],
                        stops: const [0, 0.65],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: topInset),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppEntrance(
                              delay: const Duration(milliseconds: 160),
                              offset: const Offset(-0.08, 0),
                              child: _NotificationButton(
                                count: notificationCount,
                                onTap: onNotificationTap,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppEntrance(
                                delay: const Duration(milliseconds: 80),
                                offset: const Offset(0.06, 0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            if (greeting != null)
                                              Text(
                                                greeting!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.right,
                                                style: context.footnoteRegular
                                                    .copyWith(
                                                  color: AppColors.neutral100,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  height: 1.2,
                                                ),
                                              ),
                                            if (greeting != null)
                                              const SizedBox(height: 6),
                                            Text(
                                              username,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.right,
                                              style:
                                                  context.contentBold.copyWith(
                                                color: AppColors.neutral100,
                                                fontSize: 16,
                                                height: 1.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      _Avatar(
                                        assetPath: avatarAsset,
                                        networkUrl: avatarUrl,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
                        child: AppEntrance(
                          delay: const Duration(milliseconds: 40),
                          offset: const Offset(-0.04, 0),
                          duration: const Duration(milliseconds: 560),
                          child: SizedBox(
                            width: _logoWidth,
                            height: _logoHeight,
                            child: Image.asset(
                              _logoAsset,
                              fit: BoxFit.contain,
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: bottomShapeHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: _headerBottom),
              SvgPicture.asset(
                _bottomShapeAsset,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _NotificationButton extends StatefulWidget {
  const _NotificationButton({this.count = 0, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

final class _NotificationButtonState extends State<_NotificationButton>
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
  void didUpdateWidget(covariant _NotificationButton oldWidget) {
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppHomeHeader._goldAccent.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppHomeHeader._goldAccent),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Iconsax.notification,
              size: 18,
              color: AppColors.white,
            ),
          ),
          if (widget.count > 0)
            Positioned(
              top: -3,
              right: -3,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.08).animate(
                  CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                ),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppHomeHeader._badgeRed,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF14151A),
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.count > 99 ? '99+' : '${widget.count}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
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

final class _Avatar extends StatelessWidget {
  const _Avatar({this.assetPath, this.networkUrl});

  final String? assetPath;
  final String? networkUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppHomeHeader._headerBottom,
        shape: BoxShape.circle,
        border: Border.all(color: AppHomeHeader._goldAccent, width: 2),
      ),
      child: ClipOval(child: _image()),
    );
  }

  Widget _image() {
    if (networkUrl != null && networkUrl!.isNotEmpty) {
      return Image.network(
        networkUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() => ColoredBox(
        color: AppHomeHeader._headerTop,
        child: const Center(
          child: Icon(
            Iconsax.user,
            color: AppColors.white,
            size: 22,
          ),
        ),
      );
}
