import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glory_gym/core/core.dart';
import '../../../../core/di/service_locator.dart';
import '../cubits/feedback/feedback_cubit.dart';

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

  Future<void> _onSend(BuildContext providerContext) async {
    final success = await providerContext
        .read<FeedbackCubit>()
        .submitFeedback(_controller.text.trim());

    if (!providerContext.mounted) return;

    if (!success) {
      final error = providerContext.read<FeedbackCubit>().state.errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(providerContext).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
      return;
    }

    AppSuccessSheet.show(
      providerContext,
      title: 'تم الإرسال',
      headline: 'شكراً لتواصلك معنا',
      highlightWord: 'شكراً',
      description: 'سنقوم بمراجعة شكواك أو اقتراحك والرد عليك في أقرب وقت.',
      buttonLabel: 'حسناً',
      onButtonPressed: () {
        providerContext.read<FeedbackCubit>().reset();
        providerContext.pop();
        providerContext.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FeedbackCubit>(),
      child: Builder(
        builder: (providerContext) {
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
                  BlocBuilder<FeedbackCubit, FeedbackState>(
                    builder: (context, state) => AppButton(
                      label: 'إرسال',
                      isLoading: state.isSubmitting,
                      onPressed: _canSubmit && !state.isSubmitting
                          ? () => _onSend(providerContext)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
