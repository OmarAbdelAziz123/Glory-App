import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:glory_gym/features/home/presentation/widgets/group_class_card.dart';
import 'package:glory_gym/features/workouts/presentation/cubits/workout_detail/workout_detail_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

final class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutDetailCubit>(param1: id)..loadDetail(),
      child: _WorkoutDetailView(assignmentId: id),
    );
  }
}

final class _WorkoutDetailView extends StatelessWidget {
  const _WorkoutDetailView({required this.assignmentId});

  final String assignmentId;

  Future<void> _openAddWeight(BuildContext context) async {
    final added = await context.push<bool>(
      '/workouts/$assignmentId/add-weight',
    );

    if (added == true && context.mounted) {
      await context.read<WorkoutDetailCubit>().loadDetail();
    }
  }

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileCubit>().state;
    final locale =
        WorkoutUtils.localeFromAppLanguage(profile.member?.appLanguage);

    return BlocListener<WorkoutDetailCubit, WorkoutDetailState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      child: AppScaffold(
        appBar: const AppPrimaryHeader(
          title: 'تفاصيل التمرين',
          showBack: true,
          centerTitle: true,
        ),
        body: BlocBuilder<WorkoutDetailCubit, WorkoutDetailState>(
          builder: (context, state) {
            if (state.isLoading && state.detail == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final detail = state.detail;
            if (detail == null) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'حدث خطأ، حاول مرة أخرى',
                  style: context.captionRegular,
                ),
              );
            }

            final cardStatus = WorkoutUtils.cardStatus(detail.status);
            final workoutType = WorkoutUtils.typeLabel(detail.workoutType);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppEntrance(
                    delay: const Duration(milliseconds: 40),
                    offset: const Offset(0, 0.05),
                    child: _HeaderCard(
                      name: WorkoutUtils.workoutNameFromDetail(
                        detail,
                        locale: locale,
                      ),
                      status: cardStatus,
                      time: WorkoutUtils.durationLabel(detail.durationDays),
                      type: workoutType,
                      startDate: WorkoutUtils.formatDate(detail.startDate),
                      endDate: WorkoutUtils.formatDate(detail.endDate),
                      remainingDays:
                          WorkoutUtils.remainingDaysLabel(detail.remainingDays),
                      issuedBy: detail.status == 'UPCOMING'
                          ? detail.instructorName
                          : null,
                      suggestedWeight:
                          WorkoutUtils.weightLabel(detail.suggestedWeight),
                      userWeight: WorkoutUtils.weightLabel(detail.userWeight),
                      userWeightLast:
                          WorkoutUtils.weightLabel(detail.userWeightLast),
                    ),
                  ),
                  if (detail.canAddWeight) ...[
                    const SizedBox(height: 12),
                    AppEntrance(
                      delay: const Duration(milliseconds: 100),
                      child: AppButton(
                        label: 'اضافة وزن',
                        height: 48,
                        onPressed: state.status ==
                                WorkoutDetailStatus.submittingWeight
                            ? null
                            : () => _openAddWeight(context),
                        isLoading: state.status ==
                            WorkoutDetailStatus.submittingWeight,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  AppEntrance(
                    delay: const Duration(milliseconds: 140),
                    child: Text(
                      'تعليمات التمرين العامة',
                      textAlign: TextAlign.end,
                      style: context.highlightBold.copyWith(
                        color: AppColors.neutral900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...detail.instructions.asMap().entries.map(
                    (entry) {
                      final instruction = entry.value;
                      return AppEntrance(
                        key: ValueKey('phase-${instruction.stepNumber}'),
                        delay: Duration(
                          milliseconds: 180 + (entry.key.clamp(0, 5) * 80),
                        ),
                        offset: const Offset(0, 0.06),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _PhaseCard(
                            phaseLabel: WorkoutUtils.phaseLabel(
                              instruction.stepNumber,
                            ),
                            workoutType: workoutType,
                            thumbnailUrl: instruction.videos.isNotEmpty
                                ? instruction.videos.first.thumbnailUrl
                                : null,
                            onPlay: instruction.videos.isNotEmpty
                                ? () => _openVideo(
                                      instruction.videos.first.videoUrl,
                                    )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.name,
    required this.status,
    required this.time,
    required this.type,
    required this.startDate,
    this.endDate,
    this.remainingDays,
    this.issuedBy,
    this.suggestedWeight,
    this.userWeight,
    this.userWeightLast,
  });

  final String name;
  final GroupClassStatus status;
  final String time;
  final String type;
  final String startDate;
  final String? endDate;
  final String? remainingDays;
  final String? issuedBy;
  final String? suggestedWeight;
  final String? userWeight;
  final String? userWeightLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          _TitleRow(name: name, status: status),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: 12),
          _ThreeColumnRow(
            col1: (label: 'الوقت', value: time),
            col2: (label: 'نوع التمرين', value: type),
            col3: issuedBy != null
                ? (label: 'اصدرت بواسطة', value: issuedBy!)
                : startDate.isNotEmpty
                    ? (label: 'تاريخ البداية', value: startDate)
                    : null,
          ),
          if (status == GroupClassStatus.ongoing &&
              remainingDays != null &&
              remainingDays!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.neutral200),
            const SizedBox(height: 12),
            _DetailColumn(
              label: 'عدد الايام المتبقية',
              value: remainingDays!,
            ),
          ],
          if (status == GroupClassStatus.completed &&
              endDate != null &&
              endDate!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.neutral200),
            const SizedBox(height: 12),
            _DetailColumn(label: 'تاريخ الانتهاء', value: endDate!),
          ],
          if ((suggestedWeight?.isNotEmpty ?? false) ||
              (userWeight?.isNotEmpty ?? false) ||
              (userWeightLast?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.neutral200),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                children: [
                  if (suggestedWeight?.isNotEmpty ?? false)
                    Expanded(
                      child: _DetailColumn(
                        label: 'الوزن المقترح',
                        value: suggestedWeight!,
                      ),
                    ),
                  if (userWeight?.isNotEmpty ?? false) ...[
                    if (suggestedWeight?.isNotEmpty ?? false)
                      const VerticalDivider(
                        width: 1,
                        color: AppColors.neutral200,
                      ),
                    Expanded(
                      child: _DetailColumn(
                        label: 'وزنك',
                        value: userWeight!,
                      ),
                    ),
                  ],
                  if (userWeightLast?.isNotEmpty ?? false) ...[
                    const VerticalDivider(width: 1, color: AppColors.neutral200),
                    Expanded(
                      child: _DetailColumn(
                        label: 'الوزن السابق',
                        value: userWeightLast!,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.phaseLabel,
    required this.workoutType,
    this.thumbnailUrl,
    this.onPlay,
  });

  final String phaseLabel;
  final String workoutType;
  final String? thumbnailUrl;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _DetailColumn(label: phaseLabel, value: workoutType),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onPlay,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                height: 160,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
                      Image.network(
                        thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Image.asset(
                          'assets/images/pngs/classes_image.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Image.asset(
                        'assets/images/pngs/classes_image.png',
                        fit: BoxFit.cover,
                      ),
                    if (onPlay != null)
                      Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            size: 28,
                            color: AppColors.neutral900,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.name, required this.status});

  final String name;
  final GroupClassStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      GroupClassStatus.ongoing => ('تمرين جاري', AppColors.primary),
      GroupClassStatus.upcoming => ('تمرين قادم', AppColors.red100),
      GroupClassStatus.completed => ('تمرين مكتمل', AppColors.green200),
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(name, style: context.highlightBold)),
        _Chip(label: label, color: color),
      ],
    );
  }
}

final class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: context.footnoteRegular.copyWith(color: color)),
    );
  }
}

final class _ThreeColumnRow extends StatelessWidget {
  const _ThreeColumnRow({
    required this.col1,
    required this.col2,
    this.col3,
  });

  final ({String label, String value}) col1;
  final ({String label, String value}) col2;
  final ({String label, String value})? col3;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _DetailColumn(label: col1.label, value: col1.value),
          ),
          const VerticalDivider(width: 1, color: AppColors.neutral200),
          Expanded(
            child: _DetailColumn(label: col2.label, value: col2.value),
          ),
          if (col3 != null) ...[
            const VerticalDivider(width: 1, color: AppColors.neutral200),
            Expanded(
              child: _DetailColumn(label: col3!.label, value: col3!.value),
            ),
          ],
        ],
      ),
    );
  }
}

final class _DetailColumn extends StatelessWidget {
  const _DetailColumn({required this.label, required this.value});

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
