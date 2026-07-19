import 'package:flutter/material.dart';
import 'package:glory_gym/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../widgets/booking_card.dart';

final class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  List<BookingItem> _bookings(BuildContext context) => [
        BookingItem(
          packageName: 'اسم الباكدج',
          type: 'تدريب شخصي',
          trainerName: 'احمد حسام',
          date: '١ مايو ٢٠٢٦',
          time: '6:20 Pm',
          status: BookingStatus.canCheckIn,
          onCheckIn: () {},
          onCancel: () {},
          onEvaluate: () => context.push(AppRoutes.classEvaluation),
        ),
        BookingItem(
          packageName: 'اسم الباكدج',
          type: 'تدريب شخصي',
          trainerName: 'احمد حسام',
          date: '١ مايو ٢٠٢٦',
          time: '6:20 Pm',
          status: BookingStatus.checkedIn,
          onCancel: () {},
          onEvaluate: () => context.push(AppRoutes.classEvaluation),
        ),
        BookingItem(
          packageName: 'اسم الباكدج',
          type: 'تدريب جماعي',
          trainerName: 'محمد علي',
          date: '٢ مايو ٢٠٢٦',
          time: '8:00 Am',
          status: BookingStatus.canCheckIn,
          onCheckIn: () {},
          onCancel: () {},
          onEvaluate: () => context.push(AppRoutes.classEvaluation),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final bookings = _bookings(context);
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'الحجوزات',
        showBack: false,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: bookings.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (_, index) => BookingCard(
          item: bookings[index],
        ),
      ),
    );
  }
}
