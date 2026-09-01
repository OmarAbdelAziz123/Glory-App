import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_entrance.dart';

final class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    this.maxLength = 2000,
    this.enabled = true,
  });

  final ValueChanged<String> onSend;
  final int maxLength;
  final bool enabled;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

final class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged() {
    final canSend = _controller.text.trim().isNotEmpty && widget.enabled;
    if (canSend != _canSend) {
      setState(() => _canSend = canSend);
    }
  }

  void _onFocusChanged() => setState(() {});

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;
    if (text.length > widget.maxLength) return;

    FocusManager.instance.primaryFocus?.unfocus();
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isFocused = _focusNode.hasFocus;

    return AppEntrance(
      delay: const Duration(milliseconds: 120),
      offset: const Offset(0, 0.12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.fromLTRB(16, 8, 16, bottomInset > 0 ? 10 : 16),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isFocused ? AppColors.primary400 : AppColors.neutral200,
            width: isFocused ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: isFocused ? 0.08 : 0.05),
              blurRadius: isFocused ? 20 : 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _SendButton(
              enabled: _canSend,
              onTap: _handleSend,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                maxLength: widget.maxLength,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                style: context.captionRegular.copyWith(
                  color: AppColors.neutral900,
                ),
                decoration: InputDecoration(
                  hintText: context.l10n.coachChatTypeMessage,
                  counterText: '',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  hintStyle: context.captionRegular.copyWith(
                    color: AppColors.neutral400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _SendButton extends StatefulWidget {
  const _SendButton({
    required this.enabled,
    required this.onTap,
  });

  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

final class _SendButtonState extends State<_SendButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.enabled
                ? const LinearGradient(
                    colors: [AppColors.primary500, AppColors.primary700],
                  )
                : null,
            color: widget.enabled ? null : AppColors.neutral200,
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.32),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Iconsax.send_1,
            size: 20,
            color: widget.enabled ? AppColors.white : AppColors.neutral500,
          ),
        ),
      ),
    );
  }
}
