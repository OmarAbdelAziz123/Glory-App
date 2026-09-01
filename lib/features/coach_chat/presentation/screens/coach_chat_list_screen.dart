import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../../core/widgets/app_member_avatar.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/chat_entities.dart';
import '../cubits/coach_chat_list/coach_chat_list_cubit.dart';
import '../cubits/coach_chat_unread/coach_chat_unread_cubit.dart';
import '../utils/chat_time_formatter.dart';

final class CoachChatListScreen extends StatelessWidget {
  const CoachChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CoachChatListCubit>()..loadConversations(),
      child: const _CoachChatListContent(),
    );
  }
}

final class _CoachChatListContent extends StatelessWidget {
  const _CoachChatListContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoachChatListCubit, CoachChatListState>(
      listenWhen: (previous, current) =>
          previous.conversations != current.conversations,
      listener: (context, state) {
        context.read<CoachChatUnreadCubit>().fetchUnreadCount();
      },
      child: AppScaffold(
        appBar: AppPrimaryHeader(
          title: context.l10n.coachChat,
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
          child: BlocBuilder<CoachChatListCubit, CoachChatListState>(
            builder: (context, state) {
              if (state.status == CoachChatListStatus.failure &&
                  state.conversations.isEmpty) {
                return _ErrorView(
                  message: state.errorMessage ?? context.l10n.errorTryAgain,
                  onRetry: () =>
                      context.read<CoachChatListCubit>().loadConversations(),
                );
              }

              if (!state.isLoading && state.isEmpty) {
                return _EmptyView(
                  title: context.l10n.coachChatNotAssignedTitle,
                  description: context.l10n.coachChatNotAssignedDescription,
                );
              }

              final isLoading = state.isLoading && state.conversations.isEmpty;
              final itemCount = isLoading ? 1 : state.conversations.length;

              return RefreshIndicator(
                onRefresh: isLoading
                    ? () async {}
                    : () => context
                        .read<CoachChatListCubit>()
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
                          ? _placeholderConversation(context)
                          : state.conversations[index];

                      return AppEntrance(
                        delay: isLoading
                            ? Duration.zero
                            : Duration(milliseconds: 60 + (index * 70)),
                        offset: const Offset(0, 0.06),
                        animate: !isLoading,
                        child: _ConversationTile(
                          conversation: conversation,
                          enabled: !isLoading,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

ChatConversationEntity _placeholderConversation(BuildContext context) {
  return ChatConversationEntity(
    id: 'skeleton',
    memberId: 'skeleton',
    instructorId: 'skeleton',
    createdAt: DateTime(2026),
    lastMessageAt: DateTime(2026),
    instructor: ChatParticipantEntity(
      id: 'skeleton',
      fullName: context.l10n.instructorName,
    ),
    unreadCount: 1,
  );
}

final class _ConversationTile extends StatefulWidget {
  const _ConversationTile({
    required this.conversation,
    this.enabled = true,
  });

  final ChatConversationEntity conversation;
  final bool enabled;

  @override
  State<_ConversationTile> createState() => _ConversationTileState();
}

final class _ConversationTileState extends State<_ConversationTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final instructor = widget.conversation.instructor;

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.enabled
          ? () => context.push(
                AppRoutes.coachChatThread(widget.conversation.id),
                extra: widget.conversation,
              )
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary200,
                      AppColors.primary.withValues(alpha: 0.35),
                    ],
                  ),
                ),
                child: AppMemberAvatar(
                  avatarUrl: instructor.avatarUrl,
                  size: 50,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instructor.fullName,
                      style: context.highlightStandard.copyWith(
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.coachChatWithInstructor,
                      style: context.captionRegular.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ChatTimeFormatter.formatConversationTimestamp(
                      widget.conversation.lastMessageAt,
                      yesterdayLabel: context.l10n.yesterday,
                    ),
                    style: context.footnoteRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                  if (widget.conversation.unreadCount > 0) ...[
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary500, AppColors.primary600],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.conversation.unreadCount > 99
                            ? '99+'
                            : '${widget.conversation.unreadCount}',
                        style: context.footnoteRegular.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
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
