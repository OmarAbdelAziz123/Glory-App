import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles_extension.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/cubits/user_profile/user_profile_cubit.dart';

final class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileCubit>().state;

    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'الملف الشخصي',
        showBack: true,
        centerTitle: true,
      ),
      body: profile.isLoading && profile.member == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHeader(
                    fullName: profile.displayName,
                    email: profile.displayEmail,
                    avatarUrl: profile.member?.avatarUrl,
                  ),
                  const SizedBox(height: 16),
                  _ProfileDetailsCard(
                    items: [
                      _ProfileInfoItem(
                        icon: Iconsax.user,
                        label: 'الاسم',
                        value: profile.displayName,
                      ),
                      _ProfileInfoItem(
                        icon: Iconsax.sms,
                        label: 'البريد الإلكتروني',
                        value: profile.displayEmail,
                      ),
                      _ProfileInfoItem(
                        icon: Iconsax.call,
                        label: 'رقم الجوال',
                        value: profile.displayPhone,
                      ),
                      if (profile.displayBirthDate.isNotEmpty)
                        _ProfileInfoItem(
                          icon: Iconsax.calendar,
                          label: 'تاريخ الميلاد',
                          value: profile.displayBirthDate,
                        ),
                      _ProfileInfoItem(
                        icon: Iconsax.heart,
                        label: 'الحالة الاجتماعية',
                        value: profile.displayMaritalStatus,
                      ),
                      _ProfileInfoItem(
                        icon: Iconsax.health,
                        label: 'الحالة الصحية',
                        value: profile.displayHealthNotes,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

final class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.fullName,
    required this.email,
    required this.avatarUrl,
  });

  final String fullName;
  final String email;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          AppMemberAvatar(avatarUrl: avatarUrl, size: 96),
          const SizedBox(height: 16),
          Text(
            fullName,
            style: context.highlightBold.copyWith(color: AppColors.neutral900),
            textAlign: TextAlign.center,
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              email,
              style: context.captionRegular.copyWith(color: AppColors.neutral500),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

final class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({required this.items});

  final List<_ProfileInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _ProfileInfoRow(item: items[i]),
            if (i < items.length - 1)
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: AppColors.neutral200,
              ),
          ],
        ],
      ),
    );
  }
}

final class _ProfileInfoItem {
  const _ProfileInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

final class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.item});

  final _ProfileInfoItem item;

  @override
  Widget build(BuildContext context) {
    final displayValue = item.value.trim().isEmpty ? '—' : item.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary10,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(item.icon, size: 20, color: AppColors.primary700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(item.label, style: context.highlightEmphasis),
                const SizedBox(height: 6),
                Text(
                  displayValue,
                  style: context.captionRegular.copyWith(
                    color: AppColors.neutral900,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
