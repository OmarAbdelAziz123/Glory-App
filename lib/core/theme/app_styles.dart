import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class Styles {
  // ── Private factory ───────────────────────────────────
  static TextStyle _base(
    BuildContext context, {
    required double fontSize,
    required FontWeight fontWeight,
    Color color = AppColors.neutral1000,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  // ── Headings ──────────────────────────────────────────
  static TextStyle heading1(BuildContext context) =>
      _base(context, fontSize: 32, fontWeight: FontWeight.w700);

  static TextStyle heading2(BuildContext context) =>
      _base(context, fontSize: 28, fontWeight: FontWeight.w700);

  static TextStyle heading3(BuildContext context) =>
      _base(context, fontSize: 24, fontWeight: FontWeight.w700);

  static TextStyle heading4(BuildContext context) =>
      _base(context, fontSize: 20, fontWeight: FontWeight.w700);

  static TextStyle heading5(BuildContext context) =>
      _base(context, fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle heading6(BuildContext context) =>
      _base(context, fontSize: 16, fontWeight: FontWeight.w600);

  // ── Hero 28px ─────────────────────────────────────────
  static TextStyle heroBold(BuildContext context) =>
      _base(context, fontSize: 28, fontWeight: FontWeight.w700);

  static TextStyle heroAccent(BuildContext context) => _base(
    context,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle heroEmphasis(BuildContext context) => _base(
    context,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  static TextStyle heroStandard(BuildContext context) =>
      _base(context, fontSize: 28, fontWeight: FontWeight.w400);

  // ── Feature 24px ─────────────────────────────────────
  static TextStyle featureBold(BuildContext context) =>
      _base(context, fontSize: 24, fontWeight: FontWeight.w700);

  static TextStyle featureAccent(BuildContext context) => _base(
    context,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle featureEmphasis(BuildContext context) => _base(
    context,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  static TextStyle featureStandard(BuildContext context) =>
      _base(context, fontSize: 24, fontWeight: FontWeight.w400);

  // ── Feature Semibold 20px ─────────────────────────────
  static TextStyle featureSemiboldBold(BuildContext context) =>
      _base(context, fontSize: 20, fontWeight: FontWeight.w600);

  // ── Highlight 18px ───────────────────────────────────
  static TextStyle highlightBold(BuildContext context) =>
      _base(context, fontSize: 18, fontWeight: FontWeight.w700);

  static TextStyle highlightAccent(BuildContext context) => _base(
    context,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle highlightEmphasis(BuildContext context) =>
      _base(context, fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle highlightStandard(BuildContext context) =>
      _base(context, fontSize: 18, fontWeight: FontWeight.w400);

  // ── Content 16px ─────────────────────────────────────
  static TextStyle contentBold(BuildContext context) =>
      _base(context, fontSize: 16, fontWeight: FontWeight.w700);

  static TextStyle contentAccent(BuildContext context) => _base(
    context,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle contentEmphasis(BuildContext context) => _base(
    context,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  static TextStyle contentSemibold(BuildContext context) =>
      _base(context, fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle contentRegular(BuildContext context) =>
      _base(context, fontSize: 14, fontWeight: FontWeight.w400);

  // ── Subtitle 14px ────────────────────────────────────
  static TextStyle subtitleMedium(BuildContext context) =>
      _base(context, fontSize: 14, fontWeight: FontWeight.w500);

  // ── Caption 14px ─────────────────────────────────────
  static TextStyle captionBold(BuildContext context) =>
      _base(context, fontSize: 14, fontWeight: FontWeight.w700);

  static TextStyle captionAccent(BuildContext context) => _base(
    context,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle captionEmphasis(BuildContext context) => _base(
    context,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  static TextStyle captionRegular(BuildContext context) =>
      _base(context, fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle captionLight(BuildContext context) =>
      _base(context, fontSize: 14, fontWeight: FontWeight.w300);

  // ── Footnote 12px ────────────────────────────────────
  static TextStyle footnoteBold(BuildContext context) =>
      _base(context, fontSize: 12, fontWeight: FontWeight.w700);

  static TextStyle footnoteSemiboldBold(BuildContext context) =>
      _base(context, fontSize: 12, fontWeight: FontWeight.w600);

  static TextStyle footnoteEmphasis(BuildContext context) =>
      _base(context, fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle footnoteRegular(BuildContext context) =>
      _base(context, fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle footnoteLight(BuildContext context) =>
      _base(context, fontSize: 12, fontWeight: FontWeight.w300);

  // ── Base ─────────────────────────────────────────────
  static TextStyle baseRegular(BuildContext context) =>
      _base(context, fontSize: 14, fontWeight: FontWeight.w400);
}
