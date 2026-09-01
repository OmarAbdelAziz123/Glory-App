import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glory_gym/core/core.dart';
import '../../../../core/di/service_locator.dart';
import '../cubits/feedback/feedback_cubit.dart';
import '../../../../core/l10n/l10n_extension.dart';

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
      title: context.l10n.sent,
      headline: context.l10n.thanksForContactingUs,
      highlightWord: context.l10n.thankYou,
      description: context.l10n.complaintReviewMessage,
      buttonLabel: context.l10n.okAlt,
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
            appBar: AppPrimaryHeader(
              title: context.l10n.complaintsAndSuggestions,
              showBack: true,
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: context.l10n.complaintOrSuggestion,
                    controller: _controller,
                    hint: context.l10n.writeComplaintOrSuggestion,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    minLines: 4,
                    onChanged: (_) => setState(() {}),
                  ),
                  const Spacer(),
                  BlocBuilder<FeedbackCubit, FeedbackState>(
                    builder: (context, state) => AppButton(
                      label: context.l10n.submit,
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
