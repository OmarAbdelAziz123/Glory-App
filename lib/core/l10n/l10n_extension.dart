import 'package:flutter/material.dart';
import 'package:glory_gym/l10n/app_localizations.dart';

export 'package:glory_gym/l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
