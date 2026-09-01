import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/workouts/domain/repositories/workouts_repository.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key, required this.assignmentId});

  final String assignmentId;

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

final class _AddWeightScreenState extends State<AddWeightScreen> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  bool get _canSubmit =>
      !_isSubmitting && _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);

    final weight = WorkoutUtils.formatWeightForApi(_controller.text);
    final result = await sl<WorkoutsRepository>().addWorkoutWeight(
      assignmentId: widget.assignmentId,
      weight: weight,
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    result.fold(
      onSuccess: (_) => Navigator.of(context).pop(true),
      onFailure: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: context.l10n.addWorkoutWeight,
        showBack: true,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: context.l10n.weight,
              controller: _controller,
              hint: context.l10n.enterSuggestedWeightForWorkout,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            AppButton(
              label: context.l10n.addWeight,
              isLoading: _isSubmitting,
              onPressed: _canSubmit ? _submit : null,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
