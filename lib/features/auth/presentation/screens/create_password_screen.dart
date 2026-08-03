import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/models/otp_args.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubits/create_password/create_password_cubit.dart';
import '../widgets/create_password_header.dart';

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
        const SnackBar(content: Text('رمز التحقق غير صالح، حاول مرة أخرى')),
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
    final title = isRegister ? 'انشاء كلمة مرور' : 'انشاء كلمة مرور جديدة';
    final passwordLabel = isRegister ? 'كلمة المرور' : 'كلمة المرور الجديدة';
    final passwordHint = isRegister
        ? 'قم بإدخال كلمة المرور الخاصة بك هنا'
        : 'قم بإدخال كلمة المرور الجديدة الخاصة بك هنا';

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
              context.push(AppRoutes.subscriptionQuestionnaire);
              return;
            }

            AppSuccessSheet.show(
              context,
              title: 'نسيت كلمة المرور',
              headline: 'تم إنشاء كلمة مرور جديدة بنجاح!',
              highlightWord: 'بنجاح',
              description:
                  'حاول الاحتفاظ بكلمة المرور بعيدا لتفادي سرقة حسابك و بياناتك',
              buttonLabel: 'تسجيل دخول',
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
                          label: 'تاكيد كلمة المرور',
                          controller: _confirmCtrl,
                          focusNode: _confirmFocus,
                          hint: 'قم بإدخال تاكيد كلمة المرور الخاصة بك هنا',
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
        AppPasswordRuleChip(label: '8 حروف علي الاقل', state: minLengthState),
        AppPasswordRuleChip(
          label: 'تحتوي على رقم واحد على الأقل',
          state: digitState,
        ),
        AppPasswordRuleChip(
          label: 'تحتوي على حرف كبير أو صغير',
          state: letterState,
        ),
        AppPasswordRuleChip(label: 'كلمتي المرور متطابقتين', state: matchState),
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
        label: 'تأكيد',
        isLoading: isLoading,
        onPressed: canSubmit && !isLoading ? onConfirm : null,
      ),
    );
  }
}
