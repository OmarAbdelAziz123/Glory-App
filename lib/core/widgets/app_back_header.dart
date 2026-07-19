import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'app_back_button.dart';

final class AppBackHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppBackHeader({
    super.key,
    this.onBack,
    this.title,
    this.actions,
  });

  final VoidCallback? onBack;
  final String? title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.neutral100,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 18),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: AppBackButton(onTap: onBack),
        ),
      ),
      title: title != null
          ? Text(
              title!,
              style: Styles.highlightBold(context)
                  .copyWith(color: AppColors.neutral1000),
            )
          : null,
      centerTitle: true,
      actions: actions,
    );
  }
}
