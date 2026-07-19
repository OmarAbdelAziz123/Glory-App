import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

final class AppPageHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: Styles.highlightBold(context).copyWith(
          color: AppColors.white,
        ),
      ),
      centerTitle: true,
      leading: null,
      actions: [
        const SizedBox(width: 4),
        _BackButton(onBack: onBack ?? () => Navigator.of(context).pop()),
        const SizedBox(width: 12),
        if (actions != null) ...actions!,
      ],
    );
  }
}

final class _BackButton extends StatelessWidget {
  const _BackButton({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconTheme(
          data: const IconThemeData(color: AppColors.primary, size: 18),
          child: const BackButtonIcon(),
        ),
      ),
    );
  }
}
