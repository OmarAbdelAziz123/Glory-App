import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/bookings/presentation/bookings_refresh_notifier.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/bookings_list/bookings_list_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/session_checkin_scan/session_checkin_scan_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/utils/booking_check_in_ui.dart';
import 'package:glory_gym/features/bookings/presentation/utils/pt_session_scan_flow.dart';
import 'package:glory_gym/features/bookings/presentation/widgets/booking_card.dart';

final class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BookingsListCubit>()..loadBookings(),
        ),
        BlocProvider(create: (_) => sl<SessionCheckinScanCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return BookingsRefreshListener(
            onRefresh: () =>
                context.read<BookingsListCubit>().loadBookings(refresh: true),
            child: const _BookingsView(),
          );
        },
      ),
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
      title: context.l10n.cancelClass,
      message: context.l10n.confirmCancelClass,
      confirmLabel: context.l10n.cancelClass,
    );

    if (shouldCancel != true || !mounted) return;

    final success =
        await context.read<BookingsListCubit>().cancelBooking(bookingId);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.classCancelledSuccess)),
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
    final locale = context.l10n.localeName;

    return BlocListener<BookingsListCubit, BookingsListState>(
      listenWhen: (previous, current) =>
          previous.lastCheckInResult != current.lastCheckInResult &&
          current.lastCheckInResult != null,
      listener: (context, state) {
        final result = state.lastCheckInResult;
        if (result == null) return;

        final canRate = state.bookings
            .any((b) => b.id == result.bookingId && b.canRate);

        BookingCheckInUi.showSuccessSheet(
          context,
          result: result,
          offerRating: canRate,
          onDismiss: () =>
              context.read<BookingsListCubit>().clearCheckInResult(),
        );
      },
      child: AppScaffold(
        appBar: AppPrimaryHeader(
          title: context.l10n.bookings,
          showBack: false,
          centerTitle: true,
        ),
        body: BlocBuilder<BookingsListCubit, BookingsListState>(
          builder: (context, state) {
            Future<void> refresh() => context
                .read<BookingsListCubit>()
                .loadBookings(refresh: true);

            if (state.isLoading && state.bookings.isEmpty) {
              return AppPlatformRefreshScroll(
                onRefresh: refresh,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state.status == BookingsListStatus.failure &&
                state.bookings.isEmpty) {
              return AppPlatformRefreshScroll(
                onRefresh: refresh,
                child: Center(
                  child: Text(
                    state.errorMessage ?? context.l10n.errorTryAgain,
                    style: context.captionRegular,
                  ),
                ),
              );
            }

            if (state.isEmpty) {
              return AppPlatformRefreshScroll(
                fillViewport: true,
                onRefresh: refresh,
                child: AppEmptyState(
                  icon: AppEmptyIcons.bookings,
                  title: context.l10n.emptyBookingsTitle,
                  description: context.l10n.emptyBookingsDescription,
                ),
              );
            }

            return AppPlatformRefreshListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(18),
              onRefresh: refresh,
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
                      l10n: context.l10n,
                      locale: locale,
                      onTap: () => context.push(
                        AppRoutes.bookingDetail.replaceFirst(':id', booking.id),
                      ),
                      onScanSessionQr: () => PtSessionScanFlow.openScannerAndSubmit(
                        context,
                        onBookingUpdated: () => context
                            .read<BookingsListCubit>()
                            .loadBookings(refresh: true),
                      ),
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
