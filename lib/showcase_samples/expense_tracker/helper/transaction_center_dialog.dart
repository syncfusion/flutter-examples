import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import '../custom_widgets/custom_buttons.dart';
import '../custom_widgets/custom_drop_down_menu.dart';
import '../custom_widgets/text_field.dart';
// import '../data_processing/transaction_handler.dart'
//     if (dart.library.html) '../data_processing/transaction_web_handler.dart';
import '../enum.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../notifiers/text_field_valid_notifier.dart';
import '../notifiers/transaction_notifier.dart';
import 'common_center_dialog.dart';
import 'currency_and_data_format/currency_format.dart';
import 'currency_and_data_format/date_format.dart';
import 'responsive_layout.dart';

class ResponsiveTransactionCenterDialog extends StatelessWidget {
  const ResponsiveTransactionCenterDialog({
    required this.userInteraction,
    required this.userDetails,
    required this.categories,
    required this.subCategories,
    required this.selectedCountNotifier,
    required this.validNotifier,
    required this.notifier,
    this.selectedIndex = -1,
    this.addButtonOnPressedEvent,
    super.key,
  });

  final UserInteractions userInteraction;
  final UserDetails userDetails;
  final List<String> categories;
  final List<String> subCategories;
  final TransactionNotifier notifier;
  final TextButtonValidNotifier validNotifier;
  final int selectedIndex;
  final TransactionSelectedCountNotifier selectedCountNotifier;
  final void Function()? addButtonOnPressedEvent;

  @override
  Widget build(BuildContext context) {
    return TransactionCenterDialog(
      userInteraction: userInteraction,
      userDetails: userDetails,
      categories: categories,
      subCategories: subCategories,
      notifier: notifier,
      validNotifier: validNotifier,
      selectedIndex: selectedIndex,
      selectedCountNotifier: selectedCountNotifier,
    );
  }
}

class TransactionCenterDialog extends StatefulWidget {
  const TransactionCenterDialog({
    required this.userInteraction,
    required this.userDetails,
    required this.categories,
    required this.subCategories,
    required this.selectedCountNotifier,
    required this.validNotifier,
    this.addButtonOnPressedEvent,
    required this.notifier,
    this.selectedIndex = -1,
    this.selectedTransaction,
    super.key,
  });

  final void Function()? addButtonOnPressedEvent;
  final UserInteractions userInteraction;
  final UserDetails userDetails;
  final List<String> categories;
  final List<String> subCategories;
  final int selectedIndex;
  final TransactionNotifier notifier;
  final TextButtonValidNotifier validNotifier;
  final TransactionSelectedCountNotifier selectedCountNotifier;
  final Transaction? selectedTransaction;

  @override
  State<TransactionCenterDialog> createState() =>
      _TransactionCenterDialogState();
}

class _TransactionCenterDialogState extends State<TransactionCenterDialog> {
  late FocusNode _typeFocusNode;
  late FocusNode _categoryFocusNode;
  late FocusNode _subCategoryFocusNode;
  late FocusNode _remarkFocusNode;
  late FocusNode _amountFocusNode;
  late TextEditingController _typeController;
  late TextEditingController _categoryController;
  late TextEditingController _subCategoryController;
  late TextEditingController _dateController;
  late TextEditingController _remarkController;
  late TextEditingController _amountController;
  late List<String> _type;
  late ValueNotifier<int> _categoryCount;
  late ValueNotifier<int> _subCategoryCount;
  late ValueNotifier<bool> _formIsValid;

  String? typeSelectedValue;
  String? categorySelectedValue;
  String? subCategorySelectedValue;

  void _initializeTextFieldValues() {
    if (widget.selectedIndex != -1) {
      final Transaction currentTransaction =
          widget.notifier.filteredTransactions[widget.selectedIndex];
      widget.notifier.transactionTextFieldDetails = TransactionTextFieldDetails(
        type: currentTransaction.type,
        remarks: currentTransaction.remark,
        category: currentTransaction.category,
        subCategory: currentTransaction.subCategory,
        date: currentTransaction.transactionDate,
        amount: currentTransaction.amount,
      );
    } else {
      widget.notifier.transactionTextFieldDetails = TransactionTextFieldDetails(
        type: '',
        remarks: '',
        category: '',
        subCategory: '',
        date: DateTime.now(),
        amount: 0,
      );
    }
  }

  Widget _addDialog() {
    return isMobile(context)
        ? _buildMobileContentDialog()
        : _buildTransactionAddCenterDialog();
  }

  Widget _buildTransactionAddCenterDialog() {
    return CommonCenterDialog(
      dialogHeader: widget.userInteraction == UserInteractions.add
          ? 'Create Transaction'
          : 'Edit Transaction',
      onCloseIconPressed: () {
        widget.validNotifier.isTextButtonValid(false);
        widget.selectedCountNotifier.countChecking(0);
        Navigator.pop(context);
      },
      content: _buildContentDialog(),
      actions: <Widget>[_buildDialogActionButtons()],
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
              child: _buildTransactionTypeDropDown(
                isEdit: widget.userInteraction == UserInteractions.edit,
              ),
            ),
            _buildCategoryDropDown(
              isEdit: widget.userInteraction == UserInteractions.edit,
            ),
            _buildSubCategoryDropDown(
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

  Widget _buildContentDialog() {
    return Column(
      spacing: 24.0,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildFieldsAndDropdowns(
          _buildTransactionTypeDropDown(
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
          _buildCategoryDropDown(
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
        ),
        _buildFieldsAndDropdowns(
          _buildSubCategoryDropDown(
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
          _buildAmountTextField(
            isEdit: widget.userInteraction == UserInteractions.edit,
          ),
        ),
        _buildFieldsAndDropdowns(
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

  CustomDropdown _buildTransactionTypeDropDown({bool isEdit = false}) {
    if (isEdit && widget.notifier.transactionTextFieldDetails != null) {
      _typeController.text = widget.notifier.transactionTextFieldDetails!.type;
    }

    return CustomDropdown(
      items: _type,
      expandedInsets: EdgeInsets.zero,
      hintText: 'Type',
      controller: _typeController,
      focusNode: _typeFocusNode,
      onSelected: (String? value) {
        widget.notifier.transactionTextFieldDetails?.type = value ?? '';
        final bool valid = _validateForm();
        _formIsValid.value = valid;
        widget.validNotifier.isTextButtonValid(valid);
      },
      selectedValue: typeSelectedValue,
    );
  }

  ValueListenableBuilder<int> _buildCategoryDropDown({bool isEdit = false}) {
    if (isEdit &&
        _categoryController.text == '' &&
        widget.notifier.transactionTextFieldDetails != null) {
      _categoryController.text =
          widget.notifier.transactionTextFieldDetails!.category;
    }
    return ValueListenableBuilder(
      valueListenable: _categoryCount,
      builder: (BuildContext context, int value, Widget? child) {
        return CustomDropdown(
          expandedInsets: EdgeInsets.zero,
          items: widget.userDetails.userProfile.categoryStrings,
          controller: _categoryController,
          focusNode: _categoryFocusNode,
          hintText: 'Category',
          onSelected: (String? value) {
            widget.notifier.transactionTextFieldDetails?.category = value ?? '';
            final bool valid = _validateForm();
            _formIsValid.value = valid;
            widget.validNotifier.isTextButtonValid(valid);
          },
          selectedValue: categorySelectedValue,
        );
      },
    );
  }

  ValueListenableBuilder<int> _buildSubCategoryDropDown({bool isEdit = false}) {
    if (isEdit &&
        _subCategoryController.text == '' &&
        widget.notifier.transactionTextFieldDetails != null) {
      _subCategoryController.text =
          widget.notifier.transactionTextFieldDetails!.subCategory;
    }
    return ValueListenableBuilder(
      valueListenable: _subCategoryCount,
      builder: (BuildContext context, int value, Widget? child) {
        return CustomDropdown(
          expandedInsets: isMobile(context) ? EdgeInsets.zero : null,
          items: widget.userDetails.userProfile.getSubcategoriesFor(
            _categoryController.text,
          ),
          controller: _subCategoryController,
          focusNode: _subCategoryFocusNode,
          hintText: 'Subcategory',
          onSelected: (String? value) {
            widget.notifier.transactionTextFieldDetails?.subCategory =
                value ?? '';
            final bool valid = _validateForm();
            _formIsValid.value = valid;
            widget.validNotifier.isTextButtonValid(valid);
          },
          selectedValue: subCategorySelectedValue,
        );
      },
    );
  }

  CustomTextField _buildAmountTextField({bool isEdit = false}) {
    if (isEdit &&
        _amountController.text == '' &&
        widget.notifier.transactionTextFieldDetails != null) {
      _amountController.text = widget
          .notifier
          .transactionTextFieldDetails!
          .amount
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
          widget.notifier.transactionTextFieldDetails?.amount = parseCurrency(
            value,
            widget.userDetails.userProfile,
          );
          final bool valid = _validateForm();
          _formIsValid.value = valid;
          widget.validNotifier.isTextButtonValid(valid);
        }
      },
    );
  }

  Widget _buildDateTextField({bool isEdit = false}) {
    if (isEdit &&
        _dateController.text == '' &&
        widget.notifier.transactionTextFieldDetails != null) {
      _dateController.text = formatDate(
        widget.notifier.transactionTextFieldDetails!.date,
      );
    }
    return buildDateTextField(
      hintText: 'Date',
      dateController: _dateController,
      userDetails: widget.userDetails,
      context: context,
      onChanged: (String value) {
        widget.notifier.transactionTextFieldDetails?.date = DateFormat(
          widget.userDetails.userProfile.dateFormat,
        ).parse(value);
        final bool valid = _validateForm();
        _formIsValid.value = valid;
        widget.validNotifier.isTextButtonValid(valid);
      },
    );
  }

  CustomTextField _buildNotesTextField({bool isEdit = false}) {
    if (isEdit &&
        _remarkController.text == '' &&
        widget.notifier.transactionTextFieldDetails != null) {
      _remarkController.text =
          widget.notifier.transactionTextFieldDetails!.remarks;
    }
    return CustomTextField(
      maxLines: isMobile(context) ? 5 : 4,
      isRequired: false,
      controller: _remarkController,
      hintText: 'Notes',
      focusNode: _remarkFocusNode,
      keyboardType: TextInputType.streetAddress,
      onChanged: (String value) {
        widget.notifier.transactionTextFieldDetails!.remarks = value;
        if (isEdit) {
          final bool valid = _validateForm();
          _formIsValid.value = valid;
          widget.validNotifier.isTextButtonValid(valid);
        }
      },
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

  Widget _buildDialogActionButtons() {
    return ValueListenableBuilder<bool>(
      valueListenable: _formIsValid,
      builder: (context, isValid, child) {
        return CustomTextActionButtons(
          onCancelAction: () {
            widget.validNotifier.isTextButtonValid(false);
            Navigator.pop(context);
          },
          onAddOrEditAction: isValid
              ? () async {
                  if (_amountController.text.isEmpty ||
                      _typeController.text.isEmpty ||
                      _categoryController.text.isEmpty ||
                      _dateController.text.isEmpty) {
                    return;
                  }

                  final Transaction transaction = Transaction(
                    type: _typeController.text,
                    category: _categoryController.text,
                    subCategory: _subCategoryController.text,
                    amount: double.tryParse(_amountController.text) ?? 0.0,
                    remark: _remarkController.text,
                    transactionDate: DateFormat(
                      widget.userDetails.userProfile.dateFormat,
                    ).parse(_dateController.text),
                  );
                  final List<Transaction> transactions =
                      widget.notifier.transactions;
                  if (widget.userInteraction == UserInteractions.edit) {
                    widget.notifier.editTransaction(
                      widget.selectedIndex,
                      transaction,
                    );
                    widget.selectedCountNotifier.countChecking(0);
                    // updateTransactions(
                    //   widget.userDetails,
                    //   transaction,
                    //   widget.userInteraction,
                    //   widget.notifier.selectedIndexes,
                    // );
                  } else {
                    transactions.add(transaction);
                    widget.notifier.updateTransactions(transactions);
                    // updateTransactions(
                    //   widget.userDetails,
                    //   transaction,
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
    );
  }

  bool _validateForm() {
    if (widget.userInteraction == UserInteractions.edit) {
      final Transaction currentTransaction =
          widget.notifier.filteredTransactions[widget.selectedIndex];
      return _categoryController.text != currentTransaction.category ||
          _subCategoryController.text != currentTransaction.subCategory ||
          _typeController.text != currentTransaction.type ||
          _amountController.text != currentTransaction.amount.toString() ||
          _dateController.text !=
              formatDate(currentTransaction.transactionDate) ||
          _remarkController.text != currentTransaction.remark;
    }
    return _amountController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _subCategoryController.text.isNotEmpty &&
        _dateController.text.isNotEmpty;
  }

  @override
  void initState() {
    _categoryCount = ValueNotifier<int>(0);
    _subCategoryCount = ValueNotifier<int>(0);

    _typeFocusNode = FocusNode();
    _categoryFocusNode = FocusNode();
    _subCategoryFocusNode = FocusNode();
    _remarkFocusNode = FocusNode();
    _amountFocusNode = FocusNode();
    _typeController = TextEditingController();
    _categoryController = TextEditingController();
    _subCategoryController = TextEditingController();
    _dateController = TextEditingController();
    _remarkController = TextEditingController();
    _amountController = TextEditingController();
    _type = <String>['Income', 'Expense'];
    _categoryController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _subCategoryCount.value = _subCategoryCount.value + 1;
      });
    });
    _formIsValid = ValueNotifier<bool>(false);
    _typeController.addListener(_validateForm);
    _categoryController.addListener(_validateForm);
    _dateController.addListener(_validateForm);
    _amountController.addListener(_validateForm);
    _initializeTextFieldValues();
    super.initState();
  }

  @override
  void dispose() {
    _categoryCount.dispose();
    _subCategoryCount.dispose();
    _typeFocusNode.dispose();
    _categoryFocusNode.dispose();
    _subCategoryFocusNode.dispose();
    _remarkFocusNode.dispose();
    _amountFocusNode.dispose();
    _typeController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
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
