import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/models/otp_args.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubits/otp/otp_cubit.dart';
import '../widgets/otp_header.dart';
import '../../../../core/l10n/l10n_extension.dart';

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
    _secondsLeft = widget.args?.expiresInSeconds ?? 60;
    _startTimer(_secondsLeft);
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onResend(BuildContext context) {
    if (!_canResend) return;
    final email = widget.args?.email;
    final purpose = widget.args?.purpose;
    if (email == null || purpose == null) return;

    context.read<OtpCubit>().resendOtp(email: email, purpose: purpose);
  }

  void _onConfirm(BuildContext context) {
    final email = widget.args?.email;
    final purpose = widget.args?.purpose;
    if (email == null || purpose == null || _otpValue.length != 6) return;

    context.read<OtpCubit>().verifyOtp(
          email: email,
          purpose: purpose,
          code: _otpValue,
        );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.args?.email ?? '';
    final displayEmail = email.isNotEmpty ? email : 'example@mail.com';

    return BlocProvider(
      create: (_) => sl<OtpCubit>(),
      child: BlocListener<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state.status == OtpStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
            context.read<OtpCubit>().resetActionStatus();
          }

          if (state.status == OtpStatus.verified &&
              state.verifyResult != null) {
            final isRegister = widget.args?.source == OtpSource.register;
            context.push(
              AppRoutes.createPassword,
              extra: CreatePasswordArgs(
                mode: isRegister
                    ? CreatePasswordMode.register
                    : CreatePasswordMode.forgotPassword,
                otpToken: state.verifyResult!.otpToken,
              ),
            );
            context.read<OtpCubit>().resetActionStatus();
          }

          if (state.status == OtpStatus.resent && state.otpSent != null) {
            _startTimer(state.otpSent!.resendCooldownSeconds);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.verificationCodeResent)),
            );
            context.read<OtpCubit>().resetActionStatus();
          }
        },
        child: AppScaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBackHeader(title: context.l10n.verificationCode),
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
                        const _CantAccessEmailRow(onSendToPhone: null),
                        24.vertical,
                      ],
                    ),
                  ),
                ),
                BlocBuilder<OtpCubit, OtpState>(
                  builder: (context, state) => _BottomSection(
                    secondsLeft: _secondsLeft,
                    canResend: _canResend && !state.isResending,
                    canConfirm: _canConfirm,
                    isVerifying: state.isVerifying,
                    isResending: state.isResending,
                    onResend: () => _onResend(context),
                    onConfirm: () => _onConfirm(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Private widgets ─────────────────────────────────────────────────────────

final class _CantAccessEmailRow extends StatelessWidget {
  const _CantAccessEmailRow({required this.onSendToPhone});

  final VoidCallback? onSendToPhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.cannotAccessEmailNow,
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onSendToPhone,
          child: Text(
            context.l10n.sendCodeToPhone,
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
    required this.isVerifying,
    required this.isResending,
    required this.onResend,
    required this.onConfirm,
  });

  final int secondsLeft;
  final bool canResend;
  final bool canConfirm;
  final bool isVerifying;
  final bool isResending;
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
            isResending: isResending,
            onResend: onResend,
          ),
          16.vertical,
          AppButton(
            label: context.l10n.confirm,
            isLoading: isVerifying,
            onPressed: canConfirm && !isVerifying ? onConfirm : null,
          ),
        ],
      ),
    );
  }
}

final class _CountdownResendRow extends StatefulWidget {
  const _CountdownResendRow({
    required this.secondsLeft,
    required this.canResend,
    required this.isResending,
    required this.onResend,
  });

  final int secondsLeft;
  final bool canResend;
  final bool isResending;
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
        if (widget.canResend && !widget.isResending) widget.onResend();
      };
  }

  @override
  void didUpdateWidget(_CountdownResendRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tapRecognizer.onTap = () {
      if (widget.canResend && !widget.isResending) widget.onResend();
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isResending)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        if (widget.isResending) 8.horizontal,
        Flexible(
          child: RichText(
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style:
                  context.captionRegular.copyWith(color: AppColors.neutral500),
              children: [
                TextSpan(
                  text: context.l10n.codeExpiresInTimer(timerText),
                ),
                TextSpan(
                  text: context.l10n.resend,
                  recognizer: _tapRecognizer,
                  style: context.captionRegular.copyWith(
                    color: widget.canResend
                        ? AppColors.primary
                        : AppColors.neutral400,
                    decoration:
                        widget.canResend ? TextDecoration.underline : null,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
