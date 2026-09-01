import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/core.dart';

final class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

final class _QrScannerScreenState extends State<QrScannerScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  var _handled = false;

  static const _frameSize = 248.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value == null || value.isEmpty) continue;

      _handled = true;
      Navigator.of(context).pop(value);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.neutral1000,
      appBar: AppPrimaryHeader(
        title: context.l10n.scanQrCode,
        showBack: true,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(
                      controller: _controller,
                      onDetect: _onDetect,
                    ),
                    CustomPaint(
                      painter: _ScannerOverlayPainter(
                        frameSize: _frameSize,
                        borderRadius: 16,
                        borderColor: AppColors.primary,
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: _frameSize,
                        height: _frameSize,
                        child: Stack(
                          children: [
                            _CornerMark(alignment: Alignment.topRight),
                            _CornerMark(alignment: Alignment.topLeft),
                            _CornerMark(alignment: Alignment.bottomRight),
                            _CornerMark(alignment: Alignment.bottomLeft),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Iconsax.scan_barcode,
                      size: 22,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.pointCameraAtQr,
                      style: context.captionRegular.copyWith(
                        color: AppColors.neutral700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _CornerMark extends StatelessWidget {
  const _CornerMark({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(color: AppColors.primary, width: 4)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: alignment == Alignment.topLeft
                ? const Radius.circular(8)
                : Radius.zero,
            topRight: alignment == Alignment.topRight
                ? const Radius.circular(8)
                : Radius.zero,
            bottomLeft: alignment == Alignment.bottomLeft
                ? const Radius.circular(8)
                : Radius.zero,
            bottomRight: alignment == Alignment.bottomRight
                ? const Radius.circular(8)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}

final class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({
    required this.frameSize,
    required this.borderRadius,
    required this.borderColor,
  });

  final double frameSize;
  final double borderRadius;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = AppColors.neutral1000.withValues(alpha: 0.55);

    final holeRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frameSize,
      height: frameSize,
    );
    final holeRRect = RRect.fromRectAndRadius(
      holeRect,
      Radius.circular(borderRadius),
    );

    final backgroundPath = Path()..addRect(Offset.zero & size);
    final holePath = Path()..addRRect(holeRRect);
    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      holePath,
    );

    canvas.drawPath(overlayPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return oldDelegate.frameSize != frameSize ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderColor != borderColor;
  }
}
