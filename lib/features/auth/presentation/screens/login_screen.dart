import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/l10n/locale_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/utils/onboarding_navigation.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubits/login/login_cubit.dart';
import '../cubits/user_profile/user_profile_cubit.dart';
import '../widgets/login_header.dart';
import '../widgets/login_terms_row.dart';
import 'package:glory_gym/core/l10n/l10n.dart';

final class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final class _LoginScreenState extends State<LoginScreen> {
  final _emailOrPhoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _termsAccepted = false;
  String? _emailError;
  String? _passwordError;

  bool get _canLogin =>
      _emailOrPhoneCtrl.text.isNotEmpty &&
      _passwordCtrl.text.isNotEmpty &&
      _termsAccepted;

  void _onLoginPressed(BuildContext context) {
    setState(() {
      _emailError =
          AppValidators.emailOrPhone(context.l10n, _emailOrPhoneCtrl.text);
      _passwordError = AppValidators.password(context.l10n, _passwordCtrl.text);
    });

    if (_emailError != null || _passwordError != null) return;

    context.read<LoginCubit>().login(
          identifier: _emailOrPhoneCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  @override
  void dispose() {
    _emailOrPhoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }

          if (state.status == LoginStatus.success) {
            final session = state.session;
            if (session != null) {
              context.read<UserProfileCubit>().setMember(session.member);
              unawaited(LocaleService.syncFromMember(session.member));
            }
            unawaited(context.read<UserProfileCubit>().fetchProfile());
            unawaited(
              navigateAfterAuthentication(
                context,
                onboardingCompleted: session?.member.onboardingCompleted,
              ),
            );
            context.read<LoginCubit>().reset();
          }
        },
        child: AppScaffold(
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
                        const LoginHeader(),
                        24.vertical,
                        AppTextField(
                          label: context.l10n.emailOrPhone,
                          controller: _emailOrPhoneCtrl,
                          hint:
                              context.l10n.enterYourEmailOrPhone,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          errorMessage: _emailError,
                          onChanged: (_) => setState(() => _emailError = null),
                        ),
                        16.vertical,
                        AppPasswordField(
                          label: context.l10n.password,
                          controller: _passwordCtrl,
                          hint: context.l10n.enterYourPassword,
                          textInputAction: TextInputAction.done,
                          errorMessage: _passwordError,
                          onChanged: (_) =>
                              setState(() => _passwordError = null),
                        ),
                        10.vertical,
                        LoginTermsRow(
                          accepted: _termsAccepted,
                          onToggle: () =>
                              setState(() => _termsAccepted = !_termsAccepted),
                        ),
                        // 10.vertical,
                        // _ForgotPasswordLink(
                        //   onTap: () => context.push(AppRoutes.forgotPassword),
                        // ),
                        16.vertical,
                        // AppDividerLabel(label: context.l10n.quickLoginWith),
                        // 16.vertical,
                        // AppSocialLoginRow(onApple: () {}, onGoogle: () {}),
                        24.vertical,
                      ],
                    ),
                  ),
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) => _BottomSection(
                    canLogin: _canLogin,
                    isLoading: state.isLoading,
                    onLogin: () => _onLoginPressed(context),
                    // onCreateAccount: () => context.push(AppRoutes.register),
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

final class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          context.l10n.forgotPassword,
          style: context.captionRegular.copyWith(
            color: AppColors.primary,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

final class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.canLogin,
    required this.isLoading,
    required this.onLogin,
    // required this.onCreateAccount,
  });

  final bool canLogin;
  final bool isLoading;
  final VoidCallback onLogin;
  // final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // _CreateAccountRow(onTap: onCreateAccount),
          // 16.vertical,
          AppButton(
            label: context.l10n.login,
            isLoading: isLoading,
            onPressed: canLogin && !isLoading ? onLogin : null,
          ),
        ],
      ),
    );
  }
}

// final class _CreateAccountRow extends StatelessWidget {
//   const _CreateAccountRow({required this.onTap});
//
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           context.l10n.dontHaveAccountPrefix,
//           style: context.captionRegular.copyWith(color: AppColors.neutral400),
//         ),
//         4.horizontal,
//         GestureDetector(
//           onTap: onTap,
//           child: Text(
//             context.l10n.createAccount,
//             style: context.subtitleMedium.copyWith(
//               color: AppColors.primary,
//               decoration: TextDecoration.underline,
//               decorationColor: AppColors.primary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
