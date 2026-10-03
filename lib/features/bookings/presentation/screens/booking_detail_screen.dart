import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/bookings/domain/entities/booking_entity.dart';
import 'package:glory_gym/features/bookings/presentation/bookings_refresh_notifier.dart';
import 'package:glory_gym/features/bookings/presentation/widgets/booking_card.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/booking_detail/booking_detail_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/cubits/session_checkin_scan/session_checkin_scan_cubit.dart';
import 'package:glory_gym/features/bookings/presentation/utils/booking_check_in_ui.dart';
import 'package:glory_gym/features/bookings/presentation/utils/pt_session_scan_flow.dart';
import 'package:glory_gym/features/coach_chat/domain/utils/coach_chat_utils.dart';
import 'package:glory_gym/features/coach_chat/domain/repositories/coach_chat_repository.dart';

final class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<BookingDetailCubit>(param1: bookingId)..load(),
        ),
        BlocProvider(create: (_) => sl<SessionCheckinScanCubit>()),
      ],
      child: _BookingDetailView(bookingId: bookingId),
    );
  }
}

final class _BookingDetailView extends StatelessWidget {
  const _BookingDetailView({required this.bookingId});

  final String bookingId;

  Future<void> _confirmCancel(BuildContext context) async {
    final shouldCancel = await AppConfirmDialog.show(
      context,
      title: context.l10n.cancelClass,
      message: context.l10n.confirmCancelClass,
      confirmLabel: context.l10n.cancelClass,
    );
    if (shouldCancel != true || !context.mounted) return;

    final success = await context.read<BookingDetailCubit>().cancel();
    if (!context.mounted) return;
    if (success) {
      BookingsRefreshNotifier.request();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.classCancelledSuccess)),
      );
    }
  }

  Future<void> _checkIn(BuildContext context) async {
    final result = await context.read<BookingDetailCubit>().checkIn();
    if (!context.mounted || result == null) return;
    BookingsRefreshNotifier.request();
    BookingCheckInUi.showSuccessSheet(
      context,
      result: result,
      offerRating: context.read<BookingDetailCubit>().state.booking?.canRate ?? false,
    );
  }

  void _scan(BuildContext context) {
    PtSessionScanFlow.openScannerAndSubmit(
      context,
      onBookingUpdated: () {
        BookingsRefreshNotifier.request();
        context.read<BookingDetailCubit>().load();
      },
    );
  }

  Future<void> _openPtChat(BuildContext context) async {
    final result = await sl<CoachChatRepository>().getConversations();
    if (!context.mounted) return;

    result.fold(
      onSuccess: (conversations) {
        final pt = CoachChatUtils.findPtConversation(conversations);
        if (pt != null) {
          context.push(AppRoutes.coachChatThread(pt.id), extra: pt);
          return;
        }
        context.push(AppRoutes.coachChat);
      },
      onFailure: (_) => context.push(AppRoutes.coachChat),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n.localeName;

    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: context.l10n.sessionDetails,
        showBack: true,
        centerTitle: true,
      ),
      body: BlocBuilder<BookingDetailCubit, BookingDetailState>(
        builder: (context, state) {
          if (state.status == BookingDetailStatus.loading && state.booking == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == BookingDetailStatus.failure && state.booking == null) {
            return Center(
              child: Text(
                state.errorMessage ?? context.l10n.errorTryAgain,
                style: context.captionRegular,
              ),
            );
          }

          final booking = state.booking;
          if (booking == null) {
            return AppEmptyState(
              icon: AppEmptyIcons.bookings,
              title: context.l10n.noData,
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BookingCard(
                  item: BookingUtils.toBookingItem(
                    booking,
                    l10n: context.l10n,
                    locale: locale,
                    onScanSessionQr: booking.isPrivateTraining && booking.canCheckIn
                        ? () => _scan(context)
                        : null,
                    onCheckIn: booking.canCheckIn ? () => _checkIn(context) : null,
                    onEvaluate: booking.canRate
                        ? () => context.push(
                              AppRoutes.classEvaluation,
                              extra: booking.id,
                            )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                if (booking.isPrivateTraining)
                  OutlinedButton.icon(
                    onPressed: () => _openPtChat(context),
                    icon: const Icon(Iconsax.messages_2, size: 20),
                    label: Text(context.l10n.contactPtCoach),
                  ),
                if (booking.canCancel) ...[
                  const SizedBox(height: 10),
                  AppButton(
                    label: context.l10n.cancelClass,
                    variant: AppButtonVariant.outlined,
                    isLoading: state.isActionInProgress,
                    onPressed: state.isActionInProgress
                        ? null
                        : () => _confirmCancel(context),
                  ),
                ],
                if (state.rating != null && state.rating!.answers.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.viewSessionRating,
                    style: context.highlightBold,
                  ),
                  const SizedBox(height: 12),
                  ...state.rating!.answers.map(
                    (answer) => _RatingRow(
                      question: locale.startsWith('ar')
                          ? answer.questionAr
                          : answer.questionEn,
                      stars: answer.answer,
                    ),
                  ),
                ] else if (booking.checkedInAt != null && !booking.canRate) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () =>
                        context.push(AppRoutes.bookingRating, extra: booking.id),
                    child: Text(context.l10n.viewSessionRating),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

final class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.question, required this.stars});

  final String question;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(question, style: context.subtitleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  Icons.star_rounded,
                  color: i <= stars ? AppColors.yellow100 : AppColors.neutral300,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
