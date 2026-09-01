import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glory_gym/core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/content_args.dart';
import '../../domain/entities/content_entities.dart';
import '../cubits/contact/contact_cubit.dart';
import '../cubits/info_page/info_page_cubit.dart';
import '../../../../core/l10n/l10n_extension.dart';

final class WhoWeAreScreen extends StatefulWidget {
  const WhoWeAreScreen({super.key, this.args});

  final WhoWeAreArgs? args;

  @override
  State<WhoWeAreScreen> createState() => _WhoWeAreScreenState();
}

final class _WhoWeAreScreenState extends State<WhoWeAreScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.args?.initialTab ?? 0,
    );
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<InfoPageCubit>()..loadPage('ABOUT'),
        ),
        BlocProvider(
          create: (_) => sl<ContactCubit>()..loadContactLinks(),
        ),
      ],
      child: AppScaffold(
        appBar: AppPrimaryHeader(
          title: context.l10n.aboutUs,
          showBack: true,
          centerTitle: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<InfoPageCubit, InfoPageState>(
              builder: (context, state) {
                return Skeletonizer(
                  enabled: state.isLoading,
                  child: ContentHeroImage(imageUrl: state.page?.imageUrl),
                );
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _UnderlineTabBar(
                tabController: _tabController,
                tabs: [
                  context.l10n.getToKnowGloryGym,
                  context.l10n.socialMediaPlatforms,
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _AboutTabContent(),
                  _SocialTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _UnderlineTabBar extends StatelessWidget {
  const _UnderlineTabBar({
    required this.tabController,
    required this.tabs,
  });

  final TabController tabController;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelStyle: context.captionBold,
      unselectedLabelStyle: context.captionRegular,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.neutral500,
      indicatorColor: AppColors.primary,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: AppColors.neutral200,
      tabs: tabs.map((t) => Tab(text: t)).toList(),
    );
  }
}

final class _AboutTabContent extends StatelessWidget {
  const _AboutTabContent();

  @override
  Widget build(BuildContext context) {
    final isArabic = ContentUtils.isArabic(context);

    return BlocBuilder<InfoPageCubit, InfoPageState>(
      builder: (context, state) {
        if (state.status == InfoPageStatus.failure) {
          return _ErrorView(
            message: state.errorMessage ?? context.l10n.errorTryAgain,
            onRetry: () => context.read<InfoPageCubit>().loadPage('ABOUT'),
          );
        }

        final content = state.page?.contentFor(isArabic: isArabic) ??
            context.l10n.contentUnavailable;

        return Skeletonizer(
          enabled: state.isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              content,
              style: context.contentRegular.copyWith(
                color: AppColors.neutral700,
                height: 1.8,
              ),
            ),
          ),
        );
      },
    );
  }
}

final class _SocialTabContent extends StatelessWidget {
  const _SocialTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        if (state.status == ContactStatus.failure) {
          return _ErrorView(
            message: state.errorMessage ?? context.l10n.errorTryAgain,
            onRetry: () => context.read<ContactCubit>().loadContactLinks(),
          );
        }

        final links = state.links;
        final platforms = _buildPlatforms(context, links);

        return Skeletonizer(
          enabled: state.isLoading,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: state.isLoading ? 4 : platforms.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1, color: AppColors.neutral200),
            itemBuilder: (context, index) {
              if (state.isLoading) {
                return _SocialTile(
                  platform: _SocialPlatform(
                    iconAsset: 'facebook_icon.svg',
                    name: context.l10n.facebook,
                    handle: context.l10n.appName,
                  ),
                );
              }

              final platform = platforms[index];
              return _SocialTile(
                platform: platform,
                onTap: () => _openUrl(context, platform.url),
              );
            },
          ),
        );
      },
    );
  }

  List<_SocialPlatform> _buildPlatforms(
    BuildContext context,
    ContactLinksEntity? links,
  ) {
    if (links == null) return const [];

    final l10n = context.l10n;
    return [
      if (links.facebook?.isNotEmpty == true)
        _SocialPlatform(
          iconAsset: 'facebook_icon.svg',
          name: l10n.facebook,
          handle: l10n.appName,
          url: links.facebook!,
        ),
      if (links.instagram?.isNotEmpty == true)
        _SocialPlatform(
          iconAsset: 'instgram_icon.svg',
          name: l10n.instagram,
          handle: '@glorygym',
          url: links.instagram!,
        ),
      if (links.twitter?.isNotEmpty == true)
        _SocialPlatform(
          iconAsset: 'twitter_icon.svg',
          name: l10n.twitter,
          handle: '@glorygym',
          url: links.twitter!,
        ),
      if (links.whatsapp?.isNotEmpty == true)
        _SocialPlatform(
          iconAsset: 'whatsapp_icon.svg',
          name: l10n.whatsapp,
          handle: links.phone ?? l10n.whatsapp,
          url: links.whatsapp!,
        ),
      if (links.phone?.isNotEmpty == true)
        _SocialPlatform(
          iconAsset: 'contact_us_icon.svg',
          name: l10n.telephone,
          handle: links.phone!,
          url: 'tel:${links.phone}',
        ),
    ];
  }

  Future<void> _openUrl(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.couldNotOpenLink)),
      );
    }
  }
}

final class _SocialPlatform {
  const _SocialPlatform({
    required this.iconAsset,
    required this.name,
    required this.handle,
    this.url,
  });

  final String iconAsset;
  final String name;
  final String handle;
  final String? url;
}

final class _SocialTile extends StatelessWidget {
  const _SocialTile({required this.platform, this.onTap});

  final _SocialPlatform platform;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/svgs/${platform.iconAsset}',
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform.name,
                    style: context.captionBold.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    platform.handle,
                    style: context.footnoteRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.neutral1000,
            ),
          ],
        ),
      ),
    );
  }
}

final class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            AppButton(label: context.l10n.retry, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
