import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';

// ── Models ────────────────────────────────────────────────────────────────────

final class _ChatMessage {
  const _ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isUser,
    this.isRead = false,
  });

  final String id;
  final String text;
  final String time;
  final bool isUser;
  final bool isRead;
}

// ── Screen ────────────────────────────────────────────────────────────────────

final class GloryAiScreen extends StatefulWidget {
  const GloryAiScreen({super.key});

  @override
  State<GloryAiScreen> createState() => _GloryAiScreenState();
}

final class _GloryAiScreenState extends State<GloryAiScreen>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  final _inputFocusNode = FocusNode();

  final List<_ChatMessage> _messages = [];
  int _messageCounter = 0;

  bool _isTyping = false;
  bool _showWelcome = true;
  bool _canSend = false;

  late final AnimationController _welcomeController;
  late final Animation<double> _welcomeFade;
  late final Animation<Offset> _welcomeSlide;

  static const _suggestions = [
    'اقترح لي برنامج تمرين',
    'نصائح للتغذية الصحية',
    'استفسار عن الاشتراك',
  ];

  @override
  void initState() {
    super.initState();

    _welcomeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _welcomeFade = CurvedAnimation(
      parent: _welcomeController,
      curve: Curves.easeOut,
    );
    _welcomeSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _welcomeController, curve: Curves.easeOutCubic),
    );

    _inputController.addListener(_onInputChanged);
    _welcomeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendWelcomeMessage();
    });
  }

  void _onInputChanged() {
    final canSend = _inputController.text.trim().isNotEmpty;
    if (canSend != _canSend) {
      setState(() => _canSend = canSend);
    }
  }

  String _nextId() => 'msg_${++_messageCounter}';

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _sendWelcomeMessage() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() => _isTyping = true);
    _scrollToBottom();

    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    _addAiMessage(
      'مرحباً! أنا ساندي، مساعدك الذكي في جلوري جيم. '
      'اسألني عن التمارين، التغذية، أو أي استفسار يخص اشتراكك.',
    );
    setState(() {
      _isTyping = false;
      _showWelcome = false;
    });
  }

  void _addUserMessage(String text) {
    final now = DateTime.now();
    setState(() {
      _messages.add(
        _ChatMessage(
          id: _nextId(),
          text: text,
          time: _formatTime(now),
          isUser: true,
          isRead: true,
        ),
      );
      _showWelcome = false;
    });
    _scrollToBottom();
  }

  void _addAiMessage(String text) {
    final now = DateTime.now();
    setState(() {
      _messages.add(
        _ChatMessage(
          id: _nextId(),
          text: text,
          time: _formatTime(now),
          isUser: false,
        ),
      );
    });
    _scrollToBottom();
  }

  Future<void> _handleSend([String? presetText]) async {
    final text = (presetText ?? _inputController.text).trim();
    if (text.isEmpty || _isTyping) return;

    FocusManager.instance.primaryFocus?.unfocus();
    _inputController.clear();
    _addUserMessage(text);

    setState(() => _isTyping = true);
    _scrollToBottom();

    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    _addAiMessage(_mockReply(text));
    setState(() => _isTyping = false);
  }

  String _mockReply(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains('تمرين') || lower.contains('برنامج')) {
      return 'رائع! أنصحك ببرنامج 3 أيام في الأسبوع: '
          'يوم للصدر والترiceps، يوم للظهر والبiceps، ويوم للأرجل. '
          'هل تفضل تمارين في الجيم أم في المنزل؟';
    }
    if (lower.contains('تغذ') || lower.contains('أكل') || lower.contains('غذ')) {
      return 'لتحسين أدائك: ركّز على البروtein بعد التمرين، '
          'اشرب 2–3 لتر ماء يومياً، وقلّل السكريات المكررة. '
          'أقدر أجهز لك خطة بسيطة حسب هدفك.';
    }
    if (lower.contains('اشتراك') || lower.contains('باق')) {
      return 'يمكنك الاطلاع على باقاتك من قسم "اشتراكاتي" في الإعدادات. '
          'إذا احتجت مقارنة بين الباقات أو تجديد الاشتراك، أخبرني.';
    }
    return 'شكراً لسؤالك! سأراجع طلبك وأرد عليك بأفضل توصية مناسبة لك. '
        'هل تريد مساعدة في التمارين، التغذية، أو الاشتراك؟';
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
    _welcomeController.dispose();
    _scrollController.dispose();
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'ساندي AI',
        showBack: false,
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                itemCount: _itemCount,
                itemBuilder: (context, index) => _buildItem(context, index),
              ),
            ),
            _ChatInputBar(
              controller: _inputController,
              focusNode: _inputFocusNode,
              canSend: _canSend && !_isTyping,
              onSend: () => _handleSend(),
            ),
          ],
        ),
      ),
    );
  }

  int get _itemCount {
    var count = 0;
    if (_showWelcome) count++;
    count += _messages.length;
    if (_isTyping) count++;
    return count;
  }

  Widget _buildItem(BuildContext context, int index) {
    var cursor = 0;

    if (_showWelcome) {
      if (index == cursor) {
        return FadeTransition(
          opacity: _welcomeFade,
          child: SlideTransition(
            position: _welcomeSlide,
            child: _WelcomeSection(
              suggestions: _suggestions,
              onSuggestionTap: _handleSend,
            ),
          ),
        );
      }
      cursor++;
    }

    final messageIndex = index - cursor;
    if (messageIndex < _messages.length) {
      final message = _messages[messageIndex];
      return _AnimatedMessageBubble(
        key: ValueKey(message.id),
        message: message,
      );
    }

    return const _TypingIndicatorBubble();
  }
}

// ── Welcome ───────────────────────────────────────────────────────────────────

final class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({
    required this.suggestions,
    required this.onSuggestionTap,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const _PulsingAiAvatar(size: 72),
          const SizedBox(height: 16),
          Text(
            'مساعدك الرياضي الذكي',
            style: context.highlightBold.copyWith(color: AppColors.neutral900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'اسأل ساندي عن التمارين، التغذية، أو اشتراكك',
            style: context.captionRegular.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: suggestions
                .map(
                  (s) => _SuggestionChip(
                    label: s,
                    onTap: () => onSuggestionTap(s),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

final class _SuggestionChip extends StatefulWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

final class _SuggestionChipState extends State<_SuggestionChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary200),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: context.captionRegular.copyWith(color: AppColors.primary800),
          ),
        ),
      ),
    );
  }
}

// ── Messages ──────────────────────────────────────────────────────────────────

final class _AnimatedMessageBubble extends StatefulWidget {
  const _AnimatedMessageBubble({super.key, required this.message});

  final _ChatMessage message;

  @override
  State<_AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

final class _AnimatedMessageBubbleState extends State<_AnimatedMessageBubble>
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
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(widget.message.isUser ? -0.08 : 0.08, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _scale = Tween<double>(begin: 0.92, end: 1).animate(
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
          alignment: widget.message.isUser
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: widget.message.isUser
                ? _UserBubble(message: widget.message)
                : _AiBubble(message: widget.message),
          ),
        ),
      ),
    );
  }
}

final class _AiBubble extends StatelessWidget {
  const _AiBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.72,
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
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
                    message.text,
                    style: context.captionRegular.copyWith(
                      color: AppColors.neutral900,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message.time,
                    style: context.footnoteRegular.copyWith(
                      color: AppColors.neutral400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          const _AiAvatar(size: 34),
        ],
      ),
    );
  }
}

final class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
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
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
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
              message.text,
              style: context.captionRegular.copyWith(
                color: AppColors.white,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  message.time,
                  style: context.footnoteRegular.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  message.isRead ? Iconsax.tick_circle5 : Iconsax.tick_circle,
                  size: 14,
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ],
            ),
          ],
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
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: const _TypingDots(),
            ),
            const SizedBox(width: 8),
            const _AiAvatar(size: 34),
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
            final value = math.sin((_controller.value * math.pi * 2) + delay);
            final offset = (value + 1) * 3;

            return Padding(
              padding: EdgeInsetsDirectional.only(start: index == 0 ? 0 : 6),
              child: Transform.translate(
                offset: Offset(0, -offset),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: 0.35 + (value + 1) * 0.25,
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

final class _PulsingAiAvatar extends StatefulWidget {
  const _PulsingAiAvatar({required this.size});

  final double size;

  @override
  State<_PulsingAiAvatar> createState() => _PulsingAiAvatarState();
}

final class _PulsingAiAvatarState extends State<_PulsingAiAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
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
      builder: (context, child) {
        final pulse = 1 + (_controller.value * 0.06);
        return Transform.scale(
          scale: pulse,
          child: Container(
            width: widget.size + 16,
            height: widget.size + 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(
                alpha: 0.08 + (_controller.value * 0.06),
              ),
            ),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: _AiAvatar(size: widget.size, showGlow: true),
    );
  }
}

final class _AiAvatar extends StatelessWidget {
  const _AiAvatar({required this.size, this.showGlow = false});

  final double size;
  final bool showGlow;

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
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : null,
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

// ── Input bar ─────────────────────────────────────────────────────────────────

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
  final VoidCallback onSend;

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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      margin: EdgeInsets.fromLTRB(16, 8, 16, bottomInset > 0 ? 8 : 16),
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
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
          _SendButton(enabled: widget.canSend, onTap: widget.onSend),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) {
                if (widget.canSend) widget.onSend();
              },
              style: context.captionRegular.copyWith(color: AppColors.neutral900),
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك لساندي AI',
                hintStyle: context.captionRegular.copyWith(
                  color: AppColors.neutral400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.microphone_2, color: AppColors.neutral400),
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
}

final class _SendButton extends StatefulWidget {
  const _SendButton({required this.enabled, required this.onTap});

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
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Iconsax.send_2,
            size: 20,
            color: widget.enabled ? AppColors.white : AppColors.neutral400,
          ),
        ),
      ),
    );
  }
}
