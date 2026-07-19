import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glory_gym/core/extensions/num_spacing_extension.dart';
import 'package:glory_gym/core/theme/app_styles_extension.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'app_button.dart';

final class AppSuccessSheet extends StatelessWidget {
  const AppSuccessSheet({
    super.key,
    required this.title,
    required this.headline,
    required this.highlightWord,
    required this.description,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.badgeAsset,
  });

  final String title;
  final String headline;
  final String highlightWord;
  final String description;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final String? badgeAsset;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String headline,
    required String highlightWord,
    required String description,
    required String buttonLabel,
    required VoidCallback onButtonPressed,
    String? badgeAsset,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AppSuccessSheet(
        title: title,
        headline: headline,
        highlightWord: highlightWord,
        description: description,
        buttonLabel: buttonLabel,
        onButtonPressed: onButtonPressed,
        badgeAsset: badgeAsset,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: context.highlightBold),
          12.vertical,
          Divider(color: AppColors.neutral400, thickness: 0.5),
          24.vertical,
          _BadgeIcon(assetPath: badgeAsset),
          24.vertical,
          _HeadlineText(headline: headline, highlightWord: highlightWord),
          12.vertical,
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.highlightStandard.copyWith(
              color: AppColors.neutral400,
            ),
          ),
          24.vertical,
          AppButton(label: buttonLabel, onPressed: onButtonPressed),
        ],
      ),
    );
  }
}

final class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({this.assetPath});

  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      if (assetPath!.endsWith('.svg')) {
        return SvgPicture.asset(assetPath!, width: 120, height: 120);
      }
      return Image.asset(assetPath!, width: 120, height: 120);
    }
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.primary10,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(
        Icons.emoji_events_rounded,
        color: AppColors.primary,
        size: 64,
      ),
    );
  }
}

final class _HeadlineText extends StatelessWidget {
  const _HeadlineText({required this.headline, required this.highlightWord});

  final String headline;
  final String highlightWord;

  @override
  Widget build(BuildContext context) {
    final fullText = headline;
    final highlightIndex = fullText.indexOf(highlightWord);

    if (highlightIndex == -1) {
      return Text(fullText, style: Styles.highlightBold(context));
    }

    final before = fullText.substring(0, highlightIndex);
    final after = fullText.substring(highlightIndex + highlightWord.length);

    return Text.rich(
      TextSpan(
        style: context.highlightBold,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: highlightWord,
            style: context.highlightBold.copyWith(color: AppColors.green200),
          ),
          TextSpan(text: after),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
