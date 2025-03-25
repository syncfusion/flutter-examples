import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data_processing/budget_handler.dart';
import '../../../enum.dart';
import '../../../helper/common_center_dialog.dart';
import '../../../helper/currency_and_data_format/currency_format.dart';
import '../../../helper/responsive_layout.dart';
import '../../../models/budget.dart';
import '../../../models/user.dart';
import '../../../notifiers/import_notifier.dart';
import '../../text_field.dart';

/// A dialog card for editing a budget's details.
class EditBudgetDialog extends StatefulWidget {
  const EditBudgetDialog(
    this.importNotifier,
    this.userDetails,
    this.budget,
    this.currentIndex, {
    super.key,
  });

  final Budget budget;
  final UserDetails userDetails;
  final ImportNotifier importNotifier;
  final int currentIndex;

  @override
  State<EditBudgetDialog> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  // Focus nodes for different input fields.
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _remarkFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  late Budget _currentBudget;

  /// Initializes text fields with budget details.
  void _initializeTextFields() {
    _nameController.text = _currentBudget.name;
    _amountController.text = _currentBudget.target.toString();
    _remarkController.text = _currentBudget.notes ?? '';
  }

  /// Determines content padding based on device type.
  double _getContentPadding(BuildContext context) {
    return isMobile(context) ? 16.0 : 24.0;
  }

  /// Builds the dialog content.
  Widget _buildDialogContent() {
    return Column(
      spacing: 8.0,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildBudgetNameTextField(),
        _buildLocationTextField(),
        _buildAmountTextField(),
      ],
    );
  }

  /// Builds the budget name text field.
  CustomTextField _buildBudgetNameTextField() {
    return CustomTextField(
      controller: _nameController,
      hintText: 'Budget Name',
      focusNode: _nameFocusNode,
      keyboardType: TextInputType.streetAddress,
    );
  }

  /// Builds the location (notes) text field.
  CustomTextField _buildLocationTextField() {
    return CustomTextField(
      controller: _remarkController,
      hintText: 'Notes',
      focusNode: _remarkFocusNode,
      keyboardType: TextInputType.streetAddress,
    );
  }

  /// Builds the amount text field.
  CustomTextField _buildAmountTextField() {
    return CustomTextField(
      controller: _amountController,
      hintText: 'Amount *',
      focusNode: _amountFocusNode,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
      ],
    );
  }

  /// Builds action buttons for the dialog.
  List<Widget> _buildDialogActions() {
    return <Widget>[_buildCancelButton(), _buildEditButton()];
  }

  /// Builds the Cancel button.
  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    );
  }

  /// Builds the Edit button.
  Widget _buildEditButton() {
    return TextButton(
      onPressed: _handleEditButtonPressed,
      child: const Text('Save'),
    );
  }

  /// Handles the edit button press action.
  void _handleEditButtonPressed() {
    final double amount = parseCurrency(
      _amountController.text,
      widget.userDetails.userProfile,
    );
    final String name = _nameController.text;
    final String notes = _remarkController.text;

    _currentBudget
      ..target = amount
      ..name = name
      ..notes = notes;

    updateBudgets(
      context,
      widget.userDetails,
      _currentBudget,
      UserInteractions.edit,
      index: widget.currentIndex,
    );
    widget.importNotifier.updateDetails(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _currentBudget = widget.budget;
    _initializeTextFields();
    super.initState();
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _remarkFocusNode.dispose();
    _nameFocusNode.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  /// Builds and displays the dialog UI.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CommonCenterDialog(
        contentPadding: _getContentPadding(context),
        dialogHeader: 'Edit Budget',
        content: _buildDialogContent(),
        actions: _buildDialogActions(),
      ),
    );
  }
}
