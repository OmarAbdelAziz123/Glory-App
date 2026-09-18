import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_button.dart';

final class SandyDocumentSubmitResult {
  const SandyDocumentSubmitResult({this.note});

  final String? note;
}

final class SandyDocumentSubmitSheet extends StatefulWidget {
  const SandyDocumentSubmitSheet({super.key, required this.filePath});

  final String filePath;

  static Future<SandyDocumentSubmitResult?> show(
    BuildContext context, {
    required String filePath,
  }) {
    return showModalBottomSheet<SandyDocumentSubmitResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SandyDocumentSubmitSheet(filePath: filePath),
    );
  }

  @override
  State<SandyDocumentSubmitSheet> createState() =>
      _SandyDocumentSubmitSheetState();
}

final class _SandyDocumentSubmitSheetState
    extends State<SandyDocumentSubmitSheet> {
  final _noteController = TextEditingController();

  bool get _isPdf => widget.filePath.toLowerCase().endsWith('.pdf');

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: SingleChildScrollView(
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
              context.l10n.sandySendFileToSandy,
              style: context.highlightBold.copyWith(color: AppColors.neutral900),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 140,
                child: _isPdf
                    ? ColoredBox(
                        color: AppColors.primary100,
                        child: Center(
                          child: Text(
                            widget.filePath.split('/').last,
                            textAlign: TextAlign.center,
                            style: context.captionRegular.copyWith(
                              color: AppColors.primary800,
                            ),
                          ),
                        ),
                      )
                    : Image.file(File(widget.filePath), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.sandyMedicalConsent,
              style: context.captionRegular.copyWith(
                color: AppColors.neutral600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: context.l10n.sandyDocumentNoteHint,
                hintStyle: context.captionRegular.copyWith(
                  color: AppColors.neutral400,
                ),
                filled: true,
                fillColor: AppColors.neutral100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.neutral200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.neutral200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: context.l10n.sandySendToSandy,
              onPressed: () {
                final note = _noteController.text.trim();
                Navigator.of(context).pop(
                  SandyDocumentSubmitResult(
                    note: note.isEmpty ? null : note,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
