import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_member_avatar.dart';
import '../../domain/entities/chat_entities.dart';
import '../utils/chat_time_formatter.dart';

final class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.instructorAvatarUrl,
    this.animate = true,
  });

  final ChatMessageEntity message;
  final String? instructorAvatarUrl;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final bubble = message.isMember
        ? _MemberBubble(message: message)
        : _InstructorBubble(
            message: message,
            avatarUrl: instructorAvatarUrl ?? message.sender.avatarUrl,
          );

    if (!animate) return bubble;

    return _AnimatedChatBubble(
      key: ValueKey(message.id),
      isMember: message.isMember,
      child: bubble,
    );
  }
}

final class _AnimatedChatBubble extends StatefulWidget {
  const _AnimatedChatBubble({
    super.key,
    required this.isMember,
    required this.child,
  });

  final bool isMember;
  final Widget child;

  @override
  State<_AnimatedChatBubble> createState() => _AnimatedChatBubbleState();
}

final class _AnimatedChatBubbleState extends State<_AnimatedChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(widget.isMember ? -0.1 : 0.1, 0.14),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _scale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          alignment: widget.isMember
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: widget.child,
        ),
      ),
    );
  }
}

final class _InstructorBubble extends StatelessWidget {
  const _InstructorBubble({
    required this.message,
    this.avatarUrl,
  });

  final ChatMessageEntity message;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: _BubbleContainer(
                backgroundColor: AppColors.white,
                border: Border.all(color: AppColors.neutral200),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(6),
                ),
                textColor: AppColors.neutral900,
                message: message,
              ),
            ),
            const SizedBox(width: 8),
            _CoachAvatarBadge(avatarUrl: avatarUrl),
          ],
        ),
      ),
    );
  }
}

final class _MemberBubble extends StatelessWidget {
  const _MemberBubble({required this.message});

  final ChatMessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _BubbleContainer(
          gradient: const LinearGradient(
            colors: [AppColors.primary500, AppColors.primary700],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(20),
          ),
          textColor: AppColors.white,
          timeColor: AppColors.white.withValues(alpha: 0.78),
          message: message,
          showReadIndicator: true,
        ),
      ),
    );
  }
}

final class _CoachAvatarBadge extends StatelessWidget {
  const _CoachAvatarBadge({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primary300,
            AppColors.primary.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: AppMemberAvatar(avatarUrl: avatarUrl, size: 32),
    );
  }
}

final class _BubbleContainer extends StatelessWidget {
  const _BubbleContainer({
    required this.message,
    required this.textColor,
    required this.borderRadius,
    this.backgroundColor,
    this.gradient,
    this.border,
    this.timeColor,
    this.showReadIndicator = false,
  });

  final ChatMessageEntity message;
  final Color textColor;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Gradient? gradient;
  final BoxBorder? border;
  final Color? timeColor;
  final bool showReadIndicator;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.74,
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: gradient,
        borderRadius: borderRadius,
        border: border,
        boxShadow: [
          BoxShadow(
            color: (gradient != null ? AppColors.primary : AppColors.black)
                .withValues(alpha: gradient != null ? 0.22 : 0.05),
            blurRadius: gradient != null ? 14 : 10,
            offset: Offset(0, gradient != null ? 5 : 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message.body,
            style: context.captionRegular.copyWith(
              color: textColor,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: showReadIndicator
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text(
                ChatTimeFormatter.formatTime(message.createdAt.toLocal()),
                style: context.footnoteRegular.copyWith(
                  color: timeColor ?? AppColors.neutral400,
                ),
              ),
              if (message.isPending) ...[
                const SizedBox(width: 6),
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: timeColor ?? AppColors.neutral400,
                  ),
                ),
              ] else if (showReadIndicator) ...[
                const SizedBox(width: 4),
                Icon(
                  message.read ? Iconsax.tick_circle5 : Iconsax.tick_circle,
                  size: 14,
                  color: timeColor ?? AppColors.neutral400,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
