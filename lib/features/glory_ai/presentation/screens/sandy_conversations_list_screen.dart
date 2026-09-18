import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
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
      return _PlatformAdaptiveRefreshScroll(
        onRefresh: () => context
            .read<SandyConversationsListCubit>()
            .loadConversations(refresh: true),
        child: _EmptyView(
          title: context.l10n.sandyNoConversations,
          description: context.l10n.sandyNoConversationsDescription,
        ),
      );
    }

    final isLoading = state.isLoading;
    final itemCount = isLoading ? 4 : state.conversations.length;
    final onRefresh = isLoading
        ? () async {}
        : () => context
            .read<SandyConversationsListCubit>()
            .loadConversations(refresh: true);

    Widget buildTile(int index) {
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
    }

    final listPhysics = isLoading
        ? const NeverScrollableScrollPhysics()
        : const AlwaysScrollableScrollPhysics();

    final conversationList = defaultTargetPlatform == TargetPlatform.iOS
        ? CustomScrollView(
            physics: listPhysics,
            slivers: [
              if (!isLoading)
                CupertinoSliverRefreshControl(onRefresh: onRefresh),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.separated(
                  itemCount: itemCount,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => Skeletonizer(
                    enabled: isLoading,
                    child: buildTile(index),
                  ),
                ),
              ),
            ],
          )
        : RefreshIndicator(
            color: AppColors.primary,
            onRefresh: onRefresh,
            child: Skeletonizer(
              enabled: isLoading,
              child: ListView.separated(
                physics: listPhysics,
                padding: const EdgeInsets.all(16),
                itemCount: itemCount,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => buildTile(index),
              ),
            ),
          );

    return Stack(
      children: [
        conversationList,
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

  Future<void> _showActions(BuildContext context) async {
    final action = await showModalBottomSheet<_ConversationAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ConversationActionsSheet(
        conversationTitle: conversation.title,
      ),
    );
    if (!context.mounted || action == null) return;

    switch (action) {
      case _ConversationAction.rename:
        await _renameConversation(context);
      case _ConversationAction.delete:
        await _deleteConversation(context);
    }
  }

  Future<void> _renameConversation(BuildContext context) async {
    final newTitle = await _RenameConversationSheet.show(
      context,
      initialTitle: conversation.title,
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
          padding: const EdgeInsets.fromLTRB(6, 8, 10, 8),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: enabled ? () => _openConversation(context) : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary100,
                                AppColors.primary200,
                              ],
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
                      ],
                    ),
                  ),
                ),
              ),
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
                  const SizedBox(height: 10),
                  Material(
                    color: AppColors.primary100,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: enabled ? () => _showActions(context) : null,
                      child: const SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(
                          Iconsax.more,
                          color: AppColors.primary800,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ConversationAction { rename, delete }

final class _ConversationActionsSheet extends StatelessWidget {
  const _ConversationActionsSheet({required this.conversationTitle});

  final String conversationTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    context.l10n.chooseAction,
                    style: context.highlightBold.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    conversationTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.captionRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.neutral200),
            _ConversationActionTile(
              icon: Iconsax.edit_2,
              label: context.l10n.sandyRenameConversation,
              onTap: () =>
                  Navigator.of(context).pop(_ConversationAction.rename),
            ),
            const Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: AppColors.neutral200,
            ),
            _ConversationActionTile(
              icon: Iconsax.trash,
              label: context.l10n.sandyDeleteConversation,
              isDestructive: true,
              onTap: () =>
                  Navigator.of(context).pop(_ConversationAction.delete),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

final class _ConversationActionTile extends StatelessWidget {
  const _ConversationActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.red : AppColors.neutral900;
    final iconBackground =
        isDestructive ? AppColors.red10 : AppColors.primary100;
    final iconColor =
        isDestructive ? AppColors.red : AppColors.primary800;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: context.highlightStandard.copyWith(color: color),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDestructive ? AppColors.red : AppColors.neutral400,
            ),
          ],
        ),
      ),
    );
  }
}

final class _RenameConversationSheet extends StatefulWidget {
  const _RenameConversationSheet({required this.initialTitle});

  final String initialTitle;

  static Future<String?> show(
    BuildContext context, {
    required String initialTitle,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RenameConversationSheet(initialTitle: initialTitle),
    );
  }

  @override
  State<_RenameConversationSheet> createState() =>
      _RenameConversationSheetState();
}

final class _RenameConversationSheetState
    extends State<_RenameConversationSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    Navigator.of(context).pop(title);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.neutral300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.l10n.sandyRenameConversation,
                  textAlign: TextAlign.center,
                  style: context.highlightBold.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: context.l10n.sandyConversationTitleHint,
                  controller: _controller,
                  focusNode: _focusNode,
                  hint: context.l10n.sandyConversationTitleHint,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: context.l10n.cancel,
                        variant: AppButtonVariant.outlined,
                        height: 52,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: context.l10n.save,
                        height: 52,
                        onPressed: _submit,
                      ),
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

final class _PlatformAdaptiveRefreshScroll extends StatelessWidget {
  const _PlatformAdaptiveRefreshScroll({
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverFillRemaining(hasScrollBody: false, child: child),
        ],
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
