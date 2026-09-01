import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/family_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/family_member_entity.dart';
import '../cubits/family_form/family_form_cubit.dart';
import 'package:glory_gym/core/l10n/l10n.dart';

final class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key, this.member});

  final FamilyMemberEntity? member;

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

final class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _relationController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGenderLabel;
  String? _selectedRelationLabel;

  bool get _isEditing => widget.member != null;

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty &&
      _selectedBirthDate != null &&
      _selectedGenderLabel != null &&
      _selectedRelationLabel != null;

  bool _memberFieldsInitialized = false;

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    if (member == null) return;

    _nameController.text = member.fullName;
    _selectedBirthDate = member.dateOfBirth;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_memberFieldsInitialized || widget.member == null) return;
    _memberFieldsInitialized = true;

    final member = widget.member!;
    final l10n = context.l10n;
    _birthDateController.text =
        FamilyUtils.formatBirthDate(l10n, member.dateOfBirth);
    _selectedGenderLabel = FamilyUtils.genderLabel(l10n, member.gender);
    _selectedRelationLabel =
        FamilyUtils.relationLabel(l10n, member.relation);
    _genderController.text = _selectedGenderLabel ?? '';
    _relationController.text = _selectedRelationLabel ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked == null) return;

    setState(() {
      _selectedBirthDate = picked;
      _birthDateController.text =
          FamilyUtils.formatBirthDate(context.l10n, picked);
    });
  }

  Future<void> _pickGender() async {
    final selected = await _showPickerSheet(
      title: context.l10n.type,
      items: FamilyUtils.genderLabels(context.l10n),
      selected: _selectedGenderLabel,
    );
    if (selected == null) return;
    setState(() {
      _selectedGenderLabel = selected;
      _genderController.text = selected;
    });
  }

  Future<void> _pickRelation() async {
    final selected = await _showPickerSheet(
      title: context.l10n.relationship,
      items: FamilyUtils.relationLabels(context.l10n),
      selected: _selectedRelationLabel,
    );
    if (selected == null) return;
    setState(() {
      _selectedRelationLabel = selected;
      _relationController.text = selected;
    });
  }

  Future<String?> _showPickerSheet({
    required String title,
    required List<String> items,
    required String? selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final maxHeight = MediaQuery.sizeOf(context).height * 0.55;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.neutral300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.neutral200),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: AppColors.neutral200,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item),
                        onTap: () => Navigator.of(context).pop(item),
                        trailing: selected == item
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit(BuildContext providerContext) async {
    final l10n = providerContext.l10n;
    final gender = FamilyUtils.genderValue(l10n, _selectedGenderLabel!);
    final relation =
        FamilyUtils.relationValue(l10n, _selectedRelationLabel!);
    if (gender == null || relation == null || _selectedBirthDate == null) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final success = await providerContext.read<FamilyFormCubit>().submit(
          existingMember: widget.member,
          fullName: _nameController.text.trim(),
          dateOfBirth: _selectedBirthDate!,
          gender: gender,
          relation: relation,
        );

    if (!providerContext.mounted) return;

    if (success) {
      providerContext.pop(true);
      return;
    }

    final error = providerContext.read<FamilyFormCubit>().state.errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(providerContext).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FamilyFormCubit>(),
      child: Builder(
        builder: (providerContext) {
          return AppScaffold(
            appBar: AppPrimaryHeader(
              title: _isEditing ? context.l10n.editFamilyMember : context.l10n.addFamilyMember,
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
                            label: context.l10n.fullName,
                            controller: _nameController,
                            hint: context.l10n.enterFullName,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: context.l10n.dateOfBirth,
                            controller: _birthDateController,
                            hint: context.l10n.enterDateOfBirth,
                            readOnly: true,
                            onTap: _pickDate,
                            suffixIcon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                              color: AppColors.neutral500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: context.l10n.type,
                            controller: _genderController,
                            hint: context.l10n.selectType,
                            readOnly: true,
                            onTap: _pickGender,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 22,
                              color: AppColors.neutral500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: context.l10n.relationship,
                            controller: _relationController,
                            hint: context.l10n.selectRelationship,
                            readOnly: true,
                            onTap: _pickRelation,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 22,
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<FamilyFormCubit, FamilyFormState>(
                    builder: (context, state) => AppButton(
                      label: _isEditing ? context.l10n.saveChanges : context.l10n.addNewMemberAlt,
                      isLoading: state.isSubmitting,
                      onPressed: _canSubmit && !state.isSubmitting
                          ? () => _submit(providerContext)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
