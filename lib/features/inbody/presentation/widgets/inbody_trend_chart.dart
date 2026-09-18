import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../domain/entities/inbody_entities.dart';
import '../utils/inbody_format.dart';

final class InbodyTrendChart extends StatelessWidget {
  const InbodyTrendChart({
    super.key,
    required this.points,
    required this.metricKey,
    required this.localeName,
  });

  final List<InbodyTrendPointEntity> points;
  final String metricKey;
  final String localeName;

  @override
  Widget build(BuildContext context) {
    final samples = [
      for (final point in points)
        if (point.valueOf(metricKey) != null)
          (at: point.recordedAt, value: point.valueOf(metricKey)!),
    ];

    if (samples.length < 2) {
      return SizedBox(
        height: 168,
        child: Center(
          child: Text(
            '—',
            style: context.captionRegular.copyWith(color: AppColors.neutral400),
          ),
        ),
      );
    }

    return SizedBox(
      height: 168,
      child: CustomPaint(
        painter: _TrendPainter(samples: samples, localeName: localeName),
        child: const SizedBox.expand(),
      ),
    );
  }
}

final class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.samples, required this.localeName});

  final List<({DateTime at, double value})> samples;
  final String localeName;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 36.0;
    const right = 8.0;
    const top = 12.0;
    const bottom = 24.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - right,
      size.height - top - bottom,
    );
    if (chart.width <= 0 || chart.height <= 0) return;

    final values = samples.map((sample) => sample.value).toList();
    var minValue = values.reduce(math.min);
    var maxValue = values.reduce(math.max);
    if (minValue == maxValue) {
      minValue -= 1;
      maxValue += 1;
    }
    final span = maxValue - minValue;

    Offset pointFor(int index, double value) {
      final x = samples.length == 1
          ? chart.center.dx
          : chart.left + (chart.width * (index / (samples.length - 1)));
      final y = chart.bottom - ((value - minValue) / span) * chart.height;
      return Offset(x, y);
    }

    final path = Path()..moveTo(pointFor(0, samples.first.value).dx, pointFor(0, samples.first.value).dy);
    for (var i = 1; i < samples.length; i++) {
      path.lineTo(pointFor(i, samples[i].value).dx, pointFor(i, samples[i].value).dy);
    }

    final fill = Path.from(path)
      ..lineTo(pointFor(samples.length - 1, samples.last.value).dx, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();

    canvas.drawRect(
      chart,
      Paint()..color = AppColors.neutral100,
    );
    canvas.drawPath(
      fill,
      Paint()..color = AppColors.primary.withValues(alpha: 0.16),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary700
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final dotPaint = Paint()..color = AppColors.primary;
    final borderPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < samples.length; i++) {
      final offset = pointFor(i, samples[i].value);
      canvas.drawCircle(offset, 4, dotPaint);
      canvas.drawCircle(offset, 4, borderPaint);
    }

    final labelStyle = TextStyle(
      color: AppColors.neutral500,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
    _drawLabel(
      canvas,
      InbodyFormat.number(maxValue),
      Offset(0, chart.top - 2),
      labelStyle,
    );
    _drawLabel(
      canvas,
      InbodyFormat.number(minValue),
      Offset(0, chart.bottom - 12),
      labelStyle,
    );
    _drawLabel(
      canvas,
      InbodyFormat.shortDate(localeName, samples.first.at),
      Offset(chart.left, chart.bottom + 6),
      labelStyle,
    );
    _drawLabel(
      canvas,
      InbodyFormat.shortDate(localeName, samples.last.at),
      Offset(chart.right - 28, chart.bottom + 6),
      labelStyle,
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.samples != samples || oldDelegate.localeName != localeName;
  }
}
