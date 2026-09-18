import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/num_spacing_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../subscription_questionnaire/presentation/widgets/questionnaire_choice_chip.dart';
import '../../../subscription_questionnaire/presentation/widgets/questionnaire_required_label.dart';
import '../../../subscription_questionnaire/presentation/widgets/questionnaire_yes_no_field.dart';
import '../../domain/entities/onboarding_question_entity.dart';
import '../utils/onboarding_question_logic.dart';

final class DynamicOnboardingQuestionField extends StatelessWidget {
  const DynamicOnboardingQuestionField({
    super.key,
    required this.question,
    required this.locale,
    required this.value,
    required this.onChanged,
    this.onUploadPhoto,
    this.onRemovePhoto,
    this.isUploading = false,
  });

  final OnboardingQuestionEntity question;
  final String locale;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;
  final Future<void> Function(String filePath)? onUploadPhoto;
  final ValueChanged<String>? onRemovePhoto;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return switch (question.type) {
      OnboardingQuestionType.text => _TextField(
          question: question,
          locale: locale,
          value: value,
          onChanged: onChanged,
          keyboardType: TextInputType.text,
        ),
      OnboardingQuestionType.number => _TextField(
          question: question,
          locale: locale,
          value: value,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
        ),
      OnboardingQuestionType.boolean => QuestionnaireYesNoField(
          label: question.labelFor(locale),
          value: value as bool?,
          required: question.required,
          onChanged: (next) => onChanged(next),
        ),
      OnboardingQuestionType.singleChoice => _SingleChoiceField(
          question: question,
          locale: locale,
          value: value as String?,
          onChanged: onChanged,
        ),
      OnboardingQuestionType.multiChoice => _MultiChoiceField(
          question: question,
          locale: locale,
          value: value as List<String>? ?? const [],
          onChanged: onChanged,
        ),
      OnboardingQuestionType.photo => _PhotoField(
          question: question,
          locale: locale,
          urls: value is List ? List<String>.from(value.cast<String>()) : const [],
          isUploading: isUploading,
          onPick: onUploadPhoto,
          onRemove: onRemovePhoto,
        ),
    };
  }
}

final class _TextField extends StatefulWidget {
  const _TextField({
    required this.question,
    required this.locale,
    required this.value,
    required this.onChanged,
    required this.keyboardType,
  });

  final OnboardingQuestionEntity question;
  final String locale;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;
  final TextInputType keyboardType;

  @override
  State<_TextField> createState() => _TextFieldState();
}

final class _TextFieldState extends State<_TextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant _TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextText = widget.value?.toString() ?? '';
    if (_controller.text != nextText) {
      _controller.text = nextText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireRequiredLabel(
          label: widget.question.labelFor(widget.locale),
          required: widget.question.required,
        ),
        8.vertical,
        TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: context.contentRegular.copyWith(color: AppColors.neutral1000),
          decoration: InputDecoration(
            hintText: 'قم بإدخال إجابتك',
            hintStyle: context.contentRegular.copyWith(
              color: AppColors.neutral400,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.neutral400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

final class _SingleChoiceField extends StatelessWidget {
  const _SingleChoiceField({
    required this.question,
    required this.locale,
    required this.value,
    required this.onChanged,
  });

  final OnboardingQuestionEntity question;
  final String locale;
  final String? value;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireRequiredLabel(
          label: question.labelFor(locale),
          required: question.required,
        ),
        8.vertical,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in question.options)
              QuestionnaireChoiceChip(
                label: OnboardingQuestionLogic.optionLabel(option, locale),
                selected: value == option.value,
                onTap: () => onChanged(option.value),
              ),
          ],
        ),
      ],
    );
  }
}

final class _MultiChoiceField extends StatelessWidget {
  const _MultiChoiceField({
    required this.question,
    required this.locale,
    required this.value,
    required this.onChanged,
  });

  final OnboardingQuestionEntity question;
  final String locale;
  final List<String> value;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireRequiredLabel(
          label: question.labelFor(locale),
          required: question.required,
        ),
        8.vertical,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in question.options)
              QuestionnaireChoiceChip(
                label: OnboardingQuestionLogic.optionLabel(option, locale),
                selected: value.contains(option.value),
                onTap: () {
                  final next = Set<String>.from(value);
                  if (next.contains(option.value)) {
                    next.remove(option.value);
                  } else {
                    next.add(option.value);
                  }
                  onChanged(next.toList());
                },
              ),
          ],
        ),
      ],
    );
  }
}

final class _PhotoField extends StatefulWidget {
  const _PhotoField({
    required this.question,
    required this.locale,
    required this.urls,
    required this.isUploading,
    this.onPick,
    this.onRemove,
  });

  final OnboardingQuestionEntity question;
  final String locale;
  final List<String> urls;
  final bool isUploading;
  final Future<void> Function(String filePath)? onPick;
  final ValueChanged<String>? onRemove;

  @override
  State<_PhotoField> createState() => _PhotoFieldState();
}

final class _PhotoFieldState extends State<_PhotoField> {
  static final _picker = ImagePicker();
  bool _isPicking = false;

  Future<void> _pick() async {
    if (widget.onPick == null || widget.isUploading || _isPicking) return;

    setState(() => _isPicking = true);
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;
      await widget.onPick!(image.path);
    } on PlatformException catch (error) {
      if (error.code != 'already_active') rethrow;
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = widget.isUploading || _isPicking;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestionnaireRequiredLabel(
          label: widget.question.labelFor(widget.locale),
          required: widget.question.required,
        ),
        8.vertical,
        if (widget.urls.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final url in widget.urls)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 88,
                          height: 88,
                          color: AppColors.neutral200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                    ),
                    if (widget.onRemove != null)
                      PositionedDirectional(
                        top: -6,
                        end: -6,
                        child: GestureDetector(
                          onTap: isBusy ? null : () => widget.onRemove!(url),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.red100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        if (widget.urls.isNotEmpty) 12.vertical,
        GestureDetector(
          onTap: isBusy ? null : _pick,
          child: DottedBorder(
            options: const RoundedRectDottedBorderOptions(
              radius: Radius.circular(8),
              color: AppColors.neutral400,
              strokeWidth: 1,
              dashPattern: [6, 4],
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              color: AppColors.white,
              child: Column(
                children: [
                  if (isBusy)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    const Icon(Icons.add_a_photo_outlined, color: AppColors.primary),
                  8.vertical,
                  Text(
                    isBusy ? 'جاري الرفع...' : 'إضافة صورة',
                    style: context.captionRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
