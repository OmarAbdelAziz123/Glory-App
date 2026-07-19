import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/models/otp_args.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/login_terms_row.dart';
import '../widgets/register_header.dart';

final class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  final _usernameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool _termsAccepted = false;
  String? _usernameError;
  String? _phoneError;
  String? _emailError;

  bool get _canSubmit =>
      _usernameCtrl.text.isNotEmpty &&
      _phoneCtrl.text.isNotEmpty &&
      _emailCtrl.text.isNotEmpty &&
      _termsAccepted;

  void _onOtpPressed() {
    final usernameErr = AppValidators.required(_usernameCtrl.text);
    final phoneErr = AppValidators.phone(_phoneCtrl.text);
    final emailErr = AppValidators.email(_emailCtrl.text);

    setState(() {
      _usernameError = usernameErr;
      _phoneError = phoneErr;
      _emailError = emailErr;
    });

    if (usernameErr == null && phoneErr == null && emailErr == null) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (!context.mounted) return;
      context.pushNamed(
        'otp',
        extra: OtpArgs(
          email: _emailCtrl.text.trim(),
          source: OtpSource.register,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _usernameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
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
                    const RegisterHeader(),
                    24.vertical,
                    AppTextField(
                      label: 'اسم المستخدم',
                      controller: _usernameCtrl,
                      focusNode: _usernameFocus,
                      hint: 'قم بإدخال اسم المستخدم الخاصة بك',
                      textInputAction: TextInputAction.next,
                      errorMessage: _usernameError,
                      onChanged: (_) => setState(() => _usernameError = null),
                      onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                    ),
                    16.vertical,
                    AppPhoneField(
                      label: 'رقم الهاتف',
                      controller: _phoneCtrl,
                      focusNode: _phoneFocus,
                      hint: 'قم بإدخال او رقم الهاتف الخاصة بك',
                      textInputAction: TextInputAction.next,
                      errorMessage: _phoneError,
                      onChanged: (_) => setState(() => _phoneError = null),
                    ),
                    16.vertical,
                    AppTextField(
                      label: 'البريد الإلكتروني',
                      controller: _emailCtrl,
                      focusNode: _emailFocus,
                      hint: 'قم بإدخال بريدك الإلكتروني الخاصة بك',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      errorMessage: _emailError,
                      onChanged: (_) => setState(() => _emailError = null),
                    ),
                    10.vertical,
                    LoginTermsRow(
                      accepted: _termsAccepted,
                      onToggle: () =>
                          setState(() => _termsAccepted = !_termsAccepted),
                    ),
                    16.vertical,
                    const AppDividerLabel(label: 'تسجيل الدخول سريع مع'),
                    16.vertical,
                    AppSocialLoginRow(onApple: () {}, onGoogle: () {}),
                    24.vertical,
                  ],
                ),
              ),
            ),
            _BottomSection(
              canSubmit: _canSubmit,
              onOtp: _onOtpPressed,
              onLogin: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private widgets ─────────────────────────────────────────────────────────

final class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.canSubmit,
    required this.onOtp,
    required this.onLogin,
  });

  final bool canSubmit;
  final VoidCallback onOtp;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AlreadyHaveAccountRow(onLogin: onLogin),
          16.vertical,
          AppButton(label: 'طلب OTP', onPressed: canSubmit ? onOtp : null),
        ],
      ),
    );
  }
}

final class _AlreadyHaveAccountRow extends StatefulWidget {
  const _AlreadyHaveAccountRow({required this.onLogin});

  final VoidCallback onLogin;

  @override
  State<_AlreadyHaveAccountRow> createState() => _AlreadyHaveAccountRowState();
}

final class _AlreadyHaveAccountRowState extends State<_AlreadyHaveAccountRow> {
  late final TapGestureRecognizer _loginRecognizer;

  @override
  void initState() {
    super.initState();
    _loginRecognizer = TapGestureRecognizer()..onTap = widget.onLogin;
  }

  @override
  void didUpdateWidget(_AlreadyHaveAccountRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loginRecognizer.onTap = widget.onLogin;
  }

  @override
  void dispose() {
    _loginRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: context.captionRegular.copyWith(color: AppColors.neutral400),
        children: [
          const TextSpan(text: 'لدي حساب بالفعل ؟ '),
          TextSpan(
            text: 'تسجيل دخول',
            recognizer: _loginRecognizer,
            style: context.subtitleMedium.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
