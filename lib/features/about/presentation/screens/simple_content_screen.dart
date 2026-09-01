import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/content_args.dart';
import '../cubits/info_page/info_page_cubit.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class SimpleContentScreen extends StatelessWidget {
  const SimpleContentScreen({super.key, required this.args});

  final SimpleContentArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InfoPageCubit>()..loadPage(args.pageKey),
      child: BlocBuilder<InfoPageCubit, InfoPageState>(
        builder: (context, state) {
          final isArabic = ContentUtils.isArabic(context);
          final title = state.page?.titleFor(isArabic: isArabic) ?? ' ';
          final content = state.page?.contentFor(isArabic: isArabic) ?? ' ';

          return AppScaffold(
            appBar: AppPrimaryHeader(
              title: state.isLoading ? args.pageKey : title,
              showBack: true,
              centerTitle: false,
            ),
            body: state.status == InfoPageStatus.failure
                ? _ErrorView(
                    message: state.errorMessage ?? context.l10n.errorTryAgain,
                    onRetry: () =>
                        context.read<InfoPageCubit>().loadPage(args.pageKey),
                  )
                : Skeletonizer(
                    enabled: state.isLoading,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ContentHeroImage(imageUrl: state.page?.imageUrl),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(
                              content,
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
                  ),
          );
        },
      ),
    );
  }
}

final class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            AppButton(label: context.l10n.retry, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
