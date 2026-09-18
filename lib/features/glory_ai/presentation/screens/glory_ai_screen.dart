import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/utils/camera_permission_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../coach_chat/presentation/utils/chat_time_formatter.dart';
import '../../domain/entities/sandy_entities.dart';
import '../cubits/sandy_chat/sandy_chat_cubit.dart';
import '../widgets/sandy_attach_sheet.dart';
import '../widgets/sandy_document_submit_sheet.dart';

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

  Future<void> _handleAttach() async {
    if (context.read<SandyChatCubit>().state.isBusy) return;

    final source = await SandyAttachSheet.show(context);
    if (source == null || !mounted) return;

    final path = await _pickFile(source);
    if (path == null || !mounted) return;

    final submit = await SandyDocumentSubmitSheet.show(
      context,
      filePath: path,
    );
    if (submit == null || !mounted) return;

    await context.read<SandyChatCubit>().analyzeDocument(
          filePath: path,
          note: submit.note,
        );
    _scrollToBottom();
  }

  Future<String?> _pickFile(SandyAttachSource source) async {
    try {
      switch (source) {
        case SandyAttachSource.gallery:
          final image = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          );
          return image?.path;
        case SandyAttachSource.camera:
          final granted = await CameraPermissionUtils.ensureGranted(context);
          if (!granted || !mounted) return null;
          final image = await ImagePicker().pickImage(
            source: ImageSource.camera,
            imageQuality: 85,
          );
          return image?.path;
        case SandyAttachSource.pdf:
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: const ['pdf'],
          );
          return result?.files.single.path;
      }
    } catch (_) {
      return null;
    }
  }

  Future<void> _openHealthFiles() async {
    await context.push(AppRoutes.sandyHealthFiles);
    if (!mounted) return;
    await context.read<SandyChatCubit>().refreshTrainingCaution();
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
          previous.messages != current.messages ||
          previous.isTyping != current.isTyping ||
          previous.isStreaming != current.isStreaming ||
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
          appBar: const _SandyChatHeader(),
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
                _SandyActionsBar(
                  enabled: !state.isBusy,
                  onNewChat: () =>
                      context.read<SandyChatCubit>().startNewConversation(),
                  onHistory: () => context.push(AppRoutes.sandyConversations),
                  onHealthFiles: _openHealthFiles,
                ),
                if (state.hasTrainingCaution) const _TrainingCautionBanner(),
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
                  canSend: _canSend && !state.isBusy,
                  canAttach: !state.isBusy,
                  onSend: _handleSend,
                  onAttach: _handleAttach,
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
        return const _SandyWelcomeCard();
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

final class _TrainingCautionBanner extends StatelessWidget {
  const _TrainingCautionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.red10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red100.withValues(alpha: 0.4)),
      ),
      child: Text(
        context.l10n.sandyTrainingCautionBanner,
        style: context.footnoteRegular.copyWith(
          color: AppColors.red200,
          height: 1.45,
        ),
      ),
    );
  }
}

final class _FlagNote extends StatelessWidget {
  const _FlagNote({required this.flag});

  final SandyMedicalFlagEntity flag;

  @override
  Widget build(BuildContext context) {
    final isHigh = flag.severity == SandyFlagSeverity.high;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isHigh ? AppColors.red10 : AppColors.primary100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          [
            if (flag.area != null && flag.area!.isNotEmpty) flag.area,
            flag.note,
          ].whereType<String>().join(' — '),
          style: context.footnoteRegular.copyWith(
            color: isHigh ? AppColors.red200 : AppColors.primary800,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

final class _MessageAttachment extends StatelessWidget {
  const _MessageAttachment({
    required this.url,
    required this.isImage,
    this.label,
    this.onDark = false,
  });

  final String url;
  final String? label;
  final bool isImage;
  final bool onDark;

  bool get _isRemote =>
      url.startsWith('http://') || url.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (!isImage) {
      return Row(
        children: [
          Icon(
            Iconsax.document_text,
            size: 18,
            color: onDark ? AppColors.white : AppColors.primary800,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label ?? url.split('/').last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.footnoteRegular.copyWith(
                color: onDark ? AppColors.white : AppColors.neutral800,
              ),
            ),
          ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: _isRemote
            ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover)
            : Image.file(File(url), fit: BoxFit.cover),
      ),
    );
  }
}

final class _SandyChatHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const _SandyChatHeader();

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      backgroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.22),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.55),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/svgs/ai_icon.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.sandyAi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.highlightBold.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.sandyAiSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.footnoteRegular.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _SandyActionsBar extends StatelessWidget {
  const _SandyActionsBar({
    required this.enabled,
    required this.onNewChat,
    required this.onHistory,
    required this.onHealthFiles,
  });

  final bool enabled;
  final VoidCallback onNewChat;
  final VoidCallback onHistory;
  final VoidCallback onHealthFiles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: _SandyActionChip(
              icon: Iconsax.add,
              label: context.l10n.sandyToolbarNew,
              tooltip: context.l10n.sandyNewChat,
              onTap: enabled ? onNewChat : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SandyActionChip(
              icon: Iconsax.message_text_1,
              label: context.l10n.sandyToolbarHistory,
              tooltip: context.l10n.sandyChatHistory,
              onTap: onHistory,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SandyActionChip(
              icon: Iconsax.document,
              label: context.l10n.sandyToolbarFiles,
              tooltip: context.l10n.sandyHealthFiles,
              onTap: onHealthFiles,
            ),
          ),
        ],
      ),
    );
  }
}

final class _SandyActionChip extends StatelessWidget {
  const _SandyActionChip({
    required this.icon,
    required this.label,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16, color: AppColors.primary800),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.footnoteRegular.copyWith(
                        color: AppColors.neutral800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _SandyWelcomeCard extends StatelessWidget {
  const _SandyWelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary200),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            const _AiAvatar(size: 52),
            const SizedBox(height: 12),
            Text(
              context.l10n.sandyWelcomeTitle,
              textAlign: TextAlign.center,
              style: context.highlightBold.copyWith(color: AppColors.neutral900),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.sandyWelcomeBody,
              textAlign: TextAlign.center,
              style: context.captionRegular.copyWith(
                color: AppColors.neutral600,
                height: 1.55,
              ),
            ),
          ],
        ),
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
          ? _UserBubbleContent(
              body: message.body,
              time: time,
              attachmentUrl: message.attachmentUrl,
              attachmentLabel: message.attachmentLabel,
              attachmentIsImage: message.attachmentIsImage,
            )
          : _AiBubbleContent(
              body: message.body,
              time: time,
              citations: message.citations,
              flags: message.flags,
              isMedicalGuidance: message.isMedicalGuidance,
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
    this.flags = const [],
    this.isMedicalGuidance = false,
    this.onRetry,
    this.onContactCoach,
  });

  final String body;
  final String time;
  final List<SandyCitationEntity> citations;
  final List<SandyMedicalFlagEntity> flags;
  final bool isMedicalGuidance;
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
                      SelectableText(
                        body,
                        textDirection: intl.Bidi.detectRtlDirectionality(body)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: context.captionRegular.copyWith(
                          color: AppColors.neutral900,
                          height: 1.55,
                        ),
                      ),
                      if (isMedicalGuidance) ...[
                        const SizedBox(height: 10),
                        Text(
                          context.l10n.sandyNotADiagnosis,
                          style: context.footnoteRegular.copyWith(
                            color: AppColors.neutral500,
                            height: 1.4,
                          ),
                        ),
                      ],
                      if (flags.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ...flags.map((flag) => _FlagNote(flag: flag)),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _CopyMessageButton(text: body),
                          const Spacer(),
                          Text(
                            time,
                            style: context.footnoteRegular.copyWith(
                              color: AppColors.neutral400,
                            ),
                          ),
                        ],
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
  const _UserBubbleContent({
    required this.body,
    required this.time,
    this.attachmentUrl,
    this.attachmentLabel,
    this.attachmentIsImage = false,
  });

  final String body;
  final String time;
  final String? attachmentUrl;
  final String? attachmentLabel;
  final bool attachmentIsImage;

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
            if (attachmentUrl != null && attachmentUrl!.isNotEmpty) ...[
              _MessageAttachment(
                url: attachmentUrl!,
                label: attachmentLabel,
                isImage: attachmentIsImage,
                onDark: true,
              ),
              const SizedBox(height: 8),
            ],
            SelectableText(
              body,
              textDirection: intl.Bidi.detectRtlDirectionality(body)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: context.captionRegular.copyWith(
                color: AppColors.white,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _CopyMessageButton(text: body, onDark: true),
                const Spacer(),
                Text(
                  time,
                  style: context.footnoteRegular.copyWith(
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _CopyMessageButton extends StatelessWidget {
  const _CopyMessageButton({required this.text, this.onDark = false});

  final String text;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    final color = onDark
        ? AppColors.white.withValues(alpha: 0.85)
        : AppColors.neutral400;

    return Tooltip(
      message: context.l10n.sandyCopyMessage,
      child: InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: text.trim()));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.l10n.sandyMessageCopied)),
            );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.copy, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                context.l10n.sandyCopyShort,
                style: context.footnoteRegular.copyWith(color: color),
              ),
            ],
          ),
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
    required this.canAttach,
    required this.onSend,
    required this.onAttach,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool canSend;
  final bool canAttach;
  final ValueChanged<String> onSend;
  final VoidCallback onAttach;

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
          _AttachButton(
            enabled: widget.canAttach,
            onTap: widget.onAttach,
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.start,
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

final class _AttachButton extends StatelessWidget {
  const _AttachButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      tooltip: context.l10n.sandyUploadMedicalFile,
      icon: Icon(
        Iconsax.paperclip,
        color: enabled ? AppColors.primary800 : AppColors.neutral400,
        size: 20,
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
