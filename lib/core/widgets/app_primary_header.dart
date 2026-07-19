import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';

final class AppPrimaryHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const AppPrimaryHeader({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.backgroundColor = AppColors.primary,
    this.centerTitle = true,
    this.showBack = true,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color backgroundColor;
  final bool centerTitle;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: centerTitle ? null : 64,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      centerTitle: centerTitle,
      title: Text(
        title,
        style: context.highlightBold.copyWith(color: AppColors.white),
      ),
      leading: showBack
          ? Padding(
              padding: const EdgeInsetsDirectional.only(start: 18),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: GestureDetector(
                  onTap: onBack ?? () => Navigator.of(context).maybePop(),
                  child: SvgPicture.asset(
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? 'assets/images/svgs/back_icon_for_ios.svg'
                        : 'assets/images/svgs/back_icon_for_android.svg',
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
      actions: actions,
    );
  }
}
