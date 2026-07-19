import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glory_gym/core/extensions/num_spacing_extension.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/arab_countries.dart';
import '../models/country_code.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles_extension.dart';

final class AppPhoneField extends StatefulWidget {
  const AppPhoneField({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.hint,
    this.textInputAction,
    this.onChanged,
    this.errorMessage,
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hint;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final String? errorMessage;

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

final class _AppPhoneFieldState extends State<AppPhoneField> {
  CountryCode _selected = arabCountries.first;

  void _openPicker() {
    showModalBottomSheet<CountryCode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CountryPickerSheet(selected: _selected),
    ).then((picked) {
      if (picked != null) setState(() => _selected = picked);
    });
  }

  static OutlineInputBorder _border(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorMessage != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: context.highlightEmphasis),
        8.vertical,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CountryCodeBox(country: _selected, onTap: _openPicker),
            8.horizontal,
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: widget.textInputAction,
                onChanged: widget.onChanged,
                style: context.contentRegular,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: context.contentRegular.copyWith(
                    color: AppColors.neutral400,
                  ),
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
                ),
              ),
            ),
          ],
        ),
        if (hasError) ...[
          8.vertical,
          _PhoneInlineError(message: widget.errorMessage!),
        ],
      ],
    );
  }
}

// ─── Country picker sheet ────────────────────────────────────────────────────

final class _CountryPickerSheet extends StatelessWidget {
  const _CountryPickerSheet({required this.selected});

  final CountryCode selected;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, scrollCtrl) {
        return Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text('اختر الدولة', style: context.highlightBold),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.neutral200),
            // List
            Expanded(
              child: ListView.separated(
                controller: scrollCtrl,
                itemCount: arabCountries.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.neutral100),
                itemBuilder: (_, index) {
                  final country = arabCountries[index];
                  final isSelected = country.dialCode == selected.dialCode;
                  return ListTile(
                    onTap: () => Navigator.of(context).pop(country),
                    leading: CountryFlag.fromCountryCode(
                      country.countryCode,
                      width: 32,
                      height: 22,
                      shape: const RoundedRectangle(4),
                    ),
                    title: Text(
                      country.name,
                      style: context.contentRegular.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.neutral1000,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      country.dialCode,
                      style: context.captionRegular.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.neutral500,
                      ),
                    ),
                    selected: isSelected,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Private sub-widgets ─────────────────────────────────────────────────────

final class _CountryCodeBox extends StatelessWidget {
  const _CountryCodeBox({required this.country, required this.onTap});

  final CountryCode country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.neutral400, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CountryFlag.fromCountryCode(
              country.countryCode,
              width: 28,
              height: 20,
              shape: const RoundedRectangle(3),
            ),
            4.horizontal,
            Text(country.dialCode, style: context.contentRegular),
            4.horizontal,
            const Icon(
              Iconsax.arrow_down_1,
              size: 14,
              color: AppColors.neutral1000,
            ),
          ],
        ),
      ),
    );
  }
}

final class _PhoneInlineError extends StatelessWidget {
  const _PhoneInlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Iconsax.close_circle, color: AppColors.red, size: 16),
        4.horizontal,
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
