import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/utils/family_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/family_member_entity.dart';
import '../cubits/family_list/family_list_cubit.dart';

final class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

final class _FamilyScreenState extends State<FamilyScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<FamilyListCubit>().loadMore();
    }
  }

  Future<void> _openAddMember(BuildContext providerContext) async {
    final changed = await providerContext.push<bool>(AppRoutes.addFamilyMember);
    if (changed == true && providerContext.mounted) {
      providerContext.read<FamilyListCubit>().loadMembers(refresh: true);
    }
  }

  Future<void> _openEditMember(
    BuildContext providerContext,
    FamilyMemberEntity member,
  ) async {
    final changed = await providerContext.push<bool>(
      AppRoutes.addFamilyMember,
      extra: member,
    );
    if (changed == true && providerContext.mounted) {
      providerContext.read<FamilyListCubit>().loadMembers(refresh: true);
    }
  }

  void _showMemberActions(
    BuildContext providerContext,
    FamilyMemberEntity member,
  ) {
    showModalBottomSheet<void>(
      context: providerContext,
      backgroundColor: Colors.transparent,
      builder: (_) => _FamilyMemberActionsSheet(
        onEdit: () {
          Navigator.of(providerContext).pop();
          _openEditMember(providerContext, member);
        },
        onDelete: () {
          Navigator.of(providerContext).pop();
          _confirmDelete(providerContext, member);
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext providerContext,
    FamilyMemberEntity member,
  ) async {
    final shouldDelete = await AppConfirmDialog.show(
      providerContext,
      title: 'حذف عضو',
      message: 'هل أنت متأكد أنك تريد حذف "${member.fullName}"؟',
      confirmLabel: 'حذف',
    );

    if (shouldDelete != true || !providerContext.mounted) return;

    final success =
        await providerContext.read<FamilyListCubit>().deleteMember(member.id);

    if (!providerContext.mounted) return;

    if (success) {
      ScaffoldMessenger.of(providerContext).showSnackBar(
        const SnackBar(content: Text('تم حذف العضو بنجاح')),
      );
      return;
    }

    final error = providerContext.read<FamilyListCubit>().state.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(providerContext).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FamilyListCubit>()..loadMembers(),
      child: Builder(
        builder: (providerContext) {
          return BlocListener<FamilyListCubit, FamilyListState>(
            listenWhen: (previous, current) =>
                previous.errorMessage != current.errorMessage &&
                current.errorMessage != null &&
                current.status != FamilyListStatus.deleting,
            listener: (context, state) {
              final message = state.errorMessage;
              if (message == null) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            child: AppScaffold(
              appBar: const AppPrimaryHeader(
                title: 'أفراد العائلة',
                showBack: true,
                centerTitle: false,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _openAddMember(providerContext),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: AppColors.white),
              ),
              body: BlocBuilder<FamilyListCubit, FamilyListState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == FamilyListStatus.failure &&
                      state.members.isEmpty) {
                    return _FamilyErrorView(
                      message: state.errorMessage ?? 'حدث خطأ، حاول مرة أخرى',
                      onRetry: () => context
                          .read<FamilyListCubit>()
                          .loadMembers(refresh: true),
                    );
                  }

                  if (state.isEmpty) {
                    return _FamilyEmptyView(
                      onAdd: () => _openAddMember(providerContext),
                    );
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(18),
                    itemCount:
                        state.members.length + (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      if (index >= state.members.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final member = state.members[index];
                      final isDeleting = state.deletingMemberId == member.id;

                      return _FamilyMemberCard(
                        member: member,
                        isDeleting: isDeleting,
                        onMoreTap: () =>
                            _showMemberActions(providerContext, member),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _FamilyEmptyView extends StatelessWidget {
  const _FamilyEmptyView({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.people,
              size: 72,
              color: AppColors.neutral300,
            ),
            const SizedBox(height: 20),
            Text(
              'لا يوجد أفراد عائلة',
              style: context.highlightBold.copyWith(color: AppColors.neutral900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بإضافة أفراد عائلتك للمتابعة من التطبيق',
              style: context.captionRegular.copyWith(color: AppColors.neutral500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(label: 'إضافة عضو جديد', onPressed: onAdd),
          ],
        ),
      ),
    );
  }
}

final class _FamilyErrorView extends StatelessWidget {
  const _FamilyErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            AppButton(label: 'إعادة المحاولة', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

final class _FamilyMemberCard extends StatelessWidget {
  const _FamilyMemberCard({
    required this.member,
    required this.onMoreTap,
    this.isDeleting = false,
  });

  final FamilyMemberEntity member;
  final VoidCallback onMoreTap;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDeleting ? 0.5 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MemberHeader(
              name: member.fullName,
              onMoreTap: isDeleting ? null : onMoreTap,
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.neutral200),
            const SizedBox(height: 12),
            _MemberDetails(member: member),
          ],
        ),
      ),
    );
  }
}

final class _MemberHeader extends StatelessWidget {
  const _MemberHeader({required this.name, this.onMoreTap});

  final String name;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: context.captionBold.copyWith(color: AppColors.neutral900),
        ),
        InkWell(
          onTap: onMoreTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.more_horiz,
              size: 18,
              color: onMoreTap == null
                  ? AppColors.neutral300
                  : AppColors.neutral1000,
            ),
          ),
        ),
      ],
    );
  }
}

final class _MemberDetails extends StatelessWidget {
  const _MemberDetails({required this.member});

  final FamilyMemberEntity member;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _DetailCell(
              label: 'تاريخ الاضافة',
              value: FamilyUtils.formatAddedDate(member.createdAt),
            ),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailCell(
              label: 'العلاقة',
              value: FamilyUtils.relationLabel(member.relation),
            ),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailCell(
              label: 'تاريخ الميلاد',
              value: FamilyUtils.formatBirthDate(member.dateOfBirth),
            ),
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
        Text(
          value,
          style: context.subtitleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

final class _FamilyMemberActionsSheet extends StatelessWidget {
  const _FamilyMemberActionsSheet({
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
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
                'اختر إجراء',
                style: context.highlightBold.copyWith(color: AppColors.neutral900),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.neutral200),
            _ActionTile(
              icon: Iconsax.edit_2,
              label: 'تعديل',
              onTap: onEdit,
            ),
            const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.neutral200),
            _ActionTile(
              icon: Iconsax.trash,
              label: 'حذف',
              isDestructive: true,
              onTap: onDelete,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

final class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.red : AppColors.neutral900;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: context.highlightStandard.copyWith(color: color),
              ),
            ),
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
