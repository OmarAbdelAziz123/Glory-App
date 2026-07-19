import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';

final class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

final class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final _controller = TextEditingController();

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSend() {
    AppSuccessSheet.show(
      context,
      title: 'تم الإرسال',
      headline: 'شكراً لتواصلك معنا',
      highlightWord: 'شكراً',
      description: 'سنقوم بمراجعة شكواك أو اقتراحك والرد عليك في أقرب وقت.',
      buttonLabel: 'العودة للرئيسية',
      onButtonPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'شكاوي و اقتراحات',
        showBack: true,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'الشكوى أو الاقتراح',
              controller: _controller,
              hint: 'اكتب شكواك أو اقتراحك هنا...',
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              minLines: 4,
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            AppButton(
              label: 'إرسال',
              onPressed: _canSubmit ? _onSend : null,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
