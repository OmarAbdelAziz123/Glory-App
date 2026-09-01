import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/l10n_extension.dart';
import '../widgets/app_permission_dialog.dart';

abstract final class CameraPermissionUtils {
  static Future<bool> ensureGranted(BuildContext context) async {
    var status = await Permission.camera.status;

    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (!context.mounted) return false;
      await _showSettingsDialog(context);
      return false;
    }

    if (status.isDenied && context.mounted) {
      final shouldRequest = await _showRationaleDialog(context);
      if (shouldRequest != true || !context.mounted) return false;
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

  static Future<bool?> _showRationaleDialog(BuildContext context) {
    return AppPermissionDialog.show(
      context,
      title: context.l10n.cameraPermissionRequired,
      message: context.l10n.cameraPermissionRationale,
      primaryLabel: context.l10n.allowCameraAccess,
      onPrimaryPressed: () {},
      secondaryLabel: context.l10n.cancel,
    );
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
      onPrimaryPressed: () {},
      secondaryLabel: context.l10n.cancel,
    );
  }
}
