import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_member_avatar.dart';
import '../../../../core/widgets/app_nav_back_icon.dart';

final class CoachChatHeader extends StatelessWidget implements PreferredSizeWidget {
  const CoachChatHeader({
    super.key,
    required this.coachName,
    this.subtitle,
    this.avatarUrl,
    this.onBack,
  });

  final String coachName;
  final String? subtitle;
  final String? avatarUrl;
  final VoidCallback? onBack;

  static const _height = 72.0;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary600, AppColors.primary800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: SizedBox(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _BackButton(onBack: onBack),
                const SizedBox(width: 8),
                _CoachAvatar(avatarUrl: avatarUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coachName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.highlightBold.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: AppColors.green200.withValues(alpha: 0.95),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.green200.withValues(alpha: 0.45),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.footnoteRegular.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.82),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Iconsax.messages_25,
                  color: AppColors.white.withValues(alpha: 0.9),
                  size: 22,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _BackButton extends StatelessWidget {
  const _BackButton({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onBack ?? () => Navigator.of(context).maybePop(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: AppNavBackIconLight(width: 18, height: 18),
          ),
        ),
      ),
    );
  }
}

final class _CoachAvatar extends StatelessWidget {
  const _CoachAvatar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.55),
          width: 1.5,
        ),
      ),
      child: AppMemberAvatar(avatarUrl: avatarUrl, size: 40),
    );
  }
}
