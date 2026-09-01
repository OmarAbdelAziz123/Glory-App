import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/models/otp_args.dart';
import '../../../../core/models/questionnaire_args.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../features/onboarding/domain/entities/onboarding_prefill_entity.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubits/create_password/create_password_cubit.dart';
import '../cubits/user_profile/user_profile_cubit.dart';
import '../widgets/create_password_header.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({
    super.key,
    this.args,
  });

  final CreatePasswordArgs? args;

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

final class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool get _hasMinLength => _passwordCtrl.text.length >= 8;
  bool get _hasDigit => _passwordCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasLetter => _passwordCtrl.text.contains(RegExp(r'[a-zA-Z]'));
  bool get _passwordsMatch =>
      _confirmCtrl.text.isNotEmpty && _passwordCtrl.text == _confirmCtrl.text;

  bool get _canSubmit =>
      _hasMinLength && _hasDigit && _hasLetter && _passwordsMatch;

  CreatePasswordMode get _mode =>
      widget.args?.mode ?? CreatePasswordMode.forgotPassword;

  void _onConfirm(BuildContext context) {
    final otpToken = widget.args?.otpToken;
    if (otpToken == null || otpToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.invalidVerificationCode)),
      );
      return;
    }

    final cubit = context.read<CreatePasswordCubit>();
    if (_mode == CreatePasswordMode.register) {
      cubit.completeRegistration(
        otpToken: otpToken,
        password: _passwordCtrl.text,
        passwordConfirm: _confirmCtrl.text,
      );
    } else {
      cubit.resetPassword(
        otpToken: otpToken,
        password: _passwordCtrl.text,
        passwordConfirm: _confirmCtrl.text,
      );
    }
  }

  PasswordRuleState _ruleState(bool satisfied) {
    if (_passwordCtrl.text.isEmpty) return PasswordRuleState.pending;
    return satisfied ? PasswordRuleState.valid : PasswordRuleState.invalid;
  }

  PasswordRuleState get _matchState {
    if (_confirmCtrl.text.isEmpty) return PasswordRuleState.pending;
    return _passwordsMatch
        ? PasswordRuleState.valid
        : PasswordRuleState.invalid;
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = _mode == CreatePasswordMode.register;
    final title = isRegister ? context.l10n.createPassword : context.l10n.createNewPassword;
    final passwordLabel = isRegister ? context.l10n.password : context.l10n.newPassword;
    final passwordHint = isRegister
        ? context.l10n.enterPasswordHere
        : context.l10n.enterNewPasswordHere;

    return BlocProvider(
      create: (_) => sl<CreatePasswordCubit>(),
      child: BlocListener<CreatePasswordCubit, CreatePasswordState>(
        listener: (context, state) {
          if (state.status == CreatePasswordStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }

          if (state.status == CreatePasswordStatus.success) {
            context.read<CreatePasswordCubit>().reset();
            if (isRegister) {
              final member = state.member;
              if (member != null) {
                context.read<UserProfileCubit>().setMember(member);
              }
              unawaited(context.read<UserProfileCubit>().fetchProfile());
              context.go(
                AppRoutes.subscriptionQuestionnaire,
                extra: QuestionnaireScreenArgs(
                  prefill: member == null
                      ? null
                      : OnboardingPrefillEntity(
                          fullName: member.fullName,
                          gender: member.gender,
                          phone: member.phone,
                          phoneCountryCode: member.phoneCountryCode,
                        ),
                  completeToHome: true,
                ),
              );
              return;
            }

            AppSuccessSheet.show(
              context,
              title: context.l10n.forgotPassword,
              headline: context.l10n.newPasswordCreatedSuccess,
              highlightWord: context.l10n.successfully,
              description:
                  context.l10n.keepPasswordSafeHint,
              buttonLabel: context.l10n.signIn,
              badgeAsset:
                  'assets/images/svgs/success_when_create_anew_password_icon.svg',
              onButtonPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            );
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
                        CreatePasswordHeader(title: title),
                        32.vertical,
                        AppPasswordField(
                          label: passwordLabel,
                          controller: _passwordCtrl,
                          focusNode: _passwordFocus,
                          hint: passwordHint,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => setState(() {}),
                          onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
                        ),
                        16.vertical,
                        AppPasswordField(
                          label: context.l10n.confirmPasswordAlt,
                          controller: _confirmCtrl,
                          focusNode: _confirmFocus,
                          hint: context.l10n.enterConfirmPasswordHere,
                          textInputAction: TextInputAction.done,
                          onChanged: (_) => setState(() {}),
                        ),
                        16.vertical,
                        _RulesGrid(
                          minLengthState: _ruleState(_hasMinLength),
                          digitState: _ruleState(_hasDigit),
                          letterState: _ruleState(_hasLetter),
                          matchState: _matchState,
                        ),
                        24.vertical,
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CreatePasswordCubit, CreatePasswordState>(
                  builder: (context, state) => _BottomSection(
                    canSubmit: _canSubmit,
                    isLoading: state.isLoading,
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

final class _RulesGrid extends StatelessWidget {
  const _RulesGrid({
    required this.minLengthState,
    required this.digitState,
    required this.letterState,
    required this.matchState,
  });

  final PasswordRuleState minLengthState;
  final PasswordRuleState digitState;
  final PasswordRuleState letterState;
  final PasswordRuleState matchState;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AppPasswordRuleChip(label: context.l10n.passwordMinEightCharsHint, state: minLengthState),
        AppPasswordRuleChip(
          label: context.l10n.passwordHasDigit,
          state: digitState,
        ),
        AppPasswordRuleChip(
          label: context.l10n.passwordHasLetter,
          state: letterState,
        ),
        AppPasswordRuleChip(label: context.l10n.passwordsMatch, state: matchState),
      ],
    );
  }
}

final class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.canSubmit,
    required this.isLoading,
    required this.onConfirm,
  });

  final bool canSubmit;
  final bool isLoading;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: AppButton(
        label: context.l10n.confirm,
        isLoading: isLoading,
        onPressed: canSubmit && !isLoading ? onConfirm : null,
      ),
    );
  }
}
