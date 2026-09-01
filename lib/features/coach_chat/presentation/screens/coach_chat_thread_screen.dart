import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/chat_entities.dart';
import '../cubits/coach_chat_thread/coach_chat_thread_cubit.dart';
import '../cubits/coach_chat_unread/coach_chat_unread_cubit.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/coach_chat_header.dart';

final class CoachChatThreadScreen extends StatefulWidget {
  const CoachChatThreadScreen({
    super.key,
    required this.conversationId,
    this.conversation,
  });

  final String conversationId;
  final ChatConversationEntity? conversation;

  @override
  State<CoachChatThreadScreen> createState() => _CoachChatThreadScreenState();
}

final class _CoachChatThreadScreenState extends State<CoachChatThreadScreen>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  bool _didInitialScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<CoachChatThreadCubit>().refreshMessages();
      context.read<CoachChatUnreadCubit>().fetchUnreadCount();
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !mounted) return;
    if (_scrollController.position.pixels <= 80) {
      context.read<CoachChatThreadCubit>().loadOlderMessages();
    }
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (animate) {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;
    final instructorName =
        conversation?.instructor.fullName ?? context.l10n.coachChat;
    final instructorAvatarUrl = conversation?.instructor.avatarUrl;

    return BlocProvider(
      create: (_) => CoachChatThreadCubit(
        sl(),
        conversationId: widget.conversationId,
        instructorName: instructorName,
        instructorAvatarUrl: instructorAvatarUrl,
      )..openThread(),
      child: BlocConsumer<CoachChatThreadCubit, CoachChatThreadState>(
        listenWhen: (previous, current) =>
            previous.messages.length != current.messages.length ||
            previous.status != current.status,
        listener: (context, state) {
          if (state.status == CoachChatThreadStatus.loaded &&
              state.messages.isNotEmpty) {
            if (!_didInitialScroll) {
              _scrollToBottom(animate: false);
              _didInitialScroll = true;
            } else {
              _scrollToBottom();
            }
          }

          if (state.status == CoachChatThreadStatus.loaded) {
            context.read<CoachChatUnreadCubit>().fetchUnreadCount();
          }
        },
        builder: (context, state) {
          return AppScaffold(
            appBar: CoachChatHeader(
              coachName: instructorName,
              subtitle: context.l10n.coachChatWithInstructor,
              avatarUrl: instructorAvatarUrl,
            ),
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.white, AppColors.neutral100],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: _MessagesBody(
                      state: state,
                      scrollController: _scrollController,
                      instructorAvatarUrl: instructorAvatarUrl,
                      onRetry: () =>
                          context.read<CoachChatThreadCubit>().openThread(),
                    ),
                  ),
                  ChatInputBar(
                    enabled: state.status != CoachChatThreadStatus.loading,
                    onSend: context.read<CoachChatThreadCubit>().sendMessage,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _MessagesBody extends StatelessWidget {
  const _MessagesBody({
    required this.state,
    required this.scrollController,
    required this.onRetry,
    this.instructorAvatarUrl,
  });

  final CoachChatThreadState state;
  final ScrollController scrollController;
  final VoidCallback onRetry;
  final String? instructorAvatarUrl;

  @override
  Widget build(BuildContext context) {
    final isLoading = state.isLoading && state.messages.isEmpty;

    if (state.status == CoachChatThreadStatus.failure &&
        state.messages.isEmpty) {
      return _ThreadErrorView(
        message: state.errorMessage ?? context.l10n.errorTryAgain,
        onRetry: onRetry,
      );
    }

    if (!isLoading && state.messages.isEmpty) {
      return _ThreadEmptyView(
        message: context.l10n.coachChatStartConversation,
      );
    }

    final itemCount = isLoading ? 4 : state.messages.length;

    return Stack(
      children: [
        Skeletonizer(
          enabled: isLoading,
          child: ListView.builder(
            controller: scrollController,
            physics: isLoading ? const NeverScrollableScrollPhysics() : null,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final message = isLoading
                  ? _placeholderMessage(index)
                  : state.messages[index];

              return ChatMessageBubble(
                key: ValueKey(message.id),
                message: message,
                instructorAvatarUrl: instructorAvatarUrl,
                animate: !isLoading,
              );
            },
          ),
        ),
        if (state.isLoadingMore)
          const Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: _LoadMoreIndicator(),
          ),
      ],
    );
  }
}

final class _ThreadEmptyView extends StatelessWidget {
  const _ThreadEmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppEntrance(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary100,
                      AppColors.primary200.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: const Icon(
                  Iconsax.messages_2,
                  size: 40,
                  color: AppColors.primary600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.captionRegular.copyWith(
                  color: AppColors.neutral500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ThreadErrorView extends StatelessWidget {
  const _ThreadErrorView({
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
              FilledButton(onPressed: onRetry, child: Text(context.l10n.retry)),
            ],
          ),
        ),
      ),
    );
  }
}

final class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

ChatMessageEntity _placeholderMessage(int index) {
  final isMember = index.isOdd;
  return ChatMessageEntity(
    id: 'skeleton_$index',
    conversationId: 'skeleton',
    senderType:
        isMember ? ChatSenderType.member : ChatSenderType.instructor,
    sender: const ChatParticipantEntity(
      id: 'skeleton',
      fullName: 'Loading',
    ),
    body: 'Loading message placeholder',
    read: true,
    createdAt: DateTime(2026, 8, 10, 12, index),
  );
}
