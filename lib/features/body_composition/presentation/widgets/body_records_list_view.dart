import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';

import '../cubits/body_records_list/body_records_list_cubit.dart';
import 'measurement_card.dart';

final class BodyRecordsListView extends StatefulWidget {
  const BodyRecordsListView({super.key, required this.type});

  final String type;

  @override
  State<BodyRecordsListView> createState() => _BodyRecordsListViewState();
}

final class _BodyRecordsListViewState extends State<BodyRecordsListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !mounted) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      context.read<BodyRecordsListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<BodyRecordsListCubit, BodyRecordsListState>(
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
      child: BlocBuilder<BodyRecordsListCubit, BodyRecordsListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == BodyRecordsListStatus.failure && state.isEmpty) {
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
            itemCount: state.records.length + (state.isLoadingMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              if (index >= state.records.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final record = state.records[index];
              return MeasurementCard(
                data: BodyRecordUtils.toMeasurementCardData(record, l10n),
              );
            },
          );
        },
      ),
    );
  }
}

final class BodyRecordsScreenShell extends StatelessWidget {
  const BodyRecordsScreenShell({
    super.key,
    required this.title,
    required this.type,
  });

  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BodyRecordsListCubit>(param1: type)..loadRecords(),
      child: AppScaffold(
        appBar: AppPrimaryHeader(
          title: title,
          showBack: true,
          centerTitle: false,
        ),
        body: BodyRecordsListView(type: type),
      ),
    );
  }
}
