import 'package:flutter/widgets.dart';
import 'package:glory_gym/l10n/app_localizations.dart';

abstract final class AppValidators {
  // ── Required ──────────────────────────────────────────────────────────────
  static String? required(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return l10n.fieldRequired;
    return null;
  }

  // ── Email ─────────────────────────────────────────────────────────────────
  static String? email(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final valid = RegExp(r'^[\w.-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!valid.hasMatch(value.trim())) return l10n.invalidEmail;
    return null;
  }

  // ── Phone ─────────────────────────────────────────────────────────────────
  static String? phone(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8 || digits.length > 15) {
      return l10n.invalidPhone;
    }
    return null;
  }

  // ── Email or Phone ────────────────────────────────────────────────────────
  static String? emailOrPhone(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterEmailOrPhone;
    }
    if (value.contains('@')) return email(l10n, value);
    return phone(l10n, value);
  }

  // ── Password ──────────────────────────────────────────────────────────────
  static String? password(AppLocalizations l10n, String? value) {
    if (value == null || value.isEmpty) return l10n.pleaseEnterPassword;
    if (value.length < 8) return l10n.passwordTooShort;
    return null;
  }

  // ── New password (strong) ─────────────────────────────────────────────────
  static String? newPassword(AppLocalizations l10n, String? value) {
    if (value == null || value.isEmpty) return l10n.pleaseEnterPassword;
    if (value.length < 8) return l10n.passwordTooShort;
    if (!value.contains(RegExp(r'[0-9]'))) {
      return l10n.mustContainDigit;
    }
    if (!value.contains(RegExp(r'[a-zA-Z]'))) {
      return l10n.mustContainLetter;
    }
    return null;
  }

  // ── Confirm password ──────────────────────────────────────────────────────
  static FormFieldValidator<String> confirmPassword(
    AppLocalizations l10n,
    String original,
  ) {
    return (value) {
      if (value == null || value.isEmpty) return l10n.pleaseConfirmPassword;
      if (value != original) return l10n.passwordsNotMatch;
      return null;
    };
  }

  // ── Min length ────────────────────────────────────────────────────────────
  static FormFieldValidator<String> minLength(AppLocalizations l10n, int min) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < min) return l10n.minCharsValidation('$min');
      return null;
    };
  }

  // ── Max length ────────────────────────────────────────────────────────────
  static FormFieldValidator<String> maxLength(AppLocalizations l10n, int max) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length > max) return l10n.maxCharsValidation('$max');
      return null;
    };
  }

  // ── Compose multiple validators ───────────────────────────────────────────
  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
