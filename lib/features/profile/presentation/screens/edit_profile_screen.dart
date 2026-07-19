import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';

final class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

final class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'اسم المستخدم');
  final _phoneController = TextEditingController(text: '+966 50 000 0000');
  final _emailController = TextEditingController(text: 'uiux@ahmedsaudi.com');
  final _birthdateController = TextEditingController(text: '١ يناير ١٩٩٠');
  final _maritalController = TextEditingController(text: 'أعزب');
  final _healthController = TextEditingController(text: 'لا توجد أمراض');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    _maritalController.dispose();
    _healthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'ملفي الشخصي',
        showBack: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _AvatarWithCameraBadge(),
            const SizedBox(height: 24),
            _ProfileForm(
              nameController: _nameController,
              phoneController: _phoneController,
              emailController: _emailController,
              birthdateController: _birthdateController,
              maritalController: _maritalController,
              healthController: _healthController,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'تعديل الحساب',
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _AvatarWithCameraBadge extends StatelessWidget {
  const _AvatarWithCameraBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 96,
        height: 96,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Image.asset(
                'assets/images/pngs/profile_image.png',
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _CameraBadge(),
            ),
          ],
        ),
      ),
    );
  }
}

final class _CameraBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.camera_alt, size: 16, color: AppColors.white),
    );
  }
}

final class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.birthdateController,
    required this.maritalController,
    required this.healthController,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController birthdateController;
  final TextEditingController maritalController;
  final TextEditingController healthController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(label: 'اسم المستخدم', controller: nameController),
        const SizedBox(height: 16),
        AppTextField(
          label: 'رقم الجوال',
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'البريد الإلكتروني',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'تاريخ الميلاد',
          controller: birthdateController,
          readOnly: true,
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'الحالة الاجتماعية',
          controller: maritalController,
          readOnly: true,
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            size: 22,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'الحالة الصحية',
          controller: healthController,
        ),
      ],
    );
  }
}
