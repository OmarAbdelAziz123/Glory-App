import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class LoginTermsRow extends StatefulWidget {
  const LoginTermsRow({
    super.key,
    required this.accepted,
    required this.onToggle,
    this.onPrivacyTap,
    this.onTermsTap,
  });

  final bool accepted;
  final VoidCallback onToggle;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onTermsTap;

  @override
  State<LoginTermsRow> createState() => _LoginTermsRowState();
}

final class _LoginTermsRowState extends State<LoginTermsRow> {
  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _termsRecognizer;

  @override
  void initState() {
    super.initState();
    _privacyRecognizer = TapGestureRecognizer()..onTap = widget.onPrivacyTap;
    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onTermsTap;
  }

  @override
  void didUpdateWidget(LoginTermsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _privacyRecognizer.onTap = widget.onPrivacyTap;
    _termsRecognizer.onTap = widget.onTermsTap;
  }

  @override
  void dispose() {
    _privacyRecognizer.dispose();
    _termsRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TermsCheckbox(accepted: widget.accepted, onToggle: widget.onToggle),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: context.footnoteEmphasis.copyWith(
                color: AppColors.neutral400,
              ),
              children: [
                TextSpan(text: context.l10n.agreeToPrefix),
                TextSpan(
                  text: context.l10n.privacyPolicy,
                  style: const TextStyle(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                  recognizer: _privacyRecognizer,
                ),
                TextSpan(text: context.l10n.conjunctionAnd),
                TextSpan(
                  text: context.l10n.termsOfService,
                  style: const TextStyle(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                  recognizer: _termsRecognizer,
                ),
              ],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

final class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.accepted, required this.onToggle});

  final bool accepted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: accepted ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: accepted ? AppColors.primary : AppColors.neutral400,
            width: 1,
          ),
        ),
        child: accepted
            ? const Icon(Icons.check, color: AppColors.white, size: 14)
            : null,
      ),
    );
  }
}
