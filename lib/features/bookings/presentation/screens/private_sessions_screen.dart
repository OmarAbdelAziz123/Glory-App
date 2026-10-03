import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/bookings/presentation/bookings_refresh_notifier.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/bookings_list/bookings_list_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/session_checkin_scan/session_checkin_scan_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/utils/pt_session_scan_flow.dart';
import 'package:glory_gym/features/bookings/presentation/widgets/booking_card.dart';

final class PrivateSessionsScreen extends StatelessWidget {
  const PrivateSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BookingsListCubit>()
            ..loadBookings(privateTrainingOnly: true),
        ),
        BlocProvider(create: (_) => sl<SessionCheckinScanCubit>()),
      ],
      child: const _PrivateSessionsView(),
    );
  }
}

final class _PrivateSessionsView extends StatefulWidget {
  const _PrivateSessionsView();

  @override
  State<_PrivateSessionsView> createState() => _PrivateSessionsViewState();
}

final class _PrivateSessionsViewState extends State<_PrivateSessionsView> {
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
      context.read<BookingsListCubit>().loadMore(privateTrainingOnly: true);
    }
  }

  void _openScan(BuildContext context) {
    PtSessionScanFlow.openScannerAndSubmit(
      context,
      onBookingUpdated: () {
        context.read<BookingsListCubit>().loadBookings(
              refresh: true,
              privateTrainingOnly: true,
            );
        BookingsRefreshNotifier.request();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n.localeName;

    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: context.l10n.myPrivateSessions,
        showBack: true,
        centerTitle: true,
      ),
      body: BlocBuilder<BookingsListCubit, BookingsListState>(
        builder: (context, state) {
          Future<void> refresh() => context.read<BookingsListCubit>().loadBookings(
                refresh: true,
                privateTrainingOnly: true,
              );

          if (state.isLoading && state.bookings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isEmpty) {
            return AppPlatformRefreshScroll(
              fillViewport: true,
              onRefresh: refresh,
              child: AppEmptyState(
                icon: AppEmptyIcons.bookings,
                title: context.l10n.emptyPrivateSessionsTitle,
                description: context.l10n.emptyPrivateSessionsDescription,
                action: AppButton(
                  label: context.l10n.ptScanSessionTitle,
                  onPressed: () => _openScan(context),
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: AppPlatformRefreshListView(
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
                    return BookingCard(
                      item: BookingUtils.toBookingItem(
                        booking,
                        l10n: context.l10n,
                        locale: locale,
                        onTap: () => context.push(
                          AppRoutes.bookingDetail.replaceFirst(':id', booking.id),
                        ),
                        onScanSessionQr: () => _openScan(context),
                        onCheckIn: booking.canCheckIn
                            ? () => context
                                .read<BookingsListCubit>()
                                .checkInBooking(booking.id)
                            : null,
                        onEvaluate: booking.canRate
                            ? () => context.push(
                                  AppRoutes.classEvaluation,
                                  extra: booking.id,
                                )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: AppButton(
                  label: context.l10n.ptScanSessionTitle,
                  onPressed: () => _openScan(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
