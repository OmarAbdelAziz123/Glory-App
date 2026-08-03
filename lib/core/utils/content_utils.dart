import 'package:flutter/material.dart';

abstract final class ContentUtils {
  static const defaultImageAsset = 'assets/images/pngs/classes_image.png';

  static bool isArabic(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return code == 'ar';
  }
}
