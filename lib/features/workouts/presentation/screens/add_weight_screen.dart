import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glory_gym/core/core.dart';

final class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

final class _AddWeightScreenState extends State<AddWeightScreen> {
  final _controller = TextEditingController();

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              label: 'الوزن المقترح',
              controller: _controller,
              hint: 'قم بإدخال الوزن المقترح الخاص بك لهذه التمرين',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            AppButton(
              label: 'اضافة وزن',
              onPressed: _canSubmit ? () => Navigator.of(context).pop() : null,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
