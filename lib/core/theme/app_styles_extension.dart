import 'package:flutter/material.dart';

import 'app_styles.dart';

extension StylesX on BuildContext {
  // ── Shorthand aliases ────────────────────────────────
  TextStyle get h1 => Styles.heading1(this);
  TextStyle get h2 => Styles.heading2(this);
  TextStyle get h3 => Styles.heading3(this);
  TextStyle get h4 => Styles.heading4(this);
  TextStyle get h5 => Styles.heading5(this);
  TextStyle get h6 => Styles.heading6(this);
  TextStyle get body => Styles.contentRegular(this);
  TextStyle get baseRegular => Styles.baseRegular(this);

  // ── Headings ─────────────────────────────────────────
  TextStyle get heading1 => Styles.heading1(this);
  TextStyle get heading2 => Styles.heading2(this);
  TextStyle get heading3 => Styles.heading3(this);
  TextStyle get heading4 => Styles.heading4(this);
  TextStyle get heading5 => Styles.heading5(this);
  TextStyle get heading6 => Styles.heading6(this);

  // ── Hero 28px ────────────────────────────────────────
  TextStyle get heroBold => Styles.heroBold(this);
  TextStyle get heroAccent => Styles.heroAccent(this);
  TextStyle get heroEmphasis => Styles.heroEmphasis(this);
  TextStyle get heroStandard => Styles.heroStandard(this);

  // ── Feature 24px ────────────────────────────────────
  TextStyle get featureBold => Styles.featureBold(this);
  TextStyle get featureAccent => Styles.featureAccent(this);
  TextStyle get featureEmphasis => Styles.featureEmphasis(this);
  TextStyle get featureStandard => Styles.featureStandard(this);

  // ── Feature Semibold 20px ────────────────────────────
  TextStyle get featureSemiboldBold => Styles.featureSemiboldBold(this);

  // ── Highlight 18px ───────────────────────────────────
  TextStyle get highlightBold => Styles.highlightBold(this);
  TextStyle get highlightAccent => Styles.highlightAccent(this);
  TextStyle get highlightEmphasis => Styles.highlightEmphasis(this);
  TextStyle get highlightStandard => Styles.highlightStandard(this);

  // ── Content 16px ─────────────────────────────────────
  TextStyle get contentBold => Styles.contentBold(this);
  TextStyle get contentAccent => Styles.contentAccent(this);
  TextStyle get contentEmphasis => Styles.contentEmphasis(this);
  TextStyle get contentSemibold => Styles.contentSemibold(this);
  TextStyle get contentRegular => Styles.contentRegular(this);

  // ── Subtitle 14px ────────────────────────────────────
  TextStyle get subtitleMedium => Styles.subtitleMedium(this);

  // ── Caption 14px ─────────────────────────────────────
  TextStyle get captionBold => Styles.captionBold(this);
  TextStyle get captionAccent => Styles.captionAccent(this);
  TextStyle get captionEmphasis => Styles.captionEmphasis(this);
  TextStyle get captionRegular => Styles.captionRegular(this);
  TextStyle get captionLight => Styles.captionLight(this);

  // ── Footnote 12px ────────────────────────────────────
  TextStyle get footnoteBold => Styles.footnoteBold(this);
  TextStyle get footnoteSemiboldBold => Styles.footnoteSemiboldBold(this);
  TextStyle get footnoteEmphasis => Styles.footnoteEmphasis(this);
  TextStyle get footnoteRegular => Styles.footnoteRegular(this);
  TextStyle get footnoteLight => Styles.footnoteLight(this);
}
