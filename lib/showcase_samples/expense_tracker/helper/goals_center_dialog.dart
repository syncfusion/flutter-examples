import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../custom_widgets/custom_buttons.dart';
import '../custom_widgets/custom_drop_down_menu.dart';
import '../custom_widgets/text_field.dart';
// import '../data_processing/goal_handler.dart'
//     if (dart.library.html) '../data_processing/goal_web_handler.dart';
import '../enum.dart';
import '../models/goal.dart';
import '../models/user.dart';
import '../notifiers/goal_notifier.dart';
import '../notifiers/text_field_valid_notifier.dart';
import 'common_center_dialog.dart';
import 'currency_and_data_format/currency_format.dart';
import 'currency_and_data_format/date_format.dart';
import 'responsive_layout.dart';

class GoalsCenterDialog extends StatefulWidget {
  const GoalsCenterDialog({
    required this.notifier,
    required this.validNotifier,
    required this.userInteraction,
    required this.userDetails,
    this.addButtonOnPressedEvent,
    this.selectedIndex = -1,
    this.isMobile = false,
    this.isAddExpense = false,
    super.key,
  });

  final void Function()? addButtonOnPressedEvent;
  final UserInteractions userInteraction;
  final UserDetails userDetails;
  final GoalNotifier notifier;
  final TextButtonValidNotifier validNotifier;
  final int selectedIndex;
  final bool isMobile;
  final bool isAddExpense;

  @override
  State<GoalsCenterDialog> createState() => _GoalsCenterDialogState();
}

class _GoalsCenterDialogState extends State<GoalsCenterDialog> {
  late FocusNode _nameFocusNode;
  late FocusNode _typeFocusNode;
  late FocusNode _notesFocusNode;
  late FocusNode _amountFocusNode;
  late FocusNode _dateFocusNode;
  late GoalNotifier _notifier;

  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _categoryController;
  late TextEditingController _dateController;
  late TextEditingController _remarkController;
  late TextEditingController _amountController;
  late ValueNotifier<bool> _goalFormIsValid;
  String? selectedValue;

  bool get _isMobileAddExpense => widget.isMobile && widget.isAddExpense;

  void _initializeTextFieldValues() {
    _notifier = widget.notifier;
    if (widget.selectedIndex != -1) {
      final Goal currentGoal = _notifier.visibleGoals[widget.selectedIndex];
      _notifier.goalTextFieldDetails = GoalTextFieldDetails(
        name: currentGoal.name,
        remarks: currentGoal.notes ?? '',
        date: currentGoal.date,
        amount: currentGoal.amount,
        priority: currentGoal.priority ?? 'Low',
        category: currentGoal.category,
      );
    } else {
      _notifier.goalTextFieldDetails = GoalTextFieldDetails(
        name: '',
        remarks: '',
        date: DateTime.now(),
        amount: 0,
        priority: 'Low',
        category: '',
      );
    }
  }

  Widget _addDialog() {
    return isMobile(context)
        ? _buildMobileContentDialog()
        : _buildGoalAddCenterDialog();
  }

  Widget _buildDialogBox(BuildContext context) {
    return _buildContentDialog();
  }

  Widget _buildGoalTitleTextField() {
    if (_shouldControllerReceiveValue()) {
      _setControllerTextValue(
        _nameController,
        _notifier.goalTextFieldDetails!.name,
      );
    }

    return CustomTextField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      hintText: 'Title',
      readOnly: widget.isMobile && widget.isAddExpense,
      canRequestFocus: !(widget.isMobile && widget.isAddExpense),
      onChanged: (String value) => _updateGoalDetails(value, 'name'),
    );
  }

  Widget _buildCategoryDropDown({EdgeInsetsGeometry? expandedInsets}) {
    if (_shouldControllerReceiveValue()) {
      _setControllerTextValue(
        _categoryController,
        _notifier.goalTextFieldDetails!.category,
      );
    }
    return CustomDropdown(
      items: widget.userDetails.userProfile.goalCategoryStrings,
      expandedInsets: expandedInsets,
      enable: !_isMobileAddExpense,
      hintText: 'Category',
      controller: _categoryController,
      focusNode: _typeFocusNode,
      onSelected: (String? value) {
        widget.notifier.goalTextFieldDetails?.category = value ?? '';
        final bool valid = _validateGoalForm();
        _goalFormIsValid.value = valid;
        widget.validNotifier.isTextButtonValid(valid);
      },
      selectedValue: widget.notifier.goalTextFieldDetails?.category,
    );
  }

  Widget _buildPriorityDropdown({EdgeInsetsGeometry? expandedInsets}) {
    if (_shouldControllerReceiveValue()) {
      _setControllerTextValue(
        _typeController,
        _notifier.goalTextFieldDetails!.priority,
      );
    }

    return CustomDropdown(
      items: const <String>['Low', 'High'],
      expandedInsets: expandedInsets,
      enable: !(widget.isMobile && widget.isAddExpense),
      hintText: 'Priority',
      controller: _typeController,
      focusNode: _typeFocusNode,
      onSelected: (String? value) =>
          _updateGoalDetails(value ?? '', 'priority'),
      selectedValue: selectedValue,
    );
  }

  Widget _buildAmountTextField() {
    if (_shouldControllerReceiveValue()) {
      _setControllerTextValue(
        _amountController,
        _notifier.goalTextFieldDetails!.amount.toString(),
      );
    }

    return CustomTextField(
      controller: _amountController,
      hintText: 'Target Amount',
      focusNode: _amountFocusNode,
      onChanged: (String value) => _updateGoalAmount(value),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
      ],
    );
  }

  Widget _buildDateTextField() {
    if (_shouldControllerReceiveValue()) {
      _setControllerTextValue(
        _dateController,
        formatDate(_notifier.goalTextFieldDetails!.date),
      );
    }

    return buildDateTextField(
      hintText: 'DeadLine',
      focusNode: _dateFocusNode,
      dateController: _dateController,
      userDetails: widget.userDetails,
      context: context,
      canSelectFutureDate: true,
      onChanged: (String value) => _updateGoalDate(value),
    );
  }

  Widget _buildNotesTextField() {
    if (_shouldControllerReceiveValue()) {
      _setControllerTextValue(
        _remarkController,
        _notifier.goalTextFieldDetails!.remarks,
      );
    }

    return CustomTextField(
      maxLines: 4,
      isRequired: false,
      controller: _remarkController,
      hintText: 'Remarks',
      focusNode: _notesFocusNode,
      keyboardType: TextInputType.streetAddress,
      onChanged: (String value) => _updateGoalDetails(value, 'remarks'),
      readOnly: widget.isMobile && widget.isAddExpense,
      canRequestFocus: !(widget.isMobile && widget.isAddExpense),
    );
  }

  void _setControllerTextValue(TextEditingController controller, String value) {
    controller.text = value;
  }

  void _updateGoalDetails(String value, String field) {
    if (field == 'name') {
      _notifier.goalTextFieldDetails!.name = value;
    } else if (field == 'priority') {
      _notifier.goalTextFieldDetails!.priority = value;
    } else if (field == 'remarks') {
      _notifier.goalTextFieldDetails!.remarks = value;
    }

    _validateAndNotify();
  }

  void _updateGoalAmount(String value) {
    if (value.isNotEmpty) {
      _notifier.goalTextFieldDetails!.amount = parseCurrency(
        value,
        widget.userDetails.userProfile,
      );
      _validateAndNotify();
    }
  }

  void _updateGoalDate(String value) {
    _notifier.goalTextFieldDetails!.date = DateFormat(
      widget.userDetails.userProfile.dateFormat,
    ).parse(value);
    _validateAndNotify();
  }

  void _validateAndNotify() {
    final bool isValid = _validateGoalForm();
    _goalFormIsValid.value = isValid;
    widget.validNotifier.isTextButtonValid(isValid);
  }

  bool _validateGoalForm() {
    if (widget.userInteraction == UserInteractions.edit) {
      final Goal currentGoal = _notifier.visibleGoals[widget.selectedIndex];
      return _nameController.text != currentGoal.name ||
          _amountController.text != currentGoal.amount.toString() ||
          _dateController.text != formatDate(currentGoal.date) ||
          _remarkController.text != currentGoal.notes ||
          _typeController.text != currentGoal.priority ||
          _categoryController.text != currentGoal.category;
    }
    if (widget.isAddExpense) {
      return _amountController.text.isNotEmpty;
    }
    return _nameController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty;
  }

  Widget _buildGoalAddCenterDialog() {
    final bool isEditing = widget.userInteraction == UserInteractions.edit;
    return CommonCenterDialog(
      dialogHeader: _dialogHeaderText(isEditing),
      onCloseIconPressed: _handleDialogClose,
      content: _buildDialogBox(context),
      actions: <Widget>[_buildActionButtons(isEditing)],
    );
  }

  String _dialogHeaderText(bool isEditing) {
    return isEditing ? 'Edit Goal' : 'Create Goal';
  }

  void _handleDialogClose() {
    Navigator.pop(context);
    widget.validNotifier.isTextButtonValid(false);
  }

  Widget _buildActionButtons(bool isEditing) {
    return ValueListenableBuilder<bool>(
      valueListenable: _goalFormIsValid,
      builder: (BuildContext context, bool isValid, Widget? child) {
        return CustomTextActionButtons(
          onCancelAction: _handleDialogClose,
          onAddOrEditAction: isValid
              ? () => _handleGoalAction(isEditing)
              : null,
          showEditButton: isEditing,
        );
      },
    );
  }

  bool _shouldControllerReceiveValue() {
    return (widget.userInteraction == UserInteractions.edit ||
            _isMobileAddExpense) &&
        widget.selectedIndex > -1 &&
        _notifier.goalTextFieldDetails != null;
  }

  void _handleGoalAction(bool isEditing) {
    final Goal goal = _createGoalFromInput();
    if (isEditing) {
      _editExistingGoal(goal);
    } else {
      _createNewGoal(goal);
    }
    widget.validNotifier.isTextButtonValid(false);
    Navigator.pop(context);
  }

  Goal _createGoalFromInput() {
    return Goal(
      name: _nameController.text,
      amount: parseCurrency(
        _amountController.text,
        widget.userDetails.userProfile,
      ),
      notes: _remarkController.text,
      priority: _typeController.text,
      date: DateFormat(
        widget.userDetails.userProfile.dateFormat,
      ).parse(_dateController.text),
      category: _categoryController.text,
    );
  }

  void _editExistingGoal(Goal goal) {
    final Goal currentGoal = _notifier.visibleGoals[widget.selectedIndex];
    goal.fund = currentGoal.fund;
    _notifier.editGoal(currentGoal, goal, widget.selectedIndex);
    // updateGoals(
    //   widget.userDetails,
    //   goal,
    //   widget.userInteraction,
    //   index: _notifier.currentIndex,
    // );
  }

  void _createNewGoal(Goal goal) {
    if (_notifier.isFirstTime) {
      _notifier.read(widget.userDetails);
    }
    _notifier.createGoal(goal);
    // updateGoals(widget.userDetails, goal, widget.userInteraction);
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
            child: _buildGoalTitleTextField(),
          ),
          _buildCategoryDropDown(expandedInsets: EdgeInsets.zero),
          _buildPriorityDropdown(expandedInsets: EdgeInsets.zero),
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
          _buildGoalTitleTextField(),
          _buildCategoryDropDown(),
        ),
        _buildAmountTextField(),
        _buildFieldsAndDropdowns(
          _buildPriorityDropdown(expandedInsets: EdgeInsets.zero),
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
    _categoryController = TextEditingController();
    _dateController = TextEditingController();
    _remarkController = TextEditingController();
    _amountController = TextEditingController();
    _goalFormIsValid = ValueNotifier<bool>(false);
    _nameController.addListener(_validateGoalForm);
    _amountController.addListener(_validateGoalForm);
    _dateController.addListener(_validateGoalForm);
    _initializeTextFieldValues();

    super.initState();
  }

  @override
  void dispose() {
    _typeFocusNode.dispose();

    _notesFocusNode.dispose();
    _amountFocusNode.dispose();
    _typeController.dispose();
    _categoryController.dispose();

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
