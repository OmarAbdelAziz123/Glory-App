import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';

// ── Data models ───────────────────────────────────────────────────────────────

enum _Sender { ai, user }

final class _Message {
  const _Message({
    required this.text,
    required this.time,
    required this.sender,
    this.isRead = false,
  });
  final String text;
  final String time;
  final _Sender sender;
  final bool isRead;
}

final class _ChatGroup {
  const _ChatGroup({this.dateLabel, required this.messages});
  final String? dateLabel;
  final List<_Message> messages;
}

// ── Screen ────────────────────────────────────────────────────────────────────

final class GloryAiScreen extends StatefulWidget {
  const GloryAiScreen({super.key});

  @override
  State<GloryAiScreen> createState() => _GloryAiScreenState();
}

final class _GloryAiScreenState extends State<GloryAiScreen> {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();

  static const _groups = [
    _ChatGroup(
      messages: [
        _Message(text: 'السلام عليكم', time: '10:10', sender: _Sender.ai),
        _Message(
          text: 'مرحباً منى، وصلتني رسالة من المورّد بخصوص عرض الأسعار.',
          time: '10:10',
          sender: _Sender.ai,
        ),
      ],
    ),
    _ChatGroup(
      dateLabel: 'اليوم',
      messages: [
        _Message(
          text: 'و عليكم السلام',
          time: '10:10',
          sender: _Sender.user,
          isRead: true,
        ),
        _Message(
          text: 'تمام، هل تم رفعه على النظام؟',
          time: '10:11',
          sender: _Sender.user,
        ),
        _Message(text: 'السلام عليكم', time: '10:10', sender: _Sender.ai),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'جلوري AI',
        showBack: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _groups.length,
              itemBuilder: (_, groupIndex) {
                final group = _groups[groupIndex];
                return Column(
                  children: [
                    if (group.dateLabel != null) ...[
                      const SizedBox(height: 8),
                      _DateSeparator(label: group.dateLabel!),
                      const SizedBox(height: 8),
                    ],
                    ...group.messages.map(
                      (msg) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: msg.sender == _Sender.ai
                            ? _AiBubble(message: msg)
                            : _UserBubble(message: msg),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _InputBar(controller: _inputController),
        ],
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.neutral300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: context.captionRegular.copyWith(color: AppColors.neutral500),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.neutral300)),
      ],
    );
  }
}

final class _AiBubble extends StatelessWidget {
  const _AiBubble({required this.message});

  final _Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AiAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.68,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: context.captionRegular.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: context.footnoteRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final _Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.68,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: context.captionRegular.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: context.footnoteRegular.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  message.isRead ? Iconsax.tick_circle : Iconsax.tick_square,
                  size: 14,
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _AiAvatar extends StatelessWidget {
  const _AiAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary100,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: const Center(
        child: Icon(Iconsax.cpu, size: 18, color: AppColors.primary),
      ),
    );
  }
}

final class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              style: context.captionRegular,
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك لجلوري Ai',
                hintStyle: context.captionRegular.copyWith(
                  color: AppColors.neutral400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Iconsax.microphone, size: 22, color: AppColors.neutral400),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Iconsax.send_2, size: 20, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
