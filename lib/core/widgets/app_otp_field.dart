import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

final class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

final class _AppOtpFieldState extends State<AppOtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentValue => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final target =
          (digits.length < widget.length) ? digits.length : widget.length - 1;
      _focusNodes[target].requestFocus();
    } else if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    final current = _currentValue;
    widget.onChanged?.call(current);
    if (current.length == widget.length) {
      widget.onCompleted(current);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 50,
          height: 50,
          child: _OtpBox(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (v) => _onChanged(index, v),
            onKeyEvent: (e) => _onKeyEvent(index, e),
          ),
        );
      }),
    );
  }
}

final class _OtpBox extends StatefulWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

final class _OtpBoxState extends State<_OtpBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_rebuild);
  }

  void _onFocusChange() => setState(() => _focused = widget.focusNode.hasFocus);
  void _rebuild() => setState(() {});

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;
    final borderColor =
        _focused ? AppColors.primary : AppColors.neutral1000;
    final lineColor =
        (_focused || text.isNotEmpty) ? AppColors.primary : AppColors.neutral1000;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: widget.onKeyEvent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: _focused ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Invisible TextField — handles focus, keyboard, input only
            Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                onChanged: widget.onChanged,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                showCursor: false,
                enableInteractiveSelection: false,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 1),
                buildCounter:
                    (_, {required currentLength, required isFocused, maxLength}) =>
                        null,
                decoration: const InputDecoration.collapsed(hintText: ''),
              ),
            ),
            // Visual layer — digit + underline
            IgnorePointer(
              child: text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            text,
                            style: Styles.captionRegular(context).copyWith(
                              color: AppColors.neutral1000,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 12,
                            height: 1.5,
                            decoration: BoxDecoration(
                              color: lineColor,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Container(
                        width: 12,
                        height: 1.5,
                        decoration: BoxDecoration(
                          color: lineColor,
                          borderRadius: BorderRadius.circular(1),
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
