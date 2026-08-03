import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glory_gym/core/core.dart';
import 'package:glory_gym/features/auth/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:glory_gym/features/notifications/domain/entities/notification_entity.dart';
import 'package:glory_gym/features/notifications/presentation/cubits/notifications_list/notifications_list_cubit.dart';
import 'package:glory_gym/features/notifications/presentation/cubits/notifications_unread/notifications_unread_cubit.dart';

final class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

final class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationsListCubit>()..loadNotifications(),
      child: const _NotificationsContent(),
    );
  }
}

final class _NotificationsContent extends StatefulWidget {
  const _NotificationsContent();

  @override
  State<_NotificationsContent> createState() => _NotificationsContentState();
}

final class _NotificationsContentState extends State<_NotificationsContent> {
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
      context.read<NotificationsListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _NotificationsView(scrollController: _scrollController);
  }
}

final class _NotificationsView extends StatelessWidget {
  const _NotificationsView({required this.scrollController});

  final ScrollController scrollController;

  Future<void> _openDetail(
    BuildContext context,
    NotificationEntity notification,
  ) async {
    final detail = await context
        .read<NotificationsListCubit>()
        .openNotification(notification.id);

    if (!context.mounted || detail == null) return;

    context.read<NotificationsUnreadCubit>().fetchUnreadCount();

    final profile = context.read<UserProfileCubit>().state;
    final locale =
        NotificationUtils.localeFromAppLanguage(profile.member?.appLanguage);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotifDetailSheet(
        title: NotificationUtils.title(detail, locale: locale),
        body: NotificationUtils.body(detail, locale: locale),
        imageUrl: detail.imageUrl,
      ),
    );

    if (context.mounted) {
      context.read<NotificationsListCubit>().clearSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileCubit>().state;
    final locale =
        NotificationUtils.localeFromAppLanguage(profile.member?.appLanguage);

    return BlocListener<NotificationsListCubit, NotificationsListState>(
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
        appBar: const AppPrimaryHeader(title: 'الاشعارات', centerTitle: false),
        body: BlocBuilder<NotificationsListCubit, NotificationsListState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == NotificationsListStatus.failure &&
                state.notifications.isEmpty) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'حدث خطأ، حاول مرة أخرى',
                  style: context.captionRegular,
                ),
              );
            }

            if (state.notifications.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد اشعارات',
                  style: context.captionRegular.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              );
            }

            final groups =
                NotificationUtils.groupByDate(state.notifications);

            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(18),
              itemCount: groups.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (_, groupIndex) {
                if (groupIndex >= groups.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final group = groups[groupIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (groupIndex > 0) const SizedBox(height: 16),
                    _SectionHeader(label: group.label),
                    const SizedBox(height: 8),
                    ...group.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _NotifCard(
                          title: NotificationUtils.title(item, locale: locale),
                          subtitle:
                              NotificationUtils.subtitle(item, locale: locale),
                          isUnread: !item.isRead,
                          imageUrl: item.imageUrl,
                          onTap: () => _openDetail(context, item),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

final class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: context.contentBold);
  }
}

final class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.title,
    required this.subtitle,
    required this.isUnread,
    required this.onTap,
    this.imageUrl,
  });

  final String title;
  final String subtitle;
  final bool isUnread;
  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Row(
                children: [
                  _NotificationAvatar(imageUrl: imageUrl),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.subtitleMedium),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: context.captionRegular.copyWith(
                              color: AppColors.neutral500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isUnread)
          Positioned(
            left: 0,
            top: 0,
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

final class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const _AvatarPlaceholder(),
        ),
      );
    }

    return const _AvatarPlaceholder();
  }
}

final class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 52,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.neutral300,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

final class _NotifDetailSheet extends StatelessWidget {
  const _NotifDetailSheet({
    required this.title,
    required this.body,
    this.imageUrl,
  });

  final String title;
  final String body;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'الاشعارات',
                style: context.highlightBold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.neutral200),
              const SizedBox(height: 28),
              _NotificationAvatar(imageUrl: imageUrl),
              const SizedBox(height: 20),
              Text(
                title,
                style: context.featureBold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                body,
                style: context.captionRegular.copyWith(
                  color: AppColors.neutral700,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'السابق',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
