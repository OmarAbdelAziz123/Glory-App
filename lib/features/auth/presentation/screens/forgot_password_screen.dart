import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/models/otp_args.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubits/forgot_password/forgot_password_cubit.dart';
import '../widgets/forgot_password_header.dart';

final class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

final class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailOrPhoneCtrl = TextEditingController();
  String? _emailError;

  bool get _canSubmit => _emailOrPhoneCtrl.text.isNotEmpty;

  void _onOtpPressed(BuildContext context) {
    final error = AppValidators.emailOrPhone(_emailOrPhoneCtrl.text);
    setState(() => _emailError = error);
    if (error != null) return;

    FocusManager.instance.primaryFocus?.unfocus();
    context.read<ForgotPasswordCubit>().requestOtp(
          identifier: _emailOrPhoneCtrl.text.trim(),
        );
  }

  @override
  void dispose() {
    _emailOrPhoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPasswordCubit>(),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }

          if (state.status == ForgotPasswordStatus.success &&
              state.otpSent != null) {
            final otp = state.otpSent!;
            context.push(
              AppRoutes.otp,
              extra: OtpArgs(
                email: otp.email,
                source: OtpSource.forgotPassword,
                purpose: otp.purpose,
                expiresInSeconds: otp.expiresInSeconds,
                resendCooldownSeconds: otp.resendCooldownSeconds,
              ),
            );
            context.read<ForgotPasswordCubit>().reset();
          }
        },
        child: AppScaffold(
          resizeToAvoidBottomInset: true,
          appBar: const AppBackHeader(),
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
                        const ForgotPasswordHeader(),
                        32.vertical,
                        AppTextField(
                          label: 'البريد الإلكتروني او رقم الهاتف',
                          controller: _emailOrPhoneCtrl,
                          hint:
                              'قم بإدخال بريدك الإلكتروني او رقم الهاتف الخاصة بك',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          errorMessage: _emailError,
                          onChanged: (_) => setState(() => _emailError = null),
                          onFieldSubmitted: (_) => _onOtpPressed(context),
                        ),
                        24.vertical,
                      ],
                    ),
                  ),
                ),
                BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                  builder: (context, state) => _BottomSection(
                    canSubmit: _canSubmit,
                    isLoading: state.isLoading,
                    onOtp: () => _onOtpPressed(context),
                    onCreateAccount: () => context.push(AppRoutes.register),
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

final class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.canSubmit,
    required this.isLoading,
    required this.onOtp,
    required this.onCreateAccount,
  });

  final bool canSubmit;
  final bool isLoading;
  final VoidCallback onOtp;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CreateAccountRow(onTap: onCreateAccount),
          16.vertical,
          AppButton(
            label: 'طلب OTP',
            isLoading: isLoading,
            onPressed: canSubmit && !isLoading ? onOtp : null,
          ),
        ],
      ),
    );
  }
}

final class _CreateAccountRow extends StatelessWidget {
  const _CreateAccountRow({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب ؟',
          style: context.captionRegular.copyWith(color: AppColors.neutral400),
        ),
        4.horizontal,
        GestureDetector(
          onTap: onTap,
          child: Text(
            'إنشاء حساب',
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
