import 'package:flutter/material.dart';
import 'package:glory_gym/core/core.dart';

final class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

final class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();

  String? _selectedGender;
  String? _selectedRelationship;

  static const _genders = ['ذكر', 'أنثى'];
  static const _relationships = ['ابن', 'ابنة', 'أب', 'أم', 'أخ', 'أخت', 'زوج', 'زوجة'];

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty &&
      _birthDateController.text.trim().isNotEmpty &&
      _selectedGender != null &&
      _selectedRelationship != null;

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _birthDateController.text =
          '${picked.day} / ${picked.month} / ${picked.year}';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppPrimaryHeader(
        title: 'اضافة فراد للعائلة',
        showBack: true,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'اسم الكامل',
                      controller: _nameController,
                      hint: 'قم بإدخال الاسم الكامل',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'تاريخ الميلاد',
                      controller: _birthDateController,
                      hint: 'قم بإدخال تاريخ الميلاد',
                      readOnly: true,
                      onTap: _pickDate,
                      suffixIcon: const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: AppColors.neutral500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DropdownField(
                      label: 'النوع',
                      hint: 'قم بختيار النوع',
                      value: _selectedGender,
                      items: _genders,
                      onChanged: (v) => setState(() => _selectedGender = v),
                    ),
                    const SizedBox(height: 16),
                    _DropdownField(
                      label: 'العلاقة',
                      hint: 'قم بختيار العلاقة',
                      value: _selectedRelationship,
                      items: _relationships,
                      onChanged: (v) =>
                          setState(() => _selectedRelationship = v),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'أضافة عضو جديد',
              onPressed: _canSubmit ? () => Navigator.of(context).pop() : null,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

final class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: context.highlightEmphasis),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.neutral500,
              ),
              hint: Text(
                hint,
                style: context.contentRegular.copyWith(
                  color: AppColors.neutral400,
                ),
              ),
              style: context.contentRegular.copyWith(
                color: AppColors.neutral900,
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
