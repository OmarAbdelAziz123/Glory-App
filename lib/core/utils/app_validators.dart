import 'package:flutter/widgets.dart';

abstract final class AppValidators {
  // ── Required ──────────────────────────────────────────────────────────────
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
    return null;
  }

  // ── Email ─────────────────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final valid = RegExp(r'^[\w.-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!valid.hasMatch(value.trim())) return 'يرجى إدخال بريد إلكتروني صحيح';
    return null;
  }

  // ── Phone ─────────────────────────────────────────────────────────────────
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8 || digits.length > 15) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }
    return null;
  }

  // ── Email or Phone ────────────────────────────────────────────────────────
  static String? emailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
    }
    if (value.contains('@')) return email(value);
    return phone(value);
  }

  // ── Password ──────────────────────────────────────────────────────────────
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
    if (value.length < 8) return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    return null;
  }

  // ── New password (strong) ─────────────────────────────────────────────────
  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
    if (value.length < 8) return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'يجب أن تحتوي على رقم واحد على الأقل';
    }
    if (!value.contains(RegExp(r'[a-zA-Z]'))) {
      return 'يجب أن تحتوي على حرف كبير أو صغير';
    }
    return null;
  }

  // ── Confirm password ──────────────────────────────────────────────────────
  static FormFieldValidator<String> confirmPassword(String original) {
    return (value) {
      if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
      if (value != original) return 'كلمتا المرور غير متطابقتين';
      return null;
    };
  }

  // ── Min length ────────────────────────────────────────────────────────────
  static FormFieldValidator<String> minLength(int min) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < min) return 'يجب ألا يقل عن $min أحرف';
      return null;
    };
  }

  // ── Max length ────────────────────────────────────────────────────────────
  static FormFieldValidator<String> maxLength(int max) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length > max) return 'يجب ألا يزيد عن $max حرفاً';
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
