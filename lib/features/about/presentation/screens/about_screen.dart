import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/content_args.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_nav_tile.dart';
import '../../../../core/widgets/app_primary_header.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../cubits/contact/contact_cubit.dart';

final class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _pageKeys = {
    'VALUES': 'VALUES',
    'VISION': 'VISION',
    'GOALS': 'GOALS',
    'TERMS': 'TERMS',
    'PRIVACY': 'PRIVACY',
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContactCubit>()..loadContactLinks(),
      child: AppScaffold(
        appBar: const AppPrimaryHeader(
          title: 'معلومات عن جلوري جيم',
          showBack: true,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: _AboutTileList(
            tiles: [
              _AboutTileData(
                iconAsset: 'about_us2.svg',
                label: 'من نحن',
                onTap: () => context.push(AppRoutes.whoWeAre),
              ),
              _AboutTileData(
                iconAsset: 'app_ratings_icon.svg',
                label: 'تقييمات التطبيق',
                onTap: () => _openAppRating(context),
              ),
              _AboutTileData(
                iconAsset: 'contact_us_icon.svg',
                label: 'تواصل معنا',
                onTap: () => context.push(
                  AppRoutes.whoWeAre,
                  extra: const WhoWeAreArgs(initialTab: 1),
                ),
              ),
              _AboutTileData(
                iconAsset: 'ourـvalue_icon.svg',
                label: 'قيمنا',
                onTap: () => _openPage(context, _pageKeys['VALUES']!),
              ),
              _AboutTileData(
                iconAsset: 'our_vision_icon.svg',
                label: 'رؤيتنا',
                onTap: () => _openPage(context, _pageKeys['VISION']!),
              ),
              _AboutTileData(
                iconAsset: 'our_goals_icon.svg',
                label: 'أهدافنا',
                onTap: () => _openPage(context, _pageKeys['GOALS']!),
              ),
              _AboutTileData(
                iconAsset: 'terms_and_conditions_icon.svg',
                label: 'الشروط والأحكام',
                onTap: () => _openPage(context, _pageKeys['TERMS']!),
              ),
              _AboutTileData(
                iconAsset: 'faq_icon.svg',
                label: 'الأسئلة الشائعة',
                onTap: () => context.push(AppRoutes.faq),
              ),
              _AboutTileData(
                iconAsset: 'privacy_policy_icon.svg',
                label: 'سياسة الخصوصية',
                onTap: () => _openPage(context, _pageKeys['PRIVACY']!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPage(BuildContext context, String pageKey) {
    context.push(
      AppRoutes.simpleContent,
      extra: SimpleContentArgs(pageKey: pageKey),
    );
  }

  Future<void> _openAppRating(BuildContext context) async {
    final links = context.read<ContactCubit>().state.links;
    final url = Platform.isIOS ? links?.appStore : links?.playStore;

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رابط التقييم غير متاح حالياً')),
      );
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح رابط التقييم')),
      );
    }
  }
}

final class _AboutTileData {
  const _AboutTileData({
    required this.iconAsset,
    required this.label,
    this.onTap,
  });

  final String iconAsset;
  final String label;
  final VoidCallback? onTap;
}

final class _AboutTileList extends StatelessWidget {
  const _AboutTileList({required this.tiles});

  final List<_AboutTileData> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          AppNavTile(
            iconAsset: tiles[i].iconAsset,
            label: tiles[i].label,
            onTap: tiles[i].onTap,
          ),
          if (i < tiles.length - 1)
            const Divider(height: 1, color: AppColors.neutral200),
        ],
      ],
    );
  }
}
