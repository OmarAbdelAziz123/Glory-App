import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/core/utils/subscription_utils.dart';
import 'package:glory_gym/features/subscriptions/domain/entities/subscription_entity.dart';
import 'package:glory_gym/features/subscriptions/presentation/cubits/subscriptions_list/subscriptions_list_cubit.dart';

final class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SubscriptionsListCubit>()..loadSubscriptions(),
      child: const _SubscriptionsView(),
    );
  }
}

final class _SubscriptionsView extends StatefulWidget {
  const _SubscriptionsView();

  @override
  State<_SubscriptionsView> createState() => _SubscriptionsViewState();
}

final class _SubscriptionsViewState extends State<_SubscriptionsView> {
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
      context.read<SubscriptionsListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = l10n.localeName.startsWith('ar');

    return AppScaffold(
      appBar: AppPrimaryHeader(
        title: l10n.mySubscriptions,
        showBack: true,
        centerTitle: false,
      ),
      body: BlocBuilder<SubscriptionsListCubit, SubscriptionsListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SubscriptionsListStatus.failure &&
              state.isEmpty) {
            return Center(
              child: Text(
                state.errorMessage ?? l10n.errorTryAgain,
                style: context.captionRegular,
              ),
            );
          }

          if (state.isEmpty) {
            return Center(
              child: Text(
                l10n.noData,
                style: context.captionRegular.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(18),
            itemCount:
                state.subscriptions.length + (state.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= state.subscriptions.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final subscription = state.subscriptions[index];
              return _SubscriptionCard(
                subscription: subscription,
                packageName: subscription.packageName(isArabic: isArabic),
                packageType: SubscriptionUtils.packageTypeLabel(
                  l10n,
                  subscription,
                ),
                startDate: SubscriptionUtils.formatDate(
                  l10n,
                  subscription.startDate,
                ),
                endDate: SubscriptionUtils.formatDate(
                  l10n,
                  subscription.endDate,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

final class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.packageName,
    required this.packageType,
    required this.startDate,
    required this.endDate,
  });

  final SubscriptionEntity subscription;
  final String packageName;
  final String packageType;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PackageHeader(name: packageName),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.neutral200),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _DetailCell(
                    label: context.l10n.startDate,
                    value: startDate,
                  ),
                ),
                const VerticalDivider(width: 1, color: AppColors.neutral200),
                Expanded(
                  child: _DetailCell(
                    label: context.l10n.endDate,
                    value: endDate,
                  ),
                ),
                const VerticalDivider(width: 1, color: AppColors.neutral200),
                Expanded(
                  child: _DetailCell(
                    label: context.l10n.packageType,
                    value: packageType,
                  ),
                ),
              ],
            ),
          ),
          if (subscription.remainingSessions != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.neutral200),
            const SizedBox(height: 12),
            _DetailCell(
              label: context.l10n.sessions,
              value:
                  '${subscription.remainingSessions}/${subscription.sessionCount ?? subscription.remainingSessions}',
            ),
          ],
        ],
      ),
    );
  }
}

final class _PackageHeader extends StatelessWidget {
  const _PackageHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary10,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.card_membership_outlined,
            size: 18,
            color: AppColors.primary700,
          ),
        ),
        12.horizontal,
        Expanded(
          child: Text(
            name,
            style: context.captionBold.copyWith(color: AppColors.neutral900),
          ),
        ),
      ],
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
        Text(value, style: context.subtitleMedium, textAlign: TextAlign.center),
      ],
    );
  }
}
