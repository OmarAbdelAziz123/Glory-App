import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';
import 'package:go_router/go_router.dart';

final class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _faqs = [
    _FaqItem(
      question: 'كيف يمكنني الاشتراك في جلوري جيم؟',
      answer:
          'يمكنك الاشتراك عبر التطبيق مباشرةً من قسم الاشتراكات، أو زيارة أحد فروعنا والتحدث مع فريق الاستقبال.',
    ),
    _FaqItem(
      question: 'هل يمكنني تجميد اشتراكي؟',
      answer:
          'نعم، يمكنك تجميد اشتراكك لمدة تصل إلى 30 يوماً في السنة. يمكن طلب التجميد من خلال قسم الاشتراكات في التطبيق أو التواصل مع الإدارة.',
    ),
    _FaqItem(
      question: 'ما هي أوقات عمل الجيم؟',
      answer:
          'يعمل جلوري جيم من السبت إلى الخميس من 6 صباحاً حتى 12 منتصف الليل، وأيام الجمعة من 2 ظهراً حتى 12 منتصف الليل.',
    ),
    _FaqItem(
      question: 'هل تتوفر حصص للمبتدئين؟',
      answer:
          'بالتأكيد! نوفر برامج تدريبية خاصة بالمبتدئين تشمل جلسات توجيهية مع مدربين متخصصين لضمان البداية الصحيحة والآمنة.',
    ),
    _FaqItem(
      question: 'كيف يمكنني إلغاء حجز حصة؟',
      answer:
          'يمكنك إلغاء الحجز من خلال قسم الحجوزات في التطبيق قبل 2 ساعة على الأقل من موعد الحصة دون أي رسوم.',
    ),
    _FaqItem(
      question: 'هل تتوفر خزائن لحفظ المتعلقات؟',
      answer:
          'نعم، يتوفر في جميع فروعنا خزائن مجانية يمكن استخدامها خلال فترة تواجدك في الجيم.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'الأسئلة الشائعة',
        showBack: true,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: _faqs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  _FaqAccordion(item: _faqs[index]),
            ),
          ),
          _BottomComplaintsButton(
            onTap: () => context.push(AppRoutes.complaints),
          ),
        ],
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

final class _FaqItem {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _FaqAccordion extends StatefulWidget {
  const _FaqAccordion({required this.item});

  final _FaqItem item;

  @override
  State<_FaqAccordion> createState() => _FaqAccordionState();
}

final class _FaqAccordionState extends State<_FaqAccordion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.question,
                      style: context.captionBold.copyWith(
                        color: AppColors.neutral900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.neutral700,
                      size: 22,
                    ),
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.neutral200),
                const SizedBox(height: 10),
                Text(
                  widget.item.answer,
                  style: context.captionRegular.copyWith(
                    color: AppColors.neutral600,
                    height: 1.7,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

final class _BottomComplaintsButton extends StatelessWidget {
  const _BottomComplaintsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.neutral200)),
      ),
      child: AppButton(
        label: 'شكاوي و اقتراحات',
        onPressed: onTap,
      ),
    );
  }
}
