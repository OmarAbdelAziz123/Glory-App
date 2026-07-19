import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_colors.dart';
import 'app_text_field.dart';

final class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.hint,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.errorMessage,
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final String? errorMessage;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

final class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      focusNode: widget.focusNode,
      hint: widget.hint,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      obscureText: _obscured,
      errorMessage: widget.errorMessage,
      keyboardType: TextInputType.visiblePassword,
      // suffixIcon → trailing edge = LEFT side in RTL (matches design)
      suffixIcon: GestureDetector(
        onTap: () => setState(() => _obscured = !_obscured),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            _obscured ? Iconsax.eye_slash : Iconsax.eye,
            color: AppColors.neutral1000,
            size: 20,
          ),
        ),
      ),
    );
  }
}
