import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';

final class QuestionnaireHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const QuestionnaireHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  static const _toolbarHeight = 72.0;
  static const _bottomHeight = 16.0;

  @override
  Size get preferredSize =>
      const Size.fromHeight(_toolbarHeight + _bottomHeight);

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: _toolbarHeight,
      automaticallyImplyLeading: false,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'استبيان الاشتراك',
            textAlign: TextAlign.center,
            style: context.highlightBold.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'الخطوة ${currentStep + 1} من $totalSteps',
            textAlign: TextAlign.center,
            style: context.captionRegular.copyWith(color: AppColors.white),
          ),
        ],
      ),
      leading: Padding(
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
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_bottomHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: AppColors.neutral10),
                  FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: const ColoredBox(color: AppColors.neutral100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
