import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glory_gym/core/extensions/num_spacing_extension.dart';
import 'package:glory_gym/core/theme/app_styles_extension.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_colors.dart';

final class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.initialValue,
    this.errorText,
    this.errorMessage,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final int maxLines;
  final int? minLines;
  final bool obscureText;
  final String? initialValue;
  final String? errorText;
  final String? errorMessage;
  final List<TextInputFormatter>? inputFormatters;

  static OutlineInputBorder _border(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorMessage != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: context.highlightEmphasis),
        8.vertical,
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          style: context.contentRegular,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.contentRegular.copyWith(
              color: AppColors.neutral400,
            ),
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: !enabled,
            fillColor: AppColors.neutral100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: hasError
                ? _border(AppColors.red, 1)
                : _border(AppColors.neutral400, 1),
            focusedBorder: hasError
                ? _border(AppColors.red, 1.5)
                : _border(AppColors.primary500, 1.5),
            errorBorder: _border(AppColors.red, 1),
            focusedErrorBorder: _border(AppColors.red, 1.5),
            disabledBorder: _border(AppColors.neutral400, 1),
          ),
        ),
        if (hasError) ...[8.vertical, _InlineError(message: errorMessage!)],
      ],
    );
  }
}

final class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Iconsax.close_circle, color: AppColors.red, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            message,
            style: context.footnoteEmphasis.copyWith(color: AppColors.red),
          ),
        ),
      ],
    );
  }
}
