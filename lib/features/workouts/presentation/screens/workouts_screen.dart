import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:glory_gym/features/home/presentation/widgets/group_class_card.dart';
import 'package:glory_gym/features/workouts/presentation/cubits/workouts_list/workouts_list_cubit.dart';
import 'package:go_router/go_router.dart';

final class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

final class _WorkoutsScreenState extends State<WorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WorkoutsListCubit>()..loadWorkouts(),
      child: const _WorkoutsBody(),
    );
  }
}

final class _WorkoutsBody extends StatefulWidget {
  const _WorkoutsBody();

  @override
  State<_WorkoutsBody> createState() => _WorkoutsBodyState();
}

final class _WorkoutsBodyState extends State<_WorkoutsBody> {
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
      context.read<WorkoutsListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileCubit>().state;
    final locale =
        WorkoutUtils.localeFromAppLanguage(profile.member?.appLanguage);

    return BlocListener<WorkoutsListCubit, WorkoutsListState>(
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
      child: AppScaffold(
        appBar: const AppPrimaryHeader(
          title: 'تماريني',
          showBack: false,
          centerTitle: true,
        ),
        body: BlocBuilder<WorkoutsListCubit, WorkoutsListState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == WorkoutsListStatus.failure &&
                state.workouts.isEmpty) {
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
                  'لا توجد تمارين',
                  style: context.captionRegular.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              );
            }

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(18),
              itemCount: state.workouts.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index >= state.workouts.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final workout = state.workouts[index];
                final item = WorkoutUtils.toGroupClassItem(
                  workout,
                  locale: locale,
                );

                return AppEntrance(
                  key: ValueKey('workout-${workout.id}'),
                  delay: Duration(milliseconds: (index.clamp(0, 5)) * 70),
                  offset: const Offset(0, 0.06),
                  child: GestureDetector(
                    onTap: () => context.push('/workouts/${workout.id}'),
                    child: GroupClassCard(
                      item: item,
                      showPlayButton: false,
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
