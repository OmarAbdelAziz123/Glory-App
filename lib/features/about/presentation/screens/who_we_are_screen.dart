import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glory_gym/core/core.dart';

final class WhoWeAreScreen extends StatefulWidget {
  const WhoWeAreScreen({super.key});

  @override
  State<WhoWeAreScreen> createState() => _WhoWeAreScreenState();
}

final class _WhoWeAreScreenState extends State<WhoWeAreScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'من نحن',
        showBack: true,
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GymImage(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _UnderlineTabBar(
              tabController: _tabController,
              tabs: const ['تعرف علي جلوري جيم', 'منصات التواصل'],
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
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _GymImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Image.asset(
        'assets/images/pngs/classes_image.png',
        fit: BoxFit.cover,
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

  static const _body =
      'جلوري جيم هو صرح رياضي متكامل يسعى لتوفير أفضل تجربة لياقة بدنية في المنطقة. '
      'تأسس الجيم برؤية طموحة تهدف إلى جعل اللياقة البدنية أسلوب حياة لكل فرد في مجتمعنا.\n\n'
      'نقدم في جلوري جيم باقة متنوعة من البرامج التدريبية المتخصصة التي تشمل التدريب الشخصي، '
      'والحصص الجماعية، وبرامج التغذية الصحية، كل ذلك بإشراف نخبة من المدربين المعتمدين دولياً.\n\n'
      'مرافقنا مجهزة بأحدث الأجهزة والمعدات الرياضية لضمان تجربة تدريبية آمنة وفعّالة، '
      'في بيئة محفزة تشجعك على تجاوز حدودك وتحقيق أهدافك.';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        _body,
        style: context.contentRegular.copyWith(
          color: AppColors.neutral700,
          height: 1.8,
        ),
      ),
    );
  }
}

final class _SocialTabContent extends StatelessWidget {
  const _SocialTabContent();

  static const _platforms = [
    _SocialPlatform(
      iconAsset: 'facebook_icon.svg',
      name: 'فيسبوك',
      handle: 'Glory Gym',
    ),
    _SocialPlatform(
      iconAsset: 'instgram_icon.svg',
      name: 'انستجرام',
      handle: '@glorygym',
    ),
    _SocialPlatform(
      iconAsset: 'twitter_icon.svg',
      name: 'تويتر',
      handle: '@glorygym',
    ),
    _SocialPlatform(
      iconAsset: 'whatsapp_icon.svg',
      name: 'واتساب',
      handle: '+966 50 000 0000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: _platforms.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: AppColors.neutral200),
      itemBuilder: (context, index) =>
          _SocialTile(platform: _platforms[index]),
    );
  }
}

// ── Data / sub-widgets ────────────────────────────────────────────────────────

final class _SocialPlatform {
  const _SocialPlatform({
    required this.iconAsset,
    required this.name,
    required this.handle,
  });

  final String iconAsset;
  final String name;
  final String handle;
}

final class _SocialTile extends StatelessWidget {
  const _SocialTile({required this.platform});

  final _SocialPlatform platform;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
