import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';

enum SandyAttachSource { gallery, camera, pdf }

final class SandyAttachSheet extends StatelessWidget {
  const SandyAttachSheet({super.key});

  static Future<SandyAttachSource?> show(BuildContext context) {
    return showModalBottomSheet<SandyAttachSource>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const SandyAttachSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.sandyUploadMedicalFile,
              style: context.highlightBold.copyWith(color: AppColors.neutral900),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.sandyUploadMedicalFileSubtitle,
              style: context.captionRegular.copyWith(color: AppColors.neutral600),
            ),
            const SizedBox(height: 16),
            _AttachOption(
              icon: Iconsax.gallery,
              label: context.l10n.sandyUploadFromGallery,
              onTap: () => Navigator.of(context).pop(SandyAttachSource.gallery),
            ),
            _AttachOption(
              icon: Iconsax.camera,
              label: context.l10n.sandyUploadFromCamera,
              onTap: () => Navigator.of(context).pop(SandyAttachSource.camera),
            ),
            _AttachOption(
              icon: Iconsax.document_text,
              label: context.l10n.sandyUploadPdf,
              onTap: () => Navigator.of(context).pop(SandyAttachSource.pdf),
            ),
          ],
        ),
      ),
    );
  }
}

final class _AttachOption extends StatelessWidget {
  const _AttachOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.primary100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary800, size: 20),
      ),
      title: Text(
        label,
        style: context.contentSemibold.copyWith(color: AppColors.neutral900),
      ),
    );
  }
}
