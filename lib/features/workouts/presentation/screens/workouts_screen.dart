import 'package:flutter/material.dart';
import 'package:glory_gym/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_primary_header.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../home/presentation/widgets/group_class_card.dart';

final class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  static final _workouts = [
    const GroupClassItem(
      className: 'اسم التمرين',
      imageAsset: 'assets/images/pngs/classes_image.png',
      classType: 'كارديو',
      time: '40 يوم',
      startDate: '١ مايو ٢٠٢٦',
      status: GroupClassStatus.completed,
    ),
    const GroupClassItem(
      className: 'اسم التمرين',
      imageAsset: 'assets/images/pngs/classes_image.png',
      classType: 'كارديو',
      time: '40 يوم',
      startDate: '١ مايو ٢٠٢٦',
      status: GroupClassStatus.ongoing,
    ),
    const GroupClassItem(
      className: 'اسم التمرين',
      imageAsset: 'assets/images/pngs/classes_image.png',
      classType: 'كارديو',
      time: '40 يوم',
      status: GroupClassStatus.upcoming,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'تماريني',
        showBack: false,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: _workouts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => context.push('/workouts/$index'),
          child: GroupClassCard(
            item: _workouts[index],
            showPlayButton: false,
            onEvaluate: _workouts[index].status == GroupClassStatus.completed
                ? () => context.push(AppRoutes.classEvaluation)
                : null,
          ),
        ),
      ),
    );
  }
}
