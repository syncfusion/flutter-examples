import 'package:flutter/material.dart';
import '../../../data_processing/budget_handler.dart';
import '../../../enum.dart';
import '../../../helper/common_center_dialog.dart';
import '../../../helper/responsive_layout.dart';
import '../../../models/budget.dart';
import '../../../models/user.dart';
import '../../../notifiers/import_notifier.dart';

/// Dialog card for confirming the deletion of a budget.
class DeleteBudgetDialog extends StatefulWidget {
  const DeleteBudgetDialog(
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
  State<DeleteBudgetDialog> createState() => _DeleteBudgetDialogState();
}

class _DeleteBudgetDialogState extends State<DeleteBudgetDialog> {
  late final Budget _budget;

  /// Determines content padding based on device type.
  double _getContentPadding(BuildContext context) {
    return isMobile(context) ? 16.0 : 24.0;
  }

  /// Builds the dialog content.
  Widget _buildDialogContent() {
    return const Center(child: Text('Do you want to delete this budget item'));
  }

  /// Constructs actions for the dialog.
  List<Widget> _buildDialogActions(BuildContext context) {
    return <Widget>[_buildCancelButton(context), _buildDeleteButton(context)];
  }

  /// Builds the Cancel button for the dialog.
  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    );
  }

  /// Builds the Delete button for the dialog.
  Widget _buildDeleteButton(BuildContext context) {
    return TextButton(
      onPressed: () => _confirmDelete(context),
      child: const Text('Delete', style: TextStyle(color: Colors.red)),
    );
  }

  /// Handles the delete confirmation and updates the budget.
  void _confirmDelete(BuildContext context) {
    updateBudgets(
      context,
      widget.userDetails,
      _budget,
      UserInteractions.delete,
      index: widget.currentIndex,
    );
    widget.importNotifier.updateDetails(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    _budget = widget.budget;
    super.initState();
  }

  /// Builds and displays the dialog.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CommonCenterDialog(
        contentPadding: _getContentPadding(context),
        dialogHeader: 'Delete Budget',
        content: _buildDialogContent(),
        actions: _buildDialogActions(context),
      ),
    );
  }
}
