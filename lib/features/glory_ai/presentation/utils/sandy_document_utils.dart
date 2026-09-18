import 'package:glory_gym/l10n/app_localizations.dart';

import '../../domain/entities/sandy_entities.dart';

abstract final class SandyDocumentUtils {
  static String kindLabel(AppLocalizations l10n, SandyDocumentKind kind) {
    return switch (kind) {
      SandyDocumentKind.labResult => l10n.sandyDocKindLab,
      SandyDocumentKind.imaging => l10n.sandyDocKindImaging,
      SandyDocumentKind.report => l10n.sandyDocKindReport,
      SandyDocumentKind.prescription => l10n.sandyDocKindPrescription,
      SandyDocumentKind.other => l10n.sandyDocKindOther,
    };
  }
}
