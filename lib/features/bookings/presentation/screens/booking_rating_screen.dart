import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/bookings/domain/repositories/bookings_repository.dart';

final class BookingRatingScreen extends StatefulWidget {
  const BookingRatingScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  State<BookingRatingScreen> createState() => _BookingRatingScreenState();
}

final class _BookingRatingScreenState extends State<BookingRatingScreen> {
  var _loading = true;
  String? _error;
  var _answers = <({String question, int stars})>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await sl<BookingsRepository>().getBookingRating(widget.bookingId);
    if (!mounted) return;

    result.fold(
      onSuccess: (rating) {
        final locale = context.l10n.localeName;
        setState(() {
          _loading = false;
          _answers = rating.answers
              .map(
                (a) => (
                  question: locale.startsWith('ar') ? a.questionAr : a.questionEn,
                  stars: a.answer,
                ),
              )
              .toList();
        });
      },
      onFailure: (failure) {
        setState(() {
          _loading = false;
          _error = failure.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: context.l10n.viewSessionRating,
        showBack: true,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: context.captionRegular))
              : _answers.isEmpty
                  ? AppEmptyState(
                      icon: AppEmptyIcons.bookings,
                      title: context.l10n.noData,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(18),
                      itemCount: _answers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = _answers[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.neutral200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(item.question, style: context.subtitleMedium),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  for (var i = 1; i <= 5; i++)
                                    Icon(
                                      Icons.star_rounded,
                                      color: i <= item.stars
                                          ? AppColors.yellow100
                                          : AppColors.neutral300,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
