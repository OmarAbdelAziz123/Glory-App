import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_nav_back_icon.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class QuestionnaireHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const QuestionnaireHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.title,
    this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final String? title;
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
            title ?? context.l10n.subscriptionQuestionnaire,
            textAlign: TextAlign.center,
            style: context.highlightBold.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.questionnaireStepProgress(
              '${currentStep + 1}',
              '$totalSteps',
            ),
            textAlign: TextAlign.center,
            style: context.captionRegular.copyWith(color: AppColors.white),
          ),
        ],
      ),
      leading: onBack == null
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(start: 18),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const AppNavBackIconLight(
                      width: 18,
                      height: 18,
                      fit: BoxFit.scaleDown,
                    ),
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
                  ColoredBox(
                    color: AppColors.white.withValues(alpha: 0.35),
                  ),
                  FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: const ColoredBox(color: AppColors.primary800),
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
