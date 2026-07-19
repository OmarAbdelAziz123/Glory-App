import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';

// ── Data models ───────────────────────────────────────────────────────────────

final class _NotifItem {
  const _NotifItem({
    required this.title,
    required this.subtitle,
    required this.body,
    this.isUnread = false,
  });
  final String title;
  final String subtitle;
  final String body;
  final bool isUnread;
}

final class _NotifGroup {
  const _NotifGroup({required this.label, required this.items});
  final String label;
  final List<_NotifItem> items;
}

// ── Screen ────────────────────────────────────────────────────────────────────

final class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _data = [
    _NotifGroup(
      label: 'اليوم',
      items: [
        _NotifItem(
          title: 'اوفر شهر 4',
          subtitle: 'او شهرين بقيمة 90 دينار',
          body:
              'خطة "وحش الحديد" جاهزة ليك يا بطل؛ الوصف: المدرب جوزلك النهاردة تمرينة رجل وكتاف من العيار الثقيل، مصممة مخصوص عشان تكسر الأرقام الي حققتها الأسبوع الي فات. الخطة فيها 8 تمارين جديدة بفيديوهات توضيحية لكل حركة عشان تضمن الأداء الصح وتجنب الإصابات.',
          isUnread: true,
        ),
        _NotifItem(
          title: 'أوفر فورمة الساحل',
          subtitle: 'خطة "وحش الحديد" جاهزة ليك يا بطل!...',
          body:
              'الصيف جاي وإنت مستعد؟ اشترك في باقة فورمة الساحل واحصل على برنامج تغذية + تمرين مخصوص لمدة 3 أشهر بسعر خاص. العرض محدود، اغتنم الفرصة دلوقتي!',
          isUnread: true,
        ),
      ],
    ),
    _NotifGroup(
      label: 'الامس',
      items: [
        _NotifItem(
          title: 'رض الصحاب في Glory',
          subtitle: 'اشترك أنت وصاحبك واحصلوا على خصم ٢٥٪',
          body:
              'اشترك أنت وصاحبك في نفس الوقت واحصلوا على خصم ٢٥٪ على الاشتراك لمدة 6 أشهر. العرض ساري حتى نهاية الشهر فقط. لا تفوت الفرصة وشارك الخبر مع أصحابك!',
        ),
      ],
    ),
    _NotifGroup(
      label: '22 ديسمبر 2024',
      items: [
        _NotifItem(
          title: 'باقة السنة الذهبية',
          subtitle: 'سنة كاملة بقيمة ٣٥٠٠ ج.م + شهرين مجاناً',
          body:
              'سنة كاملة بقيمة ٣٥٠٠ ج.م + شهرين مجاناً! الباقة الذهبية تشمل: دخول غير محدود لجميع الصالات، جلسات مع المدرب الشخصي، وتحليل التركيبة الجسمية كل شهر.',
          isUnread: true,
        ),
        _NotifItem(
          title: 'عرض نهاية السنة',
          subtitle: 'خصومات حصرية على جميع الباقات',
          body:
              'بمناسبة نهاية السنة نقدم لك خصومات حصرية تصل إلى ٤٠٪ على جميع باقات الاشتراك. العرض ينتهي يوم ٣١ ديسمبر، سارع بالتسجيل الآن!',
        ),
      ],
    ),
  ];

  static void _showDetail(BuildContext context, _NotifItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotifDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(title: 'الاشعارات', centerTitle: false),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: _data.length,
        itemBuilder: (_, groupIndex) {
          final group = _data[groupIndex];
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
                    item: item,
                    onTap: () => _showDetail(context, item),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: context.contentBold);
  }
}

final class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.item, required this.onTap});

  final _NotifItem item;
  final VoidCallback onTap;

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
                  const _AvatarPlaceholder(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: context.subtitleMedium),
                        if (item.subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
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
        if (item.isUnread)
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
  const _NotifDetailSheet({required this.item});

  final _NotifItem item;

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
              const SizedBox(
                width: 88,
                height: 88,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.neutral300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.title,
                style: context.featureBold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                item.body,
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
