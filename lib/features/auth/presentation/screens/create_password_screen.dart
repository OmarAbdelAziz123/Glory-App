import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/create_password_header.dart';

enum CreatePasswordMode { register, forgotPassword }

final class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({
    super.key,
    this.mode = CreatePasswordMode.forgotPassword,
  });

  final CreatePasswordMode mode;

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

  void _onConfirm() {
    final isRegister = widget.mode == CreatePasswordMode.register;
    AppSuccessSheet.show(
      context,
      title: isRegister ? 'انشاء حساب' : 'نسيت كلمة المرور',
      headline: isRegister
          ? 'لقد تم إنشاء حسابك بنجاح!'
          : 'تم إنشاء كلمة مرور جديدة بنجاح!',
      highlightWord: 'بنجاح',
      description: isRegister
          ? 'أهلاً بك في عائلة جلوري جيم! رحلة القوة والتغيير تبدأ من هنا.. استكشف التطبيق الآن وابدأ في تحدي نفسك وتنظيم تمارينك بكل حماس'
          : 'حاول الاحتفاظ بكلمة المرور بعيدا لتفادي سرقة حسابك و بياناتك',
      buttonLabel: 'تسجيل دخول',
      badgeAsset:
          'assets/images/svgs/success_when_create_anew_password_icon.svg',
      onButtonPressed: () =>
          Navigator.of(context).popUntil((route) => route.isFirst),
    );
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
    final isRegister = widget.mode == CreatePasswordMode.register;
    final title = isRegister ? 'انشاء كلمة مرور' : 'انشاء كلمة مرور جديدة';
    final passwordLabel = isRegister ? 'كلمة المرور' : 'كلمة المرور الجديدة';
    final passwordHint = isRegister
        ? 'قم بإدخال كلمة المرور الخاصة بك هنا'
        : 'قم بإدخال كلمة المرور الجديدة الخاصة بك هنا';

    return AppScaffold(
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
            _BottomSection(canSubmit: _canSubmit, onConfirm: _onConfirm),
          ],
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
  const _BottomSection({required this.canSubmit, required this.onConfirm});

  final bool canSubmit;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: AppButton(label: 'تأكيد', onPressed: canSubmit ? onConfirm : null),
    );
  }
}
