import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';

// ── Args ──────────────────────────────────────────────────────────────────────

final class SimpleContentArgs {
  const SimpleContentArgs({required this.title, required this.content});

  final String title;
  final String content;
}

// ── Screen ────────────────────────────────────────────────────────────────────

final class SimpleContentScreen extends StatelessWidget {
  const SimpleContentScreen({super.key, required this.args});

  final SimpleContentArgs args;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: args.title,
        showBack: true,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _GymImage(),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                args.content,
                style: context.contentRegular.copyWith(
                  color: AppColors.neutral700,
                  height: 1.8,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _GymImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Image.asset(
        'assets/images/pngs/classes_image.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
