import 'package:flutter/material.dart';
import 'package:glory_gym/core/extensions/extensions.dart';
import 'package:glory_gym/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:glory_gym/core/theme/app_colors.dart';
import 'package:glory_gym/core/theme/app_styles_extension.dart';
import 'package:glory_gym/core/widgets/app_button.dart';
import 'package:glory_gym/features/bookings/presentation/widgets/booking_card.dart';
import 'package:glory_gym/features/home/presentation/widgets/group_class_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Gym registration tab: QR flow and regenerate action.
final class HomeGymRegistrationTabContent extends StatelessWidget {
  const HomeGymRegistrationTabContent({
    super.key,
    required this.hasQr,
    required this.qrData,
    required this.secondsLeft,
    required this.isCountingDown,
    required this.onGenerateQr,
  });

  final bool hasQr;
  final String? qrData;
  final int secondsLeft;
  final bool isCountingDown;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_HomeQrCard(qrData: qrData!)],
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        if (showQr) ...[
          Text(
            'ستنتهي صلاحية الكود خلال ( $secondsLabel ثانية )',
            textAlign: TextAlign.center,
            style: context.captionRegular.copyWith(
              color: AppColors.neutral1000,
            ),
          ),
          16.vertical,
        ],
        AppButton(
          label: 'توليد QR كود اخر',
          onPressed: isCountingDown ? null : onGenerateQr,
        ),
      ],
    );
  }
}

final class _HomeQrCard extends StatelessWidget {
  const _HomeQrCard({required this.qrData});

  final String qrData;

  static const _qrBg = Color(0xFFFFF9EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _qrBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: QrImageView(
        data: qrData,
        version: QrVersions.auto,
        size: 200,
        backgroundColor: _qrBg,
      ),
    );
  }
}

/// Appointments tab — shows latest bookings with a "view all" link.
final class HomeAppointmentsTabContent extends StatelessWidget {
  const HomeAppointmentsTabContent({super.key, this.onViewAll});

  final VoidCallback? onViewAll;

  static final _bookings = [
    BookingItem(
      packageName: 'اسم الباكدج',
      type: 'تدريب شخصي',
      trainerName: 'احمد حسام',
      date: '١ مايو ٢٠٢٦',
      time: '6:20 Pm',
      status: BookingStatus.canCheckIn,
      onCheckIn: () {},
      onCancel: () {},
    ),
    BookingItem(
      packageName: 'اسم الباكدج',
      type: 'تدريب جماعي',
      trainerName: 'محمد علي',
      date: '٢ مايو ٢٠٢٦',
      time: '8:00 Am',
      status: BookingStatus.checkedIn,
      onCancel: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
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
        const SizedBox(height: 16),
        ..._bookings.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: BookingCard(item: item),
          ),
        ),
      ],
    );
  }
}

/// Group classes tab — shows latest group classes with a "view all" link.
final class HomeGroupClassesTabContent extends StatelessWidget {
  const HomeGroupClassesTabContent({super.key, this.onViewAll});

  final VoidCallback? onViewAll;

  static final _classes = [
    const GroupClassItem(
      className: 'اسم التمرين',
      imageAsset: 'assets/images/pngs/classes_image.png',
      classType: 'كارديو',
      time: '40',
      startDate: '١ مايو ٢٠٢٦',
      status: GroupClassStatus.ongoing,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
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
        const SizedBox(height: 16),
        ..._classes.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GroupClassCard(
              item: item,
              onEvaluate: item.status == GroupClassStatus.completed
                  ? () => context.push(AppRoutes.classEvaluation)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
