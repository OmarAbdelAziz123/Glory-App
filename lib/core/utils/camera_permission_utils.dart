import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/l10n_extension.dart';
import '../widgets/app_permission_dialog.dart';

abstract final class CameraPermissionUtils {
  /// iOS/Android system camera prompt first; Settings only after denial.
  static Future<bool> ensureGranted(BuildContext context) async {
    var status = await Permission.camera.status;

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isRestricted) {
      if (context.mounted) {
        await _showRestrictedDialog(context);
      }
      return false;
    }

    status = await Permission.camera.request();
    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (!context.mounted) return false;

    if (status.isPermanentlyDenied) {
      await _showSettingsDialog(context);
    } else {
      await _showDeniedDialog(context);
    }

    return false;
  }

  static Future<void> _showSettingsDialog(BuildContext context) {
    return AppPermissionDialog.show(
      context,
      title: context.l10n.cameraPermissionRequired,
      message: context.l10n.cameraPermissionSettingsMessage,
      primaryLabel: context.l10n.openSettings,
      onPrimaryPressed: openAppSettings,
      secondaryLabel: context.l10n.cancel,
    );
  }

  static Future<void> _showDeniedDialog(BuildContext context) {
    return AppPermissionDialog.show(
      context,
      title: context.l10n.cameraPermissionRequired,
      message: context.l10n.cameraPermissionDeniedMessage,
      primaryLabel: context.l10n.retry,
      onPrimaryPressed: () async {
        if (!context.mounted) return;
        await ensureGranted(context);
      },
      secondaryLabel: context.l10n.cancel,
    );
  }

  static Future<void> _showRestrictedDialog(BuildContext context) {
    return AppPermissionDialog.show(
      context,
      title: context.l10n.cameraPermissionRequired,
      message: context.l10n.cameraPermissionDeniedMessage,
      primaryLabel: context.l10n.cancel,
      onPrimaryPressed: () {},
    );
  }
}
