import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glory_gym/core/models/otp_args.dart';
import 'package:glory_gym/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

import 'create_password_screen.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/otp_header.dart';

final class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.args});

  final OtpArgs? args;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

final class _OtpScreenState extends State<OtpScreen> {
  String _otpValue = '';
  int _secondsLeft = 60;
  Timer? _timer;

  bool get _canConfirm => _otpValue.length == 6;
  bool get _canResend => _secondsLeft == 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onResend() {
    if (!_canResend) return;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onConfirm() {
    final isRegister = widget.args?.source == OtpSource.register;
    context.push(
      AppRoutes.createPassword,
      extra: isRegister
          ? CreatePasswordMode.register
          : CreatePasswordMode.forgotPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.args?.email ?? '';
    final displayEmail = email.isNotEmpty ? email : 'example@mail.com';
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBackHeader(title: 'رمز التحقق'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    32.vertical,
                    OtpHeader(
                      email: displayEmail,
                      onChangeEmail: () => context.pop(),
                    ),
                    32.vertical,
                    AppOtpField(
                      length: 6,
                      onCompleted: (v) => setState(() => _otpValue = v),
                      onChanged: (v) => setState(() => _otpValue = v),
                    ),
                    24.vertical,
                    _CantAccessEmailRow(onSendToPhone: () {}),
                    24.vertical,
                  ],
                ),
              ),
            ),
            _BottomSection(
              secondsLeft: _secondsLeft,
              canResend: _canResend,
              canConfirm: _canConfirm,
              onResend: _onResend,
              onConfirm: _onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private widgets ─────────────────────────────────────────────────────────

final class _CantAccessEmailRow extends StatelessWidget {
  const _CantAccessEmailRow({required this.onSendToPhone});

  final VoidCallback onSendToPhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'لا تستطيع الوصول إلى بريدك الإلكتروني الآن؟',
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onSendToPhone,
          child: Text(
            'أرسل الرمز إلى رقم هاتفك',
            style: context.subtitleMedium.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

final class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.secondsLeft,
    required this.canResend,
    required this.canConfirm,
    required this.onResend,
    required this.onConfirm,
  });

  final int secondsLeft;
  final bool canResend;
  final bool canConfirm;
  final VoidCallback onResend;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CountdownResendRow(
            secondsLeft: secondsLeft,
            canResend: canResend,
            onResend: onResend,
          ),
          16.vertical,
          AppButton(label: 'تأكيد', onPressed: canConfirm ? onConfirm : null),
        ],
      ),
    );
  }
}

final class _CountdownResendRow extends StatefulWidget {
  const _CountdownResendRow({
    required this.secondsLeft,
    required this.canResend,
    required this.onResend,
  });

  final int secondsLeft;
  final bool canResend;
  final VoidCallback onResend;

  @override
  State<_CountdownResendRow> createState() => _CountdownResendRowState();
}

final class _CountdownResendRowState extends State<_CountdownResendRow> {
  late final TapGestureRecognizer _tapRecognizer;

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        if (widget.canResend) widget.onResend();
      };
  }

  @override
  void didUpdateWidget(_CountdownResendRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tapRecognizer.onTap = () {
      if (widget.canResend) widget.onResend();
    };
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerText = widget.secondsLeft.toString().padLeft(2, '0');
    return RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: context.captionRegular.copyWith(color: AppColors.neutral500),
        children: [
          TextSpan(text: 'ستنتهي صلاحية الكود خلال ( $timerText ثانية ) '),
          TextSpan(
            text: 'إعادة إرسال',
            recognizer: _tapRecognizer,
            style: context.captionRegular.copyWith(
              color: widget.canResend
                  ? AppColors.primary
                  : AppColors.neutral400,
              decoration: widget.canResend ? TextDecoration.underline : null,
              decorationColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
