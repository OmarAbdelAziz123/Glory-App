import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/fallback_messages.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/sandy_entities.dart';
import '../cubits/sandy_documents/sandy_documents_cubit.dart';
import '../utils/sandy_document_utils.dart';

final class SandyHealthFilesScreen extends StatefulWidget {
  const SandyHealthFilesScreen({super.key});

  @override
  State<SandyHealthFilesScreen> createState() => _SandyHealthFilesScreenState();
}

final class _SandyHealthFilesScreenState extends State<SandyHealthFilesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<SandyDocumentsCubit>().loadMore();
    }
  }

  Future<void> _confirmDelete(
    BuildContext providerContext,
    SandyMedicalDocumentEntity document,
  ) async {
    final shouldDelete = await AppConfirmDialog.show(
      providerContext,
      title: context.l10n.sandyDeleteDocument,
      message: context.l10n.sandyDeleteDocumentConfirm,
      confirmLabel: context.l10n.delete,
    );
    if (shouldDelete != true || !providerContext.mounted) return;

    final success =
        await providerContext.read<SandyDocumentsCubit>().deleteDocument(
              document.id,
            );
    if (!providerContext.mounted) return;
    if (success) {
      ScaffoldMessenger.of(providerContext).showSnackBar(
        SnackBar(content: Text(providerContext.l10n.sandyDocumentDeleted)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SandyDocumentsCubit>()..loadDocuments(),
      child: Builder(
        builder: (providerContext) {
          return BlocListener<SandyDocumentsCubit, SandyDocumentsState>(
            listenWhen: (previous, current) =>
                previous.errorMessage != current.errorMessage &&
                current.errorMessage != null,
            listener: (context, state) {
              final message = state.errorMessage;
              if (message == null) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            child: AppScaffold(
              appBar: AppPrimaryHeader(
                title: context.l10n.sandyHealthFiles,
                showBack: true,
                centerTitle: false,
              ),
              body: BlocBuilder<SandyDocumentsCubit, SandyDocumentsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (state.status == SandyDocumentsStatus.failure &&
                      state.documents.isEmpty) {
                    return _DocumentsErrorView(
                      message: state.errorMessage ?? context.l10n.errorTryAgain,
                      onRetry: () => context
                          .read<SandyDocumentsCubit>()
                          .loadDocuments(refresh: true),
                    );
                  }

                  if (state.isEmpty) {
                    return const _DocumentsEmptyView();
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(18),
                    itemCount:
                        state.documents.length +
                        1 +
                        (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return Text(
                          context.l10n.sandyHealthFilesPrivacy,
                          style: context.footnoteRegular.copyWith(
                            color: AppColors.neutral500,
                            height: 1.45,
                          ),
                        );
                      }

                      final documentIndex = index - 1;
                      if (documentIndex >= state.documents.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }

                      final document = state.documents[documentIndex];
                      return _DocumentCard(
                        document: document,
                        isDeleting: state.deletingDocumentId == document.id,
                        onOpen: () => _openFile(document.fileUrl),
                        onDelete: () =>
                            _confirmDelete(providerContext, document),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openFile(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

final class _DocumentsEmptyView extends StatelessWidget {
  const _DocumentsEmptyView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.document, size: 48, color: AppColors.primary700),
          const SizedBox(height: 16),
          Text(
            context.l10n.sandyNoHealthFiles,
            textAlign: TextAlign.center,
            style: context.highlightBold.copyWith(color: AppColors.neutral900),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.sandyNoHealthFilesDescription,
            textAlign: TextAlign.center,
            style: context.captionRegular.copyWith(color: AppColors.neutral600),
          ),
        ],
      ),
    );
  }
}

final class _DocumentsErrorView extends StatelessWidget {
  const _DocumentsErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.captionRegular.copyWith(color: AppColors.neutral700),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

final class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.isDeleting,
    required this.onOpen,
    required this.onDelete,
  });

  final SandyMedicalDocumentEntity document;
  final bool isDeleting;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd(LocaleHolder.languageCode)
        .format(document.createdAt.toLocal());
    final kind = SandyDocumentUtils.kindLabel(context.l10n, document.kind);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isDeleting ? null : onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _DocumentThumb(document: document),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.contentSemibold.copyWith(
                          color: AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$kind • $date',
                        style: context.footnoteRegular.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                      if (document.trainingCaution) ...[
                        const SizedBox(height: 6),
                        Text(
                          context.l10n.sandyTrainingCautionShort,
                          style: context.footnoteRegular.copyWith(
                            color: AppColors.red200,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isDeleting)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    onPressed: onDelete,
                    tooltip: context.l10n.delete,
                    icon: const Icon(Iconsax.trash, color: AppColors.red200),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _DocumentThumb extends StatelessWidget {
  const _DocumentThumb({required this.document});

  final SandyMedicalDocumentEntity document;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 56,
        height: 56,
        child: document.isImage
            ? CachedNetworkImage(
                imageUrl: document.fileUrl,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => const _PdfThumb(),
              )
            : const _PdfThumb(),
      ),
    );
  }
}

final class _PdfThumb extends StatelessWidget {
  const _PdfThumb();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primary100,
      child: Icon(Iconsax.document_text, color: AppColors.primary800),
    );
  }
}
