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

/// Dialog card for adding expense to a budget item.
class AddExpenseDialogCard extends StatefulWidget {
  const AddExpenseDialogCard({
    super.key,
    required this.user,
    required this.budget,
    required this.index,
    required this.importNotifier,
  });

  final Budget budget;
  final UserDetails user;
  final ImportNotifier importNotifier;
  final int index;

  @override
  State<AddExpenseDialogCard> createState() => _AddExpenseDialogCardState();
}

class _AddExpenseDialogCardState extends State<AddExpenseDialogCard> {
  // Focus nodes for form fields
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _remarkFocusNode = FocusNode();

  // Controllers for form fields
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  late Budget _currentBudget;

  /// Determines the content padding based on device type.
  double _getContentPadding(BuildContext context) {
    return isMobile(context) ? 16.0 : 24.0;
  }

  /// Builds content of the dialog.
  Widget _buildDialogContent() {
    return Column(
      spacing: 8.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBudgetNameTextField(),
        _buildLocationTextField(),
        _buildAmountTextField(),
      ],
    );
  }

  /// Builds text field displaying budget name.
  CustomTextField _buildBudgetNameTextField() {
    return CustomTextField(
      controller: _remarkController,
      hintText: widget.budget.name,
      focusNode: _remarkFocusNode,
      enabled: false,
    );
  }

  /// Builds text field displaying location notes.
  CustomTextField _buildLocationTextField() {
    return CustomTextField(
      controller: _remarkController,
      hintText: _currentBudget.notes ?? '',
      focusNode: _remarkFocusNode,
      enabled: false,
    );
  }

  /// Builds text field for the budget amount.
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

  /// Creates actions for the dialog.
  List<Widget> _buildDialogActions(BuildContext context) {
    return <Widget>[
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => _handleAddExpense(context),
        child: const Text('Add'),
      ),
    ];
  }

  /// Handles adding an expense.
  void _handleAddExpense(BuildContext context) {
    final double amount = parseCurrency(
      _amountController.text,
      widget.user.userProfile,
    );
    _currentBudget.expense += amount;
    updateBudgetExpense(
      context,
      widget.user,
      _currentBudget,
      UserInteractions.add,
      index: widget.index,
    );
    widget.importNotifier.updateDetails(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _currentBudget = widget.budget;
    super.initState();
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    _remarkFocusNode.dispose();
    _amountController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  /// Builds the UI for the dialog.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CommonCenterDialog(
        contentPadding: _getContentPadding(context),
        dialogHeader: 'Add Expense',
        content: _buildDialogContent(),
        actions: _buildDialogActions(context),
      ),
    );
  }
}
