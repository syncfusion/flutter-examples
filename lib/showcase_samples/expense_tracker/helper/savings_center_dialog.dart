import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../custom_widgets/custom_buttons.dart';
import '../custom_widgets/custom_drop_down_menu.dart';
import '../custom_widgets/text_field.dart';
// import '../data_processing/saving_handler.dart'
//     if (dart.library.html) '../data_processing/saving_web_handler.dart';
import '../enum.dart';
import '../models/saving.dart';
import '../models/user.dart';
import '../notifiers/savings_notifier.dart';
import '../notifiers/text_field_valid_notifier.dart';
import 'common_center_dialog.dart';
import 'currency_and_data_format/currency_format.dart';
import 'predefined_categories.dart';
import 'responsive_layout.dart';

class SavingsCenterDialog extends StatefulWidget {
  const SavingsCenterDialog({
    required this.notifier,
    required this.selectedCountNotifier,
    required this.validNotifier,
    required this.userInteraction,
    required this.userDetails,
    this.addButtonOnPressedEvent,
    this.selectedIndex = -1,
    super.key,
  });

  final void Function()? addButtonOnPressedEvent;
  final SavingsNotifier notifier;
  final TextButtonValidNotifier validNotifier;
  final SavingsSelectedCountNotifier selectedCountNotifier;
  final UserInteractions userInteraction;
  final UserDetails userDetails;
  final int selectedIndex;

  @override
  State<SavingsCenterDialog> createState() => _SavingsCenterDialogState();
}

class _SavingsCenterDialogState extends State<SavingsCenterDialog> {
  late FocusNode _nameFocusNode;
  late FocusNode _typeFocusNode;
  late FocusNode _notesFocusNode;
  late FocusNode _amountFocusNode;
  late FocusNode _dateFocusNode;

  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _dateController;
  late TextEditingController _remarkController;
  late TextEditingController _amountController;
  late List<String> _type;
  late ValueNotifier<bool> _savingsFormIsValid;

  void _initializeTextFieldValues() {
    if (widget.selectedIndex != -1) {
      final Saving currentSavings =
          widget.notifier.filteredSavings[widget.selectedIndex];
      widget.notifier.savingsTextFieldDetails = SavingsTextFieldDetails(
        name: currentSavings.name,
        remarks: currentSavings.remark,
        type: currentSavings.type,
        date: currentSavings.savingDate,
        amount: currentSavings.savedAmount,
      );
    } else {
      widget.notifier.savingsTextFieldDetails = SavingsTextFieldDetails(
        name: '',
        remarks: '',
        type: '',
        date: DateTime.now(),
        amount: 0,
      );
    }
  }

  Widget _addDialog() {
    return isMobile(context)
        ? _buildMobileContentDialog()
        : _buildSavingsAddCenterDialog();
  }

  Widget _buildDialogBox(BuildContext context) {
    return _buildContentDialog();
  }

  CustomTextField _buildSavingNameTextField({bool isEdit = false}) {
    if (isEdit &&
        _nameController.text == '' &&
        widget.notifier.savingsTextFieldDetails != null) {
      _nameController.text = widget.notifier.savingsTextFieldDetails!.name;
    }
    return CustomTextField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      hintText: 'Name',
      onChanged: (String value) {
        widget.notifier.savingsTextFieldDetails?.name = value;
        final bool valid = _validateTextField();
        _savingsFormIsValid.value = valid;
        widget.validNotifier.isTextButtonValid(valid);
      },
    );
  }

  Widget _buildSavingsTypeDropDown({
    EdgeInsetsGeometry? expandedInsets,
    bool isEdit = false,
  }) {
    if (isEdit &&
        _typeController.text == '' &&
        widget.notifier.savingsTextFieldDetails != null) {
      _typeController.text = widget.notifier.savingsTextFieldDetails!.type;
    }
    return CustomDropdown(
      items: _type,
      expandedInsets: expandedInsets,
      hintText: 'Type',
      controller: _typeController,
      focusNode: _typeFocusNode,
      onSelected: (String? value) {
        widget.notifier.selectedType = value;
        widget.notifier.savingsTextFieldDetails?.type = value ?? '';
        final bool valid = _validateTextField();
        _savingsFormIsValid.value = valid;
        widget.validNotifier.isTextButtonValid(valid);
      },
      selectedValue: widget.notifier.selectedType,
    );
  }

  CustomTextField _buildAmountTextField({bool isEdit = false}) {
    if (isEdit &&
        _amountController.text == '' &&
        widget.notifier.savingsTextFieldDetails != null) {
      _amountController.text = widget.notifier.savingsTextFieldDetails!.amount
          .toString();
    }
    return CustomTextField(
      controller: _amountController,
      hintText: 'Amount',
      focusNode: _amountFocusNode,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
      ],
      onChanged: (String value) {
        if (value.isNotEmpty) {
          widget.notifier.savingsTextFieldDetails?.amount = parseCurrency(
            value,
            widget.userDetails.userProfile,
          );
          final bool valid = _validateTextField();
          _savingsFormIsValid.value = valid;
          widget.validNotifier.isTextButtonValid(valid);
        }
      },
    );
  }

  Widget _buildDateTextField({bool isEdit = false}) {
    if (isEdit &&
        _dateController.text == '' &&
        widget.notifier.savingsTextFieldDetails != null) {
      _dateController.text = formatDate(
        widget.notifier.savingsTextFieldDetails!.date,
      );
    }
    return buildDateTextField(
      hintText: 'Date',
      focusNode: _dateFocusNode,
      dateController: _dateController,
      userDetails: widget.userDetails,
      context: context,
      onChanged: (String value) {
        widget.notifier.savingsTextFieldDetails?.date = DateFormat(
          widget.userDetails.userProfile.dateFormat,
        ).parse(value);
        final bool valid = _validateTextField();
        _savingsFormIsValid.value = valid;
        widget.validNotifier.isTextButtonValid(valid);
      },
    );
  }

  CustomTextField _buildNotesTextField({bool isEdit = false}) {
    if (isEdit &&
        _remarkController.text == '' &&
        widget.notifier.savingsTextFieldDetails != null) {
      _remarkController.text = widget.notifier.savingsTextFieldDetails!.remarks;
    }
    return CustomTextField(
      maxLines: 4,
      isRequired: false,
      controller: _remarkController,
      hintText: 'Notes',
      focusNode: _notesFocusNode,
      keyboardType: TextInputType.streetAddress,
      onChanged: (String value) {
        widget.notifier.savingsTextFieldDetails?.remarks = value;
        if (isEdit) {
          final bool valid = _validateTextField();
          _savingsFormIsValid.value = valid;
          widget.validNotifier.isTextButtonValid(valid);
        }
      },
    );
  }

  Widget _buildMobileContentDialog() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 24.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: _buildSavingNameTextField(
                isEdit: widget.userInteraction == UserInteractions.edit,
              ),
            ),
            _buildSavingsTypeDropDown(
              expandedInsets: EdgeInsets.zero,
              isEdit: widget.userInteraction == UserInteractions.edit,
            ),
            _buildAmountTextField(
              isEdit: widget.userInteraction == UserInteractions.edit,
            ),
            _buildDateTextField(
              isEdit: widget.userInteraction == UserInteractions.edit,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: _buildNotesTextField(
                isEdit: widget.userInteraction == UserInteractions.edit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsAddCenterDialog() {
    return CommonCenterDialog(
      dialogHeader: widget.userInteraction == UserInteractions.edit
          ? 'Edit Saving'
          : 'Create Saving',
      onCloseIconPressed: () {
        widget.validNotifier.isTextButtonValid(false);
        widget.selectedCountNotifier.countChecking(0);
        Navigator.pop(context);
      },
      content: _buildDialogBox(context),
      actions: <Widget>[
        ValueListenableBuilder(
          valueListenable: _savingsFormIsValid,
          builder: (context, isValid, child) {
            return CustomTextActionButtons(
              onCancelAction: () {
                widget.validNotifier.isTextButtonValid(false);
                Navigator.pop(context);
              },
              onAddOrEditAction: isValid
                  ? () async {
                      final Saving saving = Saving(
                        name: _nameController.text,
                        savedAmount: parseCurrency(
                          _amountController.text,
                          widget.userDetails.userProfile,
                        ),
                        type: _typeController.text,
                        remark: _remarkController.text,
                        savingDate: DateFormat(
                          widget.userDetails.userProfile.dateFormat,
                        ).parse(_dateController.text),
                      );
                      final List<Saving> savings =
                          widget.userDetails.transactionalData.data.savings;
                      if (widget.userInteraction == UserInteractions.edit) {
                        widget.notifier.editSavings(
                          widget.selectedIndex,
                          saving,
                        );
                        widget.selectedCountNotifier.countChecking(0);
                        // updateSavings(
                        //   widget.userDetails,
                        //   saving,
                        //   widget.userInteraction,
                        //   widget.notifier.selectedIndexes,
                        // );
                      } else {
                        savings.add(saving);
                        widget.notifier.updateSavings(savings);
                        // updateSavings(
                        //   widget.userDetails,
                        //   saving,
                        //   widget.userInteraction,
                        //   <int>[],
                        // );
                      }
                      widget.validNotifier.isTextButtonValid(false);
                      Navigator.pop(context);
                    }
                  : null,
              showEditButton: widget.userInteraction == UserInteractions.edit,
            );
          },
        ),
      ],
    );
  }

  Widget _buildContentDialog() {
    return Column(
      spacing: 24.0,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildFieldsAndDropdowns(
          _buildSavingNameTextField(
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
          _buildSavingsTypeDropDown(
            expandedInsets: EdgeInsets.zero,
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
        ),
        _buildFieldsAndDropdowns(
          _buildAmountTextField(
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
          _buildDateTextField(
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
        ),
        _buildFieldsAndDropdowns(
          _buildNotesTextField(
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldsAndDropdowns(Widget firstChild, [Widget? secondChild]) {
    return Row(
      spacing: 16.0,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: firstChild),
        if (secondChild != null) Expanded(child: secondChild),
      ],
    );
  }

  bool _validateTextField() {
    if (widget.userInteraction == UserInteractions.edit) {
      final Saving currentSaving =
          widget.notifier.filteredSavings[widget.selectedIndex];
      return _nameController.text != currentSaving.name ||
          _typeController.text != currentSaving.type ||
          _amountController.text != currentSaving.savedAmount.toString() ||
          _dateController.text != formatDate(currentSaving.savingDate) ||
          _remarkController.text != currentSaving.remark;
    }
    return _nameController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _dateController.text.isNotEmpty;
  }

  @override
  void initState() {
    _typeFocusNode = FocusNode();
    _dateFocusNode = FocusNode();
    _amountFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    _notesFocusNode = FocusNode();

    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _dateController = TextEditingController();
    _remarkController = TextEditingController();
    _amountController = TextEditingController();
    _type = <String>['Deposit', 'Withdraw'];
    _savingsFormIsValid = ValueNotifier<bool>(false);
    _nameController.addListener(_validateTextField);
    _typeController.addListener(_validateTextField);
    _dateController.addListener(_validateTextField);
    _amountController.addListener(_validateTextField);
    _initializeTextFieldValues();
    super.initState();
  }

  @override
  void dispose() {
    _typeFocusNode.dispose();
    _notesFocusNode.dispose();
    _amountFocusNode.dispose();
    _typeController.dispose();
    _dateController.dispose();
    _remarkController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _addDialog();
  }
}
