import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/widgets/booking_card.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/bookings_list/bookings_list_cubit.dart';

final class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingsListCubit>()..loadBookings(),
      child: const _BookingsView(),
    );
  }
}

final class _BookingsView extends StatefulWidget {
  const _BookingsView();

  @override
  State<_BookingsView> createState() => _BookingsViewState();
}

final class _BookingsViewState extends State<_BookingsView> {
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
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      context.read<BookingsListCubit>().loadMore();
    }
  }

  Future<void> _confirmCancel(String bookingId) async {
    final shouldCancel = await AppConfirmDialog.show(
      context,
      title: 'الغاء الحصة',
      message: 'هل أنت متأكد أنك تريد الغاء هذه الحصة؟',
      confirmLabel: 'الغاء الحصة',
    );

    if (shouldCancel != true || !mounted) return;

    final success =
        await context.read<BookingsListCubit>().cancelBooking(bookingId);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الغاء الحصة بنجاح')),
      );
      return;
    }

    final error = context.read<BookingsListCubit>().state.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileCubit>().state;
    final locale =
        BookingUtils.localeFromAppLanguage(profile.member?.appLanguage);

    return BlocListener<BookingsListCubit, BookingsListState>(
      listenWhen: (previous, current) =>
          previous.lastCheckInResult != current.lastCheckInResult &&
          current.lastCheckInResult != null,
      listener: (context, state) {
        final result = state.lastCheckInResult;
        if (result == null) return;

        AppSuccessSheet.show(
          context,
          title: 'تسجيل دخول التدريب',
          headline: 'لقد تم دخولك للحصة بنجاح!',
          highlightWord: 'بنجاح',
          description:
              'أهلاً بك في عائلة جلوري جيم! لقد تم تسجيل دخول لحصة (${result.packageNameAr}) '
              'مع الكوتش (${result.instructorName}) متبقي معك ${result.remainingSessions} حصص',
          buttonLabel: 'الرئيسية',
          badgeAsset:
              'assets/images/svgs/success_when_create_anew_password_icon.svg',
          onButtonPressed: () {
            context.read<BookingsListCubit>().clearCheckInResult();
            Navigator.of(context).pop();
          },
        );
      },
      child: AppScaffold(
        appBar: const AppPrimaryHeader(
          title: 'الحجوزات',
          showBack: false,
          centerTitle: true,
        ),
        body: BlocBuilder<BookingsListCubit, BookingsListState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == BookingsListStatus.failure &&
                state.bookings.isEmpty) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'حدث خطأ، حاول مرة أخرى',
                  style: context.captionRegular,
                ),
              );
            }

            if (state.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد حجوزات حالياً',
                  style: context.captionRegular.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              );
            }

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(18),
              itemCount: state.bookings.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                if (index >= state.bookings.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final booking = state.bookings[index];
                return AppEntrance(
                  key: ValueKey('booking-${booking.id}'),
                  delay: Duration(milliseconds: (index.clamp(0, 5)) * 70),
                  offset: const Offset(0, 0.06),
                  child: BookingCard(
                    item: BookingUtils.toBookingItem(
                      booking,
                      locale: locale,
                      onCheckIn: booking.canCheckIn
                          ? () => context
                              .read<BookingsListCubit>()
                              .checkInBooking(booking.id)
                          : null,
                      onCancel: booking.canCancel
                          ? () => _confirmCancel(booking.id)
                          : null,
                      onEvaluate: booking.canRate
                          ? () => context.push(
                                AppRoutes.classEvaluation,
                                extra: booking.id,
                              )
                          : null,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
