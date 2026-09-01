import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../coach_chat/presentation/utils/chat_time_formatter.dart';
import '../../domain/entities/sandy_entities.dart';
import '../cubits/sandy_chat/sandy_chat_cubit.dart';

final class GloryAiScreen extends StatelessWidget {
  const GloryAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GloryAiView();
  }
}

final class _GloryAiView extends StatefulWidget {
  const _GloryAiView();

  @override
  State<_GloryAiView> createState() => _GloryAiViewState();
}

final class _GloryAiViewState extends State<_GloryAiView> {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final _inputFocusNode = FocusNode();
  var _canSend = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onInputChanged() {
    final canSend = _inputController.text.trim().isNotEmpty;
    if (canSend != _canSend) {
      setState(() => _canSend = canSend);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels <= position.minScrollExtent + 48) {
      context.read<SandyChatCubit>().loadOlderMessages();
    }
  }

  void _handleSend([String? presetText]) {
    final text = (presetText ?? _inputController.text).trim();
    if (text.isEmpty) return;

    FocusManager.instance.primaryFocus?.unfocus();
    _inputController.clear();
    context.read<SandyChatCubit>().sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SandyChatCubit, SandyChatState>(
      listenWhen: (previous, current) =>
          previous.messages.length != current.messages.length ||
          previous.isTyping != current.isTyping ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        _scrollToBottom();
        final error = state.errorMessage;
        if (error != null && error.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(error)));
        }
      },
      builder: (context, state) {
        return AppScaffold(
          appBar: AppPrimaryHeader(
            title: context.l10n.sandyAi,
            showBack: false,
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: context.l10n.sandyNewChat,
                onPressed: state.isTyping
                    ? null
                    : () => context.read<SandyChatCubit>().startNewConversation(),
                icon: const Icon(Iconsax.add, color: AppColors.white),
              ),
              IconButton(
                tooltip: context.l10n.sandyChatHistory,
                onPressed: () => context.push(AppRoutes.sandyConversations),
                icon: const Icon(Iconsax.message_text_1, color: AppColors.white),
              ),
              const SizedBox(width: 8),
            ],
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
                if (state.isLoading && state.isEmpty)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      itemCount: _itemCount(state),
                      itemBuilder: (context, index) =>
                          _buildItem(context, state, index),
                    ),
                  ),
                _ChatInputBar(
                  controller: _inputController,
                  focusNode: _inputFocusNode,
                  canSend: _canSend && !state.isTyping,
                  onSend: _handleSend,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _itemCount(SandyChatState state) {
    var count = 0;
    if (state.isEmpty && !state.isLoading) count++;
    if (state.showSuggestions && state.suggestions.isNotEmpty) count++;
    count += state.messages.length;
    if (state.isTyping) count++;
    if (state.isLoadingMore) count++;
    return count;
  }

  Widget _buildItem(BuildContext context, SandyChatState state, int index) {
    var cursor = 0;

    if (state.isEmpty && !state.isLoading) {
      if (index == cursor) {
        return _WelcomeBubble(
          text:
              '${context.l10n.sandyWelcomeMessage}${context.l10n.sandyAskMeHint}',
        );
      }
      cursor++;
    }

    if (state.showSuggestions && state.suggestions.isNotEmpty) {
      if (index == cursor) {
        return _SuggestionChipsRow(
          suggestions: state.suggestions,
          onSuggestionTap: _handleSend,
        );
      }
      cursor++;
    }

    final messageIndex = index - cursor;
    if (messageIndex < state.messages.length) {
      final message = state.messages[messageIndex];
      return _SandyMessageBubble(
        key: ValueKey(message.id),
        message: message,
        onRetry: message.refusalReason == SandyRefusalReason.providerError
            ? () => context.read<SandyChatCubit>().retryLastMessage()
            : null,
        onContactCoach: message.refusalReason == SandyRefusalReason.medicalAdvice
            ? () => context.push(AppRoutes.coachChat)
            : null,
      );
    }

    if (state.isLoadingMore &&
        messageIndex == state.messages.length) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
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
      );
    }

    return const _TypingIndicatorBubble();
  }
}

final class _WelcomeBubble extends StatelessWidget {
  const _WelcomeBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _AiBubbleContent(
        body: text,
        time: ChatTimeFormatter.formatTime(DateTime.now()),
      ),
    );
  }
}

final class _SuggestionChipsRow extends StatelessWidget {
  const _SuggestionChipsRow({
    required this.suggestions,
    required this.onSuggestionTap,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions
            .map(
              (label) => _SuggestionChip(
                label: label,
                onTap: () => onSuggestionTap(label),
              ),
            )
            .toList(),
      ),
    );
  }
}

final class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary200),
          ),
          child: Text(
            label,
            style: context.captionRegular.copyWith(color: AppColors.primary800),
          ),
        ),
      ),
    );
  }
}

final class _SandyMessageBubble extends StatelessWidget {
  const _SandyMessageBubble({
    super.key,
    required this.message,
    this.onRetry,
    this.onContactCoach,
  });

  final SandyMessageEntity message;
  final VoidCallback? onRetry;
  final VoidCallback? onContactCoach;

  @override
  Widget build(BuildContext context) {
    final time = ChatTimeFormatter.formatTime(message.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: message.isUser
          ? _UserBubbleContent(body: message.body, time: time)
          : _AiBubbleContent(
              body: message.body,
              time: time,
              citations: message.citations,
              onRetry: onRetry,
              onContactCoach: onContactCoach,
            ),
    );
  }
}

final class _AiBubbleContent extends StatelessWidget {
  const _AiBubbleContent({
    required this.body,
    required this.time,
    this.citations = const [],
    this.onRetry,
    this.onContactCoach,
  });

  final String body;
  final String time;
  final List<SandyCitationEntity> citations;
  final VoidCallback? onRetry;
  final VoidCallback? onContactCoach;

  Future<void> _openCitation(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _AiAvatar(size: 34),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.72,
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(color: AppColors.neutral200),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        body,
                        style: context.captionRegular.copyWith(
                          color: AppColors.neutral900,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          time,
                          style: context.footnoteRegular.copyWith(
                            color: AppColors.neutral400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (citations.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: citations
                        .map(
                          (citation) => _CitationChip(
                            label: citation.title,
                            onTap: () => _openCitation(citation.sourceUrl),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (onContactCoach != null) ...[
                  const SizedBox(height: 8),
                  _ActionChip(
                    label: context.l10n.contactYourCoach,
                    onTap: onContactCoach!,
                  ),
                ],
                if (onRetry != null) ...[
                  const SizedBox(height: 8),
                  _ActionChip(
                    label: context.l10n.retry,
                    onTap: onRetry!,
                    outlined: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _UserBubbleContent extends StatelessWidget {
  const _UserBubbleContent({required this.body, required this.time});

  final String body;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary500, AppColors.primary600],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              body,
              style: context.captionRegular.copyWith(
                color: AppColors.white,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                time,
                style: context.footnoteRegular.copyWith(
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _CitationChip extends StatelessWidget {
  const _CitationChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary100,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.link_1, size: 14, color: AppColors.primary700),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.footnoteRegular.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.onTap,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: outlined ? AppColors.white : AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: outlined
                ? Border.all(color: AppColors.primary300)
                : null,
          ),
          child: Text(
            label,
            style: context.captionRegular.copyWith(
              color: outlined ? AppColors.primary800 : AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

final class _TypingIndicatorBubble extends StatelessWidget {
  const _TypingIndicatorBubble();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _AiAvatar(size: 34),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: const _TypingDots(),
            ),
          ],
        ),
      ),
    );
  }
}

final class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

final class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value =
                math.sin((_controller.value * math.pi * 2) + delay);
            final wave = (value + 1) / 2;
            final offset = wave * 3;

            return Padding(
              padding: EdgeInsetsDirectional.only(start: index == 0 ? 0 : 6),
              child: Transform.translate(
                offset: Offset(0, -offset),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: 0.35 + wave * 0.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

final class _AiAvatar extends StatelessWidget {
  const _AiAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primary100, AppColors.primary200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/svgs/ai_icon.svg',
          width: size * 0.48,
          height: size * 0.48,
          colorFilter: const ColorFilter.mode(
            AppColors.primary700,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

final class _ChatInputBar extends StatefulWidget {
  const _ChatInputBar({
    required this.controller,
    required this.focusNode,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool canSend;
  final ValueChanged<String> onSend;

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

final class _ChatInputBarState extends State<_ChatInputBar> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, bottomInset > 0 ? 8 : 16),
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: widget.focusNode.hasFocus
              ? AppColors.primary300
              : AppColors.neutral200,
          width: widget.focusNode.hasFocus ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                if (widget.canSend) widget.onSend(value);
              },
              style: context.captionRegular.copyWith(color: AppColors.neutral900),
              decoration: InputDecoration(
                hintText: context.l10n.writeMessageToSandy,
                hintStyle: context.captionRegular.copyWith(
                  color: AppColors.neutral400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
              ),
            ),
          ),
          _SendButton(
            enabled: widget.canSend,
            onTap: () => widget.onSend(widget.controller.text),
          ),
        ],
      ),
    );
  }
}

final class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.primary : AppColors.neutral200,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Iconsax.send_2,
            size: 20,
            color: enabled ? AppColors.white : AppColors.neutral400,
          ),
        ),
      ),
    );
  }
}
