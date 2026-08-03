import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:glory_gym/features/bookings/domain/entities/booking_entity.dart';
import 'package:glory_gym/features/bookings/presentation/widgets/booking_card.dart';
import 'package:glory_gym/features/home/presentation/widgets/group_class_card.dart';
import 'package:glory_gym/features/workouts/presentation/cubits/workouts_list/workouts_list_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Gym registration tab: QR flow and regenerate action.
final class HomeGymRegistrationTabContent extends StatelessWidget {
  const HomeGymRegistrationTabContent({
    super.key,
    required this.hasQr,
    required this.qrData,
    required this.secondsLeft,
    required this.isGenerating,
    required this.canRegenerate,
    required this.onGenerateQr,
  });

  final bool hasQr;
  final String? qrData;
  final int secondsLeft;
  final bool isGenerating;
  final bool canRegenerate;
  final VoidCallback onGenerateQr;

  @override
  Widget build(BuildContext context) {
    final showQr = hasQr && qrData != null;
    final secondsLabel = secondsLeft.clamp(0, 99).toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showQr)
          Expanded(
            child: Center(
              child: AppEntrance(
                delay: const Duration(milliseconds: 60),
                offset: const Offset(0, 0.08),
                duration: const Duration(milliseconds: 480),
                child: _HomeQrCard(qrData: qrData!),
              ),
            ),
          )
        else
          const Spacer(),
        if (showQr) ...[
          AppEntrance(
            delay: const Duration(milliseconds: 140),
            child: Text(
              'ستنتهي صلاحية الكود خلال ( $secondsLabel ثانية )',
              textAlign: TextAlign.center,
              style: context.captionRegular.copyWith(
                color: AppColors.neutral1000,
              ),
            ),
          ),
          16.vertical,
        ],
        AppEntrance(
          delay: Duration(milliseconds: showQr ? 200 : 80),
          offset: const Offset(0, 0.1),
          child: AppButton(
            label: 'توليد QR كود اخر',
            isLoading: isGenerating,
            onPressed: canRegenerate && !isGenerating ? onGenerateQr : null,
          ),
        ),
      ],
    );
  }
}

final class _HomeQrCard extends StatefulWidget {
  const _HomeQrCard({required this.qrData});

  final String qrData;

  @override
  State<_HomeQrCard> createState() => _HomeQrCardState();
}

final class _HomeQrCardState extends State<_HomeQrCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  static const _qrBg = Color(0xFFFFF9EB);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _scale = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _HomeQrCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qrData != widget.qrData) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _qrBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: QrImageView(
          data: widget.qrData,
          version: QrVersions.auto,
          size: 200,
          backgroundColor: _qrBg,
        ),
      ),
    );
  }
}

/// Appointments tab — shows latest bookings with a "view all" link.
final class HomeAppointmentsTabContent extends StatelessWidget {
  const HomeAppointmentsTabContent({
    super.key,
    required this.bookings,
    required this.locale,
    required this.isLoading,
    this.onViewAll,
    this.onCheckIn,
    this.onCancel,
    this.onEvaluate,
  });

  final List<BookingEntity> bookings;
  final String locale;
  final bool isLoading;
  final VoidCallback? onViewAll;
  final void Function(String id)? onCheckIn;
  final void Function(String id)? onCancel;
  final void Function(String id)? onEvaluate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppEntrance(
          delay: const Duration(milliseconds: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'اخر الحجوزات',
                style: context.highlightBold.copyWith(
                  color: AppColors.neutral900,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'رؤية الكل',
                  style: context.captionRegular.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (bookings.isEmpty)
          AppEntrance(
            delay: const Duration(milliseconds: 80),
            child: Text(
              'لا توجد حجوزات حالياً',
              style:
                  context.captionRegular.copyWith(color: AppColors.neutral500),
              textAlign: TextAlign.center,
            ),
          )
        else
          ...bookings.asMap().entries.map(
            (entry) => AppEntrance(
              delay: Duration(milliseconds: 80 + (entry.key * 90)),
              offset: const Offset(0, 0.07),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: BookingCard(
                  item: BookingUtils.toBookingItem(
                    entry.value,
                    locale: locale,
                    onCheckIn: entry.value.canCheckIn
                        ? () => onCheckIn?.call(entry.value.id)
                        : null,
                    onCancel: entry.value.canCancel
                        ? () => onCancel?.call(entry.value.id)
                        : null,
                    onEvaluate: entry.value.canRate
                        ? () => onEvaluate?.call(entry.value.id)
                        : null,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Group classes tab — latest assigned workout from GET /mobile/workouts.
final class HomeGroupClassesTabContent extends StatelessWidget {
  const HomeGroupClassesTabContent({super.key, this.onViewAll});

  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileCubit>().state;
    final locale =
        WorkoutUtils.localeFromAppLanguage(profile.member?.appLanguage);
    final workoutsState = context.watch<WorkoutsListCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppEntrance(
          delay: const Duration(milliseconds: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الحصص الجماعية',
                style: context.highlightBold.copyWith(
                  color: AppColors.neutral900,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'رؤية الكل',
                  style: context.captionRegular.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (workoutsState.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (workoutsState.status == WorkoutsListStatus.failure &&
            workoutsState.workouts.isEmpty)
          AppEntrance(
            delay: const Duration(milliseconds: 80),
            child: Center(
              child: Text(
                workoutsState.errorMessage ?? 'حدث خطأ، حاول مرة أخرى',
                style: context.captionRegular,
              ),
            ),
          )
        else if (workoutsState.workouts.isEmpty)
          AppEntrance(
            delay: const Duration(milliseconds: 80),
            child: Center(
              child: Text(
                'لا توجد تمارين',
                style: context.captionRegular.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ),
          )
        else
          ...workoutsState.workouts.asMap().entries.map(
            (entry) {
              final workout = entry.value;
              final item = WorkoutUtils.toGroupClassItem(
                workout,
                locale: locale,
              );

              return AppEntrance(
                delay: Duration(milliseconds: 80 + (entry.key * 90)),
                offset: const Offset(0, 0.07),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    onTap: () => context.push('/workouts/${workout.id}'),
                    child: GroupClassCard(
                      item: item,
                      onEvaluate: item.status == GroupClassStatus.completed
                          ? () => context.push(
                                AppRoutes.classEvaluation,
                                extra: '',
                              )
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
