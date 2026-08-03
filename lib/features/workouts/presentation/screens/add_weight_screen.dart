import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/workouts/domain/repositories/workouts_repository.dart';

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
      appBar: const AppPrimaryHeader(
        title: 'اضافة وزن ( للتمرين )',
        showBack: true,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'الوزن',
              controller: _controller,
              hint: 'قم بإدخال الوزن المقترح الخاص بك لهذه التمرين',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            AppButton(
              label: 'اضافة وزن',
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
