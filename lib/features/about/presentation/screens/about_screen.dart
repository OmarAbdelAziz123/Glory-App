import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_nav_tile.dart';
import '../../../../../core/widgets/app_primary_header.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import 'simple_content_screen.dart';

final class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
            ),
            _AboutTileData(
              iconAsset: 'contact_us_icon.svg',
              label: 'تواصل معنا',
              onTap: () => context.push(AppRoutes.whoWeAre),
            ),
            _AboutTileData(
              iconAsset: 'ourـvalue_icon.svg',
              label: 'قيمنا',
              onTap: () => context.push(
                AppRoutes.simpleContent,
                extra: const SimpleContentArgs(
                  title: 'قيمنا',
                  content:
                      'نؤمن في جلوري جيم بمجموعة من القيم الجوهرية التي توجه كل ما نقوم به:\n\n'
                      '• التميز: نسعى دائماً لتقديم أعلى مستويات الجودة في خدماتنا وبرامجنا التدريبية.\n\n'
                      '• الشمولية: نرحب بجميع المستويات اللياقية ونؤمن بأن كل شخص يستحق بيئة تدريبية داعمة.\n\n'
                      '• الأمانة: نبني علاقات قائمة على الشفافية والثقة مع أعضائنا ومجتمعنا.\n\n'
                      '• الابتكار: نواكب أحدث الأساليب والتقنيات في مجال اللياقة البدنية.',
                ),
              ),
            ),
            _AboutTileData(
              iconAsset: 'our_vision_icon.svg',
              label: 'رؤيتنا',
              onTap: () => context.push(
                AppRoutes.simpleContent,
                extra: const SimpleContentArgs(
                  title: 'رؤيتنا',
                  content:
                      'رؤيتنا في جلوري جيم أن نكون المقصد الأول للياقة البدنية والصحة في المنطقة، من خلال تقديم تجربة رياضية متكاملة تجمع بين أحدث الأجهزة والمعدات وأكفأ المدربين المتخصصين.\n\n'
                      'نسعى إلى بناء مجتمع صحي متماسك يشجع الأفراد على تحقيق أهدافهم اللياقية والحفاظ على أسلوب حياة نشط ومتوازن.',
                ),
              ),
            ),
            _AboutTileData(
              iconAsset: 'our_goals_icon.svg',
              label: 'أهدافنا',
              onTap: () => context.push(
                AppRoutes.simpleContent,
                extra: const SimpleContentArgs(
                  title: 'أهدافنا',
                  content:
                      'نعمل في جلوري جيم على تحقيق أهداف واضحة تخدم أعضاءنا ومجتمعنا:\n\n'
                      '• توفير بيئة تدريبية عالمية المستوى تلبي احتياجات جميع الأعمار والمستويات.\n\n'
                      '• تطوير برامج تدريبية متخصصة تحقق نتائج ملموسة وفق أحدث الأساليب العلمية.\n\n'
                      '• بناء مجتمع رياضي متكامل يدعم الأعضاء في رحلتهم نحو اللياقة والصحة.\n\n'
                      '• التوسع المستمر لخدمة أكبر شريحة ممكنة من المجتمع.',
                ),
              ),
            ),
            _AboutTileData(
              iconAsset: 'terms_and_conditions_icon.svg',
              label: 'الشروط والأحكام',
              onTap: () => context.push(
                AppRoutes.simpleContent,
                extra: const SimpleContentArgs(
                  title: 'الشروط والأحكام',
                  content:
                      'يُرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام خدمات جلوري جيم.\n\n'
                      '١. العضوية: تسري الاشتراكات من تاريخ التسجيل ولا يمكن تحويلها لأشخاص آخرين.\n\n'
                      '٢. الإلغاء والاسترداد: يمكن إلغاء العضوية خلال 14 يوماً من تاريخ الاشتراك مع استرداد كامل للمبلغ.\n\n'
                      '٣. قواعد السلوك: يلتزم الأعضاء باحترام الآخرين والمحافظة على النظافة والأدوات.\n\n'
                      '٤. الإصابات والمسؤولية: يتحمل العضو مسؤولية سلامته الشخصية، وتنصح الإدارة باستشارة طبية قبل البدء.\n\n'
                      '٥. التعديلات: تحتفظ الإدارة بحق تعديل الشروط مع إخطار الأعضاء مسبقاً.',
                ),
              ),
            ),
            _AboutTileData(
              iconAsset: 'faq_icon.svg',
              label: 'الأسئلة الشائعة',
              onTap: () => context.push(AppRoutes.faq),
            ),
            _AboutTileData(
              iconAsset: 'privacy_policy_icon.svg',
              label: 'سياسة الخصوصية',
              onTap: () => context.push(
                AppRoutes.simpleContent,
                extra: const SimpleContentArgs(
                  title: 'سياسة الخصوصية',
                  content:
                      'نحن في جلوري جيم نولي أهمية قصوى لخصوصية بياناتك الشخصية.\n\n'
                      'البيانات التي نجمعها: نجمع البيانات الضرورية فقط لتقديم خدماتنا، بما يشمل المعلومات الشخصية وبيانات الاشتراك والنشاط الرياضي.\n\n'
                      'استخدام البيانات: تُستخدم بياناتك حصرياً لتحسين تجربتك وتخصيص البرامج التدريبية وإرسال الإشعارات المتعلقة بخدماتنا.\n\n'
                      'حماية البيانات: نطبق أحدث معايير الأمان لحماية بياناتك من أي وصول غير مصرح به.\n\n'
                      'حقوقك: يحق لك الاطلاع على بياناتك أو تعديلها أو حذفها في أي وقت عبر التواصل مع فريق الدعم.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

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

// ── Private widgets ───────────────────────────────────────────────────────────

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
