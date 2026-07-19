import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';
import 'package:go_router/go_router.dart';

final class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  static final _members = [
    const _FamilyMemberData(
      name: 'احمد حسام',
      relationship: 'ابن',
      birthDate: 'يونيو',
      addedDate: '٢٠٢٦ ١٠ يونيو',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'أفراد العائلة',
        showBack: true,
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addFamilyMember),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: _members.isEmpty
          ? const Center(child: SizedBox.shrink())
          : ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: _members.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, index) =>
                  _FamilyMemberCard(member: _members[index]),
            ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

final class _FamilyMemberData {
  const _FamilyMemberData({
    required this.name,
    required this.relationship,
    required this.birthDate,
    required this.addedDate,
  });

  final String name;
  final String relationship;
  final String birthDate;
  final String addedDate;
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _FamilyMemberCard extends StatelessWidget {
  const _FamilyMemberCard({required this.member});

  final _FamilyMemberData member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MemberHeader(name: member.name),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: 12),
          _MemberDetails(member: member),
        ],
      ),
    );
  }
}

final class _MemberHeader extends StatelessWidget {
  const _MemberHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: context.captionBold.copyWith(color: AppColors.neutral900),
        ),
        Icon(Icons.more_horiz, size: 18, color: AppColors.neutral1000),
      ],
    );
  }
}

final class _MemberDetails extends StatelessWidget {
  const _MemberDetails({required this.member});

  final _FamilyMemberData member;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _DetailCell(label: 'تاريخ الاضافة', value: member.addedDate),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailCell(label: 'العلاقة', value: member.relationship),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailCell(label: 'تاريخ الميلاد', value: member.birthDate),
          ),
        ],
      ),
    );
  }
}

final class _DetailCell extends StatelessWidget {
  const _DetailCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: context.footnoteRegular.copyWith(color: AppColors.neutral400),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(value, style: context.subtitleMedium, textAlign: TextAlign.center),
      ],
    );
  }
}
