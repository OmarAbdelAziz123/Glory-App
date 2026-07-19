import 'package:flutter/material.dart';

import '../extensions/num_spacing_extension.dart';
import 'app_social_button.dart';

/// Google + Apple social buttons (same layout as login / register).
final class AppSocialLoginRow extends StatelessWidget {
  const AppSocialLoginRow({
    super.key,
    required this.onApple,
    required this.onGoogle,
  });

  final VoidCallback onApple;
  final VoidCallback onGoogle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSocialButton(
            iconAsset: 'assets/images/svgs/google_icon.svg',
            onPressed: onGoogle,
          ),
        ),
        16.horizontal,
        Expanded(
          child: AppSocialButton(
            iconAsset: 'assets/images/svgs/apple_icon.svg',
            onPressed: onApple,
          ),
        ),
      ],
    );
  }
}
