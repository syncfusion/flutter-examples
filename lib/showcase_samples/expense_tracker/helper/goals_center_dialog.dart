import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../custom_widgets/custom_buttons.dart';
import '../custom_widgets/custom_drop_down_menu.dart';
import '../custom_widgets/text_field.dart';
// import '../data_processing/category_handler.dart';
import '../enum.dart';
// import '../models/category.dart';
import '../models/user.dart';
import '../notifiers/savings_notifier.dart';
import 'common_center_dialog.dart';
import 'responsive_layout.dart';

class GoalsCenterDialog extends StatefulWidget {
  const GoalsCenterDialog({
    required this.userInteraction,
    required this.userDetails,
    this.addButtonOnPressedEvent,
    super.key,
  });

  final void Function()? addButtonOnPressedEvent;
  final UserInteractions userInteraction;
  final UserDetails userDetails;

  @override
  State<GoalsCenterDialog> createState() => _GoalsCenterDialogState();
}

class _GoalsCenterDialogState extends State<GoalsCenterDialog> {
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

  Widget _addDialog() {
    return isMobile(context)
        ? _buildMobileContentDialog()
        : _buildBudgetAddCenterDialog();
  }

  Widget _buildDialogBox(BuildContext context) {
    return _buildContentDialog();
  }

  CustomTextField _buildBudgetTitleTextField() {
    return CustomTextField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      hintText: 'Title',
    );
  }

  Widget _buildCategoryDropdown([EdgeInsetsGeometry? expandedInsets]) {
    return Consumer<SavingsNotifier>(
      builder: (
        BuildContext context,
        SavingsNotifier savingsNotifier,
        Widget? child,
      ) {
        return CustomDropdown(
          items: widget.userDetails.userProfile.categoryStrings,
          expandedInsets: expandedInsets,
          hintText: 'Category',
          controller: _typeController,
          focusNode: _typeFocusNode,
          onSelected: (String? value) {},
        );
      },
    );
  }

  CustomTextField _buildAmountTextField() {
    return CustomTextField(
      controller: _amountController,
      hintText: 'Amount',
      focusNode: _amountFocusNode,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
      ],
    );
  }

  Widget _buildDateTextField() {
    return buildDateTextField(
      hintText: 'Date',
      focusNode: _dateFocusNode,
      dateController: _dateController,
      userDetails: widget.userDetails,
      context: context,
    );
  }

  CustomTextField _buildNotesTextField() {
    return CustomTextField(
      maxLines: 4,
      isRequired: false,
      controller: _remarkController,
      hintText: 'Notes',
      focusNode: _notesFocusNode,
      keyboardType: TextInputType.streetAddress,
    );
  }

  Widget _buildBudgetAddCenterDialog() {
    return CommonCenterDialog(
      dialogHeader:
          widget.userInteraction == UserInteractions.edit
              ? 'Edit Budget'
              : 'Create Budget',
      content: _buildDialogBox(context),
      actions: <Widget>[
        CustomTextActionButtons(
          onCancelAction: () => Navigator.pop(context),
          onAddOrEditAction: () {},
          showEditButton: widget.userInteraction == UserInteractions.edit,
        ),
      ],
    );
  }

  Widget _buildMobileContentDialog() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        spacing: 24.0,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: _buildBudgetTitleTextField(),
          ),
          _buildCategoryDropdown(EdgeInsets.zero),
          _buildAmountTextField(),
          _buildDateTextField(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _buildNotesTextField(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentDialog() {
    return Column(
      spacing: 24.0,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildFieldsAndDropdowns(
          _buildBudgetTitleTextField(),
          _buildCategoryDropdown(),
        ),
        _buildFieldsAndDropdowns(
          _buildAmountTextField(),
          _buildDateTextField(),
        ),
        _buildFieldsAndDropdowns(_buildNotesTextField()),
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
