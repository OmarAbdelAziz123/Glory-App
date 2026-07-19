import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../../../../core/widgets/app_primary_header.dart';
import '../../../../../core/widgets/app_scaffold.dart';

final class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

enum _AppLanguage { arabic, english }

final class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  _AppLanguage _selectedLanguage = _AppLanguage.arabic;

  void _showLanguageSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguageSheet(
        selected: _selectedLanguage,
        onSelect: (lang) {
          setState(() => _selectedLanguage = lang);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'الإعدادات',
        showBack: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileCard(
              onEditProfile: () => context.push(AppRoutes.editProfile),
            ),
            const SizedBox(height: 16),
            _buildTilesGroup(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTilesGroup(BuildContext context) {
    final tiles = <Widget>[
      _SettingsTile(
        iconAsset: 'person_icon.svg',
        label: 'الملف الشخصي',
        onTap: () => context.push(AppRoutes.profile),
      ),
      _SettingsTile(
        iconAsset: 'person_icon.svg',
        label: 'فحص تكوين الجسم',
        onTap: () => context.push(AppRoutes.bodyComposition),
      ),
      _SettingsTile(
        iconAsset: 'person_icon.svg',
        label: 'قياسات الحجم',
        onTap: () => context.push(AppRoutes.sizeMeasurements),
      ),
      _SettingsTile(
        iconAsset: 'bookings_icon.svg',
        label: 'اشتراكاتي',
        onTap: () => context.push(AppRoutes.subscriptions),
      ),
      _SettingsTile(
        iconAsset: 'change_password_icon.svg',
        label: 'تغير كلمة السر',
        onTap: () => context.push(AppRoutes.forgotPassword),
      ),
      _SettingsTile(
        iconAsset: 'items_family_icon.svg',
        label: 'أفراد العائلة',
        onTap: () => context.push(AppRoutes.family),
      ),
      _SettingsTile(
        iconAsset: 'about_us.svg',
        label: 'معلومات عن جلوري جيم',
        onTap: () => context.push(AppRoutes.about),
      ),
      _SettingsTile(
        iconAsset: 'notifications_icon.svg',
        label: 'الاشعارات',
        trailing: _NotificationsTrailing(
          enabled: _notificationsEnabled,
          onChanged: (v) => setState(() => _notificationsEnabled = v),
        ),
      ),
      _SettingsTile(
        iconAsset: 'language_icon.svg',
        label: 'لغة التطبيق',
        onTap: _showLanguageSheet,
        trailing: Text(
          _selectedLanguage == _AppLanguage.arabic ? 'العربية' : 'English',
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
        ),
      ),
      const _SettingsTile(
        iconAsset: 'logout_icon.svg',
        label: 'تسجيل خروج',
        isDestructive: true,
      ),
      const _SettingsTile(
        iconAsset: 'delete_icon.svg',
        label: 'حذف الحساب',
        isDestructive: true,
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          tiles[i],
          if (i < tiles.length - 1)
            const Divider(height: 1, color: AppColors.neutral200),
        ],
      ],
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.onEditProfile});

  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: Image.asset(
                  'assets/images/pngs/profile_image.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اسم المستخدم', style: context.highlightBold),
                    const SizedBox(height: 4),
                    Text(
                      'uiux@ahmedsaudi.com',
                      style: context.captionRegular.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _EditProfileButton(onTap: onEditProfile),
        ],
      ),
    );
  }
}

final class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 48),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/svgs/edit_icon.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'تعديل الملف الشخصي',
            style: context.captionRegular.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

final class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.iconAsset,
    required this.label,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final String iconAsset;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.red : AppColors.neutral900;
    final iconColor = isDestructive ? AppColors.red : AppColors.neutral700;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/svgs/$iconAsset',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: context.highlightStandard.copyWith(color: color),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDestructive ? AppColors.red : AppColors.neutral1000,
            ),
          ],
        ),
      ),
    );
  }
}

final class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.selected, required this.onSelect});

  final _AppLanguage selected;
  final ValueChanged<_AppLanguage> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'اختر اللغة',
              style: context.highlightBold.copyWith(color: AppColors.neutral900),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.neutral200),
          _LanguageOption(
            label: 'العربية',
            sublabel: 'Arabic',
            isSelected: selected == _AppLanguage.arabic,
            onTap: () => onSelect(_AppLanguage.arabic),
          ),
          const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.neutral200),
          _LanguageOption(
            label: 'English',
            sublabel: 'الإنجليزية',
            isSelected: selected == _AppLanguage.english,
            onTap: () => onSelect(_AppLanguage.english),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
        ],
      ),
    );
  }
}

final class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String sublabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.neutral300,
                  width: isSelected ? 0 : 1.5,
                ),
                color: isSelected ? AppColors.primary : AppColors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: AppColors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.captionBold.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.neutral900,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: context.footnoteRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _NotificationsTrailing extends StatelessWidget {
  const _NotificationsTrailing({
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          enabled ? 'مفعل' : 'غير مفعل',
          style: context.captionRegular.copyWith(color: AppColors.neutral500),
        ),
        const SizedBox(width: 4),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: enabled,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary300,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
