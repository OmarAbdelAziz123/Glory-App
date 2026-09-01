import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../coach_chat/presentation/utils/chat_time_formatter.dart';
import '../../domain/entities/sandy_entities.dart';
import '../cubits/sandy_conversations_list/sandy_conversations_list_cubit.dart';

final class SandyConversationsListScreen extends StatelessWidget {
  const SandyConversationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SandyConversationsListCubit>()..loadConversations(),
      child: const _SandyConversationsListContent(),
    );
  }
}

final class _SandyConversationsListContent extends StatelessWidget {
  const _SandyConversationsListContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SandyConversationsListCubit, SandyConversationsListState>(
      listenWhen: (previous, current) =>
          previous.actionErrorMessage != current.actionErrorMessage &&
          current.actionErrorMessage != null,
      listener: (context, state) {
        final message = state.actionErrorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        return AppScaffold(
          appBar: AppPrimaryHeader(
            title: context.l10n.sandyChatHistory,
            centerTitle: true,
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.white, AppColors.neutral100],
              ),
            ),
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SandyConversationsListState state) {
    if (state.status == SandyConversationsListStatus.failure &&
        state.conversations.isEmpty) {
      return _ErrorView(
        message: state.errorMessage ?? context.l10n.errorTryAgain,
        onRetry: () =>
            context.read<SandyConversationsListCubit>().loadConversations(),
      );
    }

    if (!state.isLoading && state.isEmpty) {
      return _EmptyView(
        title: context.l10n.sandyNoConversations,
        description: context.l10n.sandyNoConversationsDescription,
      );
    }

    final isLoading = state.isLoading;
    final itemCount = isLoading ? 4 : state.conversations.length;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: isLoading
              ? () async {}
              : () => context
                  .read<SandyConversationsListCubit>()
                  .loadConversations(refresh: true),
          child: Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              physics: isLoading
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: itemCount,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final conversation = isLoading
                    ? _placeholderConversation(context, index)
                    : state.conversations[index];

                return AppEntrance(
                  delay: isLoading
                      ? Duration.zero
                      : Duration(milliseconds: 60 + (index * 70)),
                  offset: const Offset(0, 0.06),
                  animate: !isLoading,
                  child: _ConversationTile(
                    conversation: conversation,
                    enabled: !isLoading && !state.isUpdating,
                  ),
                );
              },
            ),
          ),
        ),
        if (state.isUpdating)
          const Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

SandyConversationEntity _placeholderConversation(
  BuildContext context,
  int index,
) {
  return SandyConversationEntity(
    id: 'skeleton_$index',
    title: context.l10n.sandyAi,
    createdAt: DateTime(2026),
    lastMessageAt: DateTime(2026),
    messageCount: 3,
    lastMessage: SandyConversationPreviewEntity(
      body: context.l10n.sandyWelcomeMessage,
      role: SandyMessageRole.assistant,
      createdAt: DateTime(2026),
    ),
  );
}

final class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.conversation,
    required this.enabled,
  });

  final SandyConversationEntity conversation;
  final bool enabled;

  Future<void> _openConversation(BuildContext context) async {
    final cubit = context.read<SandyConversationsListCubit>();
    final success = await cubit.openConversation(conversation.id);
    if (!context.mounted) return;
    if (success) context.pop();
  }

  Future<void> _renameConversation(BuildContext context) async {
    final newTitle = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _RenameConversationDialog(
        initialTitle: conversation.title,
      ),
    );

    if (newTitle == null || newTitle.isEmpty || !context.mounted) return;
    await context.read<SandyConversationsListCubit>().renameConversation(
          conversationId: conversation.id,
          title: newTitle,
        );
  }

  Future<void> _deleteConversation(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: context.l10n.sandyDeleteConversation,
      message: context.l10n.sandyDeleteConversationConfirm,
      confirmLabel: context.l10n.delete,
    );
    if (confirmed != true || !context.mounted) return;

    await context.read<SandyConversationsListCubit>().deleteConversation(
          conversation.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    final preview = conversation.lastMessage?.body ?? conversation.title;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? () => _openConversation(context) : null,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.neutral200),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primary100, AppColors.primary200],
                    ),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/svgs/ai_icon.svg',
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary700,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.highlightStandard.copyWith(
                          color: AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.captionRegular.copyWith(
                          color: AppColors.neutral500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ChatTimeFormatter.formatConversationTimestamp(
                        conversation.lastMessageAt,
                        yesterdayLabel: context.l10n.yesterday,
                      ),
                      style: context.footnoteRegular.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PopupMenuButton<_ConversationAction>(
                      enabled: enabled,
                      icon: const Icon(
                        Iconsax.more,
                        color: AppColors.neutral500,
                        size: 20,
                      ),
                      onSelected: (action) async {
                        switch (action) {
                          case _ConversationAction.rename:
                            await _renameConversation(context);
                          case _ConversationAction.delete:
                            await _deleteConversation(context);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: _ConversationAction.rename,
                          child: Text(context.l10n.sandyRenameConversation),
                        ),
                        PopupMenuItem(
                          value: _ConversationAction.delete,
                          child: Text(
                            context.l10n.sandyDeleteConversation,
                            style: const TextStyle(color: AppColors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ConversationAction { rename, delete }

final class _RenameConversationDialog extends StatefulWidget {
  const _RenameConversationDialog({required this.initialTitle});

  final String initialTitle;

  @override
  State<_RenameConversationDialog> createState() =>
      _RenameConversationDialogState();
}

final class _RenameConversationDialogState
    extends State<_RenameConversationDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        context.l10n.sandyRenameConversation,
        style: context.highlightBold.copyWith(
          color: AppColors.neutral900,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: context.l10n.sandyConversationTitleHint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(context.l10n.save),
        ),
      ],
    );
  }
}

final class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEntrance(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary100,
                      AppColors.primary200.withValues(alpha: 0.5),
                    ],
                  ),
                ),
                child: const Icon(
                  Iconsax.messages_2,
                  size: 44,
                  color: AppColors.primary700,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.highlightBold.copyWith(
                  color: AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: context.captionRegular.copyWith(
                  color: AppColors.neutral500,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEntrance(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.warning_2, color: AppColors.red, size: 40),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.captionRegular.copyWith(color: AppColors.red),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
