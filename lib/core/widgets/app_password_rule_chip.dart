import 'package:flutter/material.dart';
import 'package:glory_gym/core/constants/app_spacing.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

enum PasswordRuleState { pending, valid, invalid }

final class AppPasswordRuleChip extends StatelessWidget {
  const AppPasswordRuleChip({
    super.key,
    required this.label,
    required this.state,
  });

  final String label;
  final PasswordRuleState state;

  Color get _backgroundColor => switch (state) {
    PasswordRuleState.valid => AppColors.green10,
    PasswordRuleState.invalid => AppColors.red10,
    PasswordRuleState.pending => AppColors.neutral200,
  };

  Color get _textColor => switch (state) {
    PasswordRuleState.valid => AppColors.green200,
    PasswordRuleState.invalid => AppColors.red,
    PasswordRuleState.pending => AppColors.neutral500,
  };

  Color get _borderColor => switch (state) {
    PasswordRuleState.valid => AppColors.green200.withValues(alpha: 0.5),
    PasswordRuleState.invalid => AppColors.red200.withValues(alpha: 0.5),
    PasswordRuleState.pending => AppColors.neutral500.withValues(alpha: 0.5),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Text(
        label,
        style: Styles.footnoteSemiboldBold(context).copyWith(color: _textColor),
      ),
    );
  }
}

final class AppPasswordRulesRow extends StatelessWidget {
  const AppPasswordRulesRow({
    super.key,
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasUpperOrLower,
    required this.passwordsMatch,
    this.showMatch = true,
  });

  final bool hasMinLength;
  final bool hasNumber;
  final bool hasUpperOrLower;
  final bool passwordsMatch;
  final bool showMatch;

  PasswordRuleState _state(bool value) =>
      value ? PasswordRuleState.valid : PasswordRuleState.invalid;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        AppPasswordRuleChip(
          label: '8 حروف علي الاقل',
          state: _state(hasMinLength),
        ),
        AppPasswordRuleChip(
          label: 'تحتوي على رقم واحد على الأقل',
          state: _state(hasNumber),
        ),
        AppPasswordRuleChip(
          label: 'تحتوي على حرف كبير أو صغير',
          state: _state(hasUpperOrLower),
        ),
        if (showMatch)
          AppPasswordRuleChip(
            label: 'كلمتي المرور متطابقتين',
            state: _state(passwordsMatch),
          ),
      ],
    );
  }
}
