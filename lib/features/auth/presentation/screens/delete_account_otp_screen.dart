import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/models/delete_account_otp_args.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../coach_chat/data/datasources/coach_chat_socket_service.dart';
import '../../../coach_chat/presentation/cubits/coach_chat_unread/coach_chat_unread_cubit.dart';
import '../cubits/delete_account/delete_account_cubit.dart';
import '../cubits/user_profile/user_profile_cubit.dart';
import '../widgets/otp_header.dart';

final class DeleteAccountOtpScreen extends StatefulWidget {
  const DeleteAccountOtpScreen({super.key, this.args});

  final DeleteAccountOtpArgs? args;

  @override
  State<DeleteAccountOtpScreen> createState() => _DeleteAccountOtpScreenState();
}

final class _DeleteAccountOtpScreenState extends State<DeleteAccountOtpScreen> {
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
    context.read<DeleteAccountCubit>().resendOtp();
  }

  void _onConfirm(BuildContext context) {
    if (_otpValue.length != 6) return;
    context.read<DeleteAccountCubit>().confirmDeletion(_otpValue);
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
      create: (_) => sl<DeleteAccountCubit>(),
      child: BlocListener<DeleteAccountCubit, DeleteAccountState>(
        listenWhen: (previous, current) =>
            (current.status == DeleteAccountStatus.failure &&
                current.errorMessage != null) ||
            current.status == DeleteAccountStatus.deleted ||
            (previous.status == DeleteAccountStatus.resending &&
                current.status == DeleteAccountStatus.otpSent),
        listener: (context, state) {
          if (state.status == DeleteAccountStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
            context.read<DeleteAccountCubit>().resetActionStatus();
            return;
          }

          if (state.status == DeleteAccountStatus.deleted) {
            context.read<UserProfileCubit>().clear();
            sl<CoachChatSocketService>().disconnect();
            context.read<CoachChatUnreadCubit>().resetCount();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.accountDeletedSuccess)),
            );
            context.go(AppRoutes.register);
            return;
          }

          if (state.status == DeleteAccountStatus.otpSent &&
              state.otpSent != null) {
            _startTimer(state.otpSent!.resendCooldownSeconds);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.verificationCodeResent)),
            );
          }
        },
        child: AppScaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBackHeader(title: context.l10n.verifyIdentity),
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
                          onCompleted: (value) =>
                              setState(() => _otpValue = value),
                          onChanged: (value) =>
                              setState(() => _otpValue = value),
                        ),
                        24.vertical,
                      ],
                    ),
                  ),
                ),
                BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                  builder: (context, state) {
                    final isConfirming =
                        state.status == DeleteAccountStatus.confirming;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CountdownResendRow(
                            secondsLeft: _secondsLeft,
                            canResend: _canResend && !state.isResending,
                            isResending: state.isResending,
                            onResend: () => _onResend(context),
                          ),
                          16.vertical,
                          AppButton(
                            label: context.l10n.confirm,
                            isLoading: isConfirming,
                            onPressed: _canConfirm && !isConfirming
                                ? () => _onConfirm(context)
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
