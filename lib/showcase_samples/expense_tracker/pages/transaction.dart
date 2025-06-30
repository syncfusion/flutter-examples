import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../constants.dart';
import '../custom_widgets/chip_and_drop_down_button.dart';
import '../custom_widgets/custom_buttons.dart';
import '../custom_widgets/custom_data_grid.dart';
import '../custom_widgets/date_picker_drop_down_menu.dart';

import '../data_processing/transaction_handler.dart'
    if (dart.library.html) '../data_processing/transaction_web_handler.dart';
import '../enum.dart';
import '../helper/common_helper.dart';
import '../helper/currency_and_data_format/currency_format.dart';
import '../helper/currency_and_data_format/date_format.dart';
import '../helper/dashboard.dart';
import '../helper/delete_confirmation_dialog.dart';
import '../helper/responsive_layout.dart';
import '../helper/transaction_center_dialog.dart';
import '../helper/type_color.dart';

import '../models/transaction.dart';
import '../models/user.dart';
import '../notifiers/mobile_app_bar.dart';
import '../notifiers/text_field_valid_notifier.dart';
import '../notifiers/transaction_notifier.dart';
import 'base_home.dart';

// class SelectedCount extends ChangeNotifier {
//   int _selectedCount = 0;
//   int get selectedCount => _selectedCount;
//   void countChecking(int count) {
//     _selectedCount = count;
//     notifyListeners();
//   }
// }

// ignore: must_be_immutable
class TransactionPage extends StatefulWidget {
  const TransactionPage(this.currentUserDetails, {super.key});

  final UserDetails currentUserDetails;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final List<String> _categories = <String>[];
  final List<String> _subCategories = <String>[];
  late TransactionSelectedCountNotifier _selectedCountNotifier;

  final Set<DataGridRow> _selectedRows = <DataGridRow>{};

  final DataGridController _dataGridController = DataGridController();

  void _setInitialTransactionDateRange() {
    final TransactionNotifier transactionsNotifier =
        Provider.of<TransactionNotifier>(context, listen: false);
    if (transactionsNotifier.filteredTransactions.isEmpty) {
      return;
    }
    DateTime minDate =
        transactionsNotifier.filteredTransactions.first.transactionDate;
    DateTime maxDate = minDate;

    for (final Transaction transaction
        in transactionsNotifier.filteredTransactions) {
      final DateTime transactionDate = transaction.transactionDate;
      if (transactionDate.isBefore(minDate)) {
        minDate = transactionDate;
      }
      if (transactionDate.isAfter(maxDate)) {
        maxDate = transactionDate;
      }
    }
  }

  void _calculateTotals() {}

  Widget _buildTransactionPage(TransactionNotifier transactionNotifier) {
    return ExpenseCard(
      child: Column(
        spacing: 20.0,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Consumer<TransactionSelectedCountNotifier>(
            builder:
                (
                  BuildContext context,
                  TransactionSelectedCountNotifier value,
                  Widget? child,
                ) {
                  _selectedCountNotifier = value;
                  if (value.selectedCount > 0) {
                    return _buildEditAndDeleteTag(transactionNotifier);
                  } else {
                    return _buildFilterSegmentAndExportButton();
                  }
                },
          ),
          if (isMobile(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 8.0,
              children: <Widget>[_buildFilter(), _buildExportButton()],
            ),
          Expanded(child: _buildTransactionDataGrid(context)),
        ],
      ),
    );
  }

  Widget _buildEditAndDeleteTag(TransactionNotifier transactionNotifier) {
    final bool isWebFullView =
        kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    return Consumer<TransactionSelectedCountNotifier>(
      builder:
          (
            BuildContext context,
            TransactionSelectedCountNotifier value,
            Widget? child,
          ) {
            return SizedBox(
              height: isWebFullView ? 40 : 46,
              child: SelectedCountsTag(
                selectedCount: value.selectedCount,
                closeButtonPressed: () {
                  _dataGridController.selectedRows = <DataGridRow>[];
                  _selectedCountNotifier.countChecking(0);
                  _selectedCountNotifier.countChecking(
                    _dataGridController.selectedRows.length,
                  );
                },
                editButtonPressed: () {
                  final int startIndex =
                      _dataSource.rowsPerPage * _dataSource.currentPageIndex;
                  final List<int> selectedIndexes = _dataGridController
                      .selectedRows
                      .map((row) => startIndex + _dataSource.rows.indexOf(row))
                      .toList();
                  _userInteraction = UserInteractions.edit;
                  if (isMobile(context)) {
                    showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return Consumer<TextButtonValidNotifier>(
                          builder:
                              (
                                BuildContext context,
                                TextButtonValidNotifier value,
                                Widget? child,
                              ) {
                                return MobileCenterDialog(
                                  userInteraction: UserInteractions.edit,
                                  transactionNotifier: transactionNotifier,
                                  validateNotifier: value,
                                  currentMobileDialog:
                                      MobileDialogs.transactions,
                                  title: 'Edit transaction',
                                  buttonText: 'Save',
                                  index: selectedIndexes[0],
                                  userDetails: widget.currentUserDetails,
                                  onCancelPressed: () {
                                    Navigator.pop(context);
                                  },
                                  onPressed: () {
                                    final Transaction transaction = Transaction(
                                      type: transactionNotifier
                                          .transactionTextFieldDetails!
                                          .type,
                                      category: transactionNotifier
                                          .transactionTextFieldDetails!
                                          .category,
                                      subCategory: transactionNotifier
                                          .transactionTextFieldDetails!
                                          .subCategory,
                                      transactionDate: transactionNotifier
                                          .transactionTextFieldDetails!
                                          .date,
                                      amount: transactionNotifier
                                          .transactionTextFieldDetails!
                                          .amount,
                                      remark: transactionNotifier
                                          .transactionTextFieldDetails!
                                          .remarks,
                                    );
                                    transactionNotifier.editTransaction(
                                      selectedIndexes[0],
                                      transaction,
                                    );
                                    _selectedCountNotifier.countChecking(0);
                                    // updateTransactions(
                                    //   widget.currentUserDetails,
                                    //   transaction,
                                    //   _userInteraction,
                                    //   selectedIndexes,
                                    // );
                                    value.isTextButtonValid(false);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                        );
                      },
                    );
                  } else {
                    showDialog<Transaction>(
                      context: context,
                      builder: (BuildContext context) {
                        return Consumer<TextButtonValidNotifier>(
                          builder:
                              (
                                BuildContext context,
                                TextButtonValidNotifier validNotifier,
                                Widget? child,
                              ) {
                                return ResponsiveTransactionCenterDialog(
                                  notifier: transactionNotifier,
                                  validNotifier: validNotifier,
                                  selectedCountNotifier: value,
                                  addButtonOnPressedEvent: () {},
                                  userInteraction: _userInteraction,
                                  userDetails: widget.currentUserDetails,
                                  selectedIndex: selectedIndexes[0],
                                  categories: _categories,
                                  subCategories: _subCategories,
                                );
                              },
                        );
                      },
                    );
                  }
                },
                deleteButtonPressed: () {
                  if (isMobile(context)) {
                    showMobileDeleteConfirmation(
                      context,
                      'Delete Transaction?',
                      'Do you want delete this transaction?',
                      () {
                        final int startIndex =
                            _dataSource.rowsPerPage *
                            _dataSource.currentPageIndex;
                        final List<int> selectedIndexes = _dataGridController
                            .selectedRows
                            .map(
                              (row) =>
                                  startIndex + _dataSource.rows.indexOf(row),
                            )
                            .toList();
                        transactionNotifier.deleteTransactions(selectedIndexes);
                        _selectedCountNotifier.countChecking(0);
                        // updateTransactions(
                        //   widget.currentUserDetails,
                        //   transactionNotifier.transactions[0],
                        //   UserInteractions.delete,
                        //   transactionNotifier.selectedIndexes,
                        // );
                        Navigator.pop(context);
                        _dataGridController.selectedRows.clear();
                      },
                    );
                  } else {
                    showDeleteConfirmationDialog(
                      context: context,
                      title: 'Delete Transaction?',
                      content: 'Do you want delete this transaction?',
                      confirmAction: () {
                        final int startIndex =
                            _dataSource.rowsPerPage *
                            _dataSource.currentPageIndex;
                        final List<int> selectedIndexes = _dataGridController
                            .selectedRows
                            .map(
                              (row) =>
                                  startIndex + _dataSource.rows.indexOf(row),
                            )
                            .toList();
                        transactionNotifier.deleteTransactions(selectedIndexes);
                        _selectedCountNotifier.countChecking(0);
                        // updateTransactions(
                        //   widget.currentUserDetails,
                        //   transactionNotifier.transactions[0],
                        //   UserInteractions.delete,
                        //   transactionNotifier.selectedIndexes,
                        // );
                        _dataGridController.selectedRows.clear();
                      },
                    );
                  }
                },
              ),
            );
          },
    );
  }

  Widget _buildFilterSegmentAndExportButton() {
    return isMobile(context)
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _buildSegmentButton(),
          )
        : SizedBox(
            height: 40.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildSegmentButton(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.0,
                  children: <Widget>[_buildFilter(), _buildExportButton()],
                ),
              ],
            ),
          );
  }

  SizedBox _buildExportButton() {
    return SizedBox(
      height: 40.0,
      child: ExportButton(
        onTap: () async {
          handleOnTapExportLogic(context, 'Transactions', 'Transaction');
        },
      ),
    );
  }

  Widget _buildFilter() {
    return _buildTransactionFilter(context);
  }

  Widget _buildSegmentButton() {
    return _buildFilteringSegmentsOrDropDownButton(context);
  }

  Widget _buildFilteringSegmentsOrDropDownButton(BuildContext context) {
    final TransactionNotifier transactionNotifier = context
        .watch<TransactionNotifier>();
    return isTablet(context)
        ? ChartsDropdownFilter(
            width: isMobile(context) ? 150 : null,
            intervalFilters: const <String>['All', 'Income', 'Expense'],
            selectedDuration: transactionNotifier.selectedSegment,
            showLeadingIcon: false,
            horizontalPadding: 16.0,
            onTap: (String? value) {
              transactionNotifier.updateSelectedSegment(value!);
              transactionNotifier.updateTransactionCount();
              transactionNotifier.updateTransactions(_transactions);
            },
          )
        : SegmentedFilterButtons(
            options: const <String>['All', 'Income', 'Expense'],
            onSelectionChanged: (Set<String> selections) {
              transactionNotifier.updateSelectedSegment(selections.first);
              transactionNotifier.updateTransactionCount();
              transactionNotifier.updateTransactions(_transactions);
            },
            selectedSegment: transactionNotifier.selectedSegment,
          );
  }

  Widget _buildTransactionFilter(BuildContext context) {
    final TransactionNotifier transactionNotifier = context
        .watch<TransactionNotifier>();
    return ChartsDropdownFilter(
      width: 200.0,
      intervalFilters: dateDuration,
      onTap: (String? newValue) {
        if (newValue != null) {
          transactionNotifier.updateSelectedDuration(newValue);
          transactionNotifier.updateTransactions(_transactions);
        }
      },
      selectedDuration: transactionNotifier.selectedDuration,
    );
  }

  Widget _buildTransactionDataGrid(BuildContext context) {
    final TransactionNotifier transactionNotifier =
        Provider.of<TransactionNotifier>(context, listen: false);
    final List<Transaction> filteredTransactions =
        transactionNotifier.filteredTransactions;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double dataGridHeight = constraints.maxHeight;
        final int rowsPerPage = ((dataGridHeight - 45.0) / 64.0).floor();
        // Check if there are any transactions after filtering
        if (filteredTransactions.isEmpty) {
          return buildNoRecordsFound(context);
        }
        _dataSource = TransactionGridSource(
          context: context,
          transactions: filteredTransactions,
          userDetails: _userDetails,
          rowsPerPage: rowsPerPage >= 2 ? rowsPerPage - 1 : rowsPerPage,
        );
        _dataGridController.selectedRows.clear();
        _selectedRows.clear();
        return CustomDataGrid(
          dataSource: _dataSource,
          rowsPerPage: _dataSource.rowsPerPage,
          dataGridController: _dataGridController,
          columnHeaders: buildTransactionColumnNames(context),
          totalRecords: filteredTransactions.length,
          onSelectionChanged: (addedRows, removedRows) {
            _selectedRows.addAll(addedRows);
            _selectedRows.removeAll(removedRows);
            _selectedCountNotifier.countChecking(
              _dataGridController.selectedRows.length,
            );
          },
          onPageNavigationEnd: (newPageIndex) {
            _dataSource.handlePageChange(newPageIndex - 1, newPageIndex);
            _dataGridController.selectedRows.clear();
            _selectedRows.clear();
            _selectedCountNotifier.countChecking(0);
          },
        );
      },
    );
  }

  late UserDetails _userDetails;
  late List<Transaction> _transactions;
  late UserInteractions _userInteraction;
  late TransactionGridSource _dataSource;

  @override
  void initState() {
    _userDetails = widget.currentUserDetails;
    _categories.clear();
    _subCategories.clear();

    _userInteraction = UserInteractions.add;

    _setInitialTransactionDateRange();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final TransactionNotifier transactionNotifier = context
          .read<TransactionNotifier>();
      final List<Transaction> transactions = readTransactions(
        widget.currentUserDetails,
      );
      transactionNotifier.updateTransactions(transactions);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _calculateTotals();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dataGridController.dispose();
    _selectedRows.clear();
    _selectedRows.clear();
    _selectedCountNotifier.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionNotifier>(
      builder:
          (BuildContext context, TransactionNotifier value, Widget? child) {
            _transactions = value.transactions;
            return Padding(
              padding: EdgeInsets.all(isMobile(context) ? 16.0 : 24.0),
              child: _buildTransactionPage(value),
            );
          },
    );
  }
}

class TransactionGridSource extends CustomDataGridSource<Transaction> {
  TransactionGridSource({
    required super.context,
    required List<Transaction> transactions,
    required UserDetails userDetails,
    required this.rowsPerPage,
  }) : super(
         rowsPerPage: rowsPerPage,
         data: transactions,
         columns: const ['Date', 'Category', 'Type', 'Amount', 'Notes'],
         buildCell:
             (Transaction transaction, String column, BuildContext context) {
               final ThemeData theme = Theme.of(context);
               final TextStyle bodyLargeMediumStyle = theme.textTheme.bodyLarge!
                   .copyWith(
                     fontWeight: FontWeight.w400,
                     color: theme.colorScheme.onSurface,
                   );
               final TextStyle bodyMediumStyle = theme.textTheme.bodyMedium!
                   .copyWith(
                     fontWeight: FontWeight.w400,
                     color: theme.colorScheme.onSurface,
                   );

               switch (column) {
                 case 'Date':
                   return Container(
                     alignment: Alignment.centerLeft,
                     padding: const EdgeInsets.only(left: 30.0),
                     child: Text(
                       formatDate(
                         transaction.transactionDate,
                         user: userDetails,
                       ),
                       style: isMobile(context)
                           ? bodyMediumStyle
                           : bodyLargeMediumStyle,
                     ),
                   );

                 case 'Category':
                   return Container(
                     alignment: Alignment.centerLeft,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: Text(
                             transaction.category,
                             overflow: !isMobile(context)
                                 ? TextOverflow.ellipsis
                                 : null,
                             style: isMobile(context)
                                 ? theme.textTheme.bodyMedium!.copyWith(
                                     fontWeight: FontWeight.w500,
                                     color: theme.colorScheme.onSurface,
                                   )
                                 : theme.textTheme.bodyLarge!.copyWith(
                                     fontWeight: FontWeight.w500,
                                     color: theme.colorScheme.onSurface,
                                   ),
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(left: 12.0),
                           child: Text(
                             transaction.subCategory,
                             overflow: TextOverflow.ellipsis,
                             style: theme.textTheme.bodyMedium!.copyWith(
                               fontWeight: isMobile(context)
                                   ? FontWeight.w300
                                   : FontWeight.w400,
                               color: theme.colorScheme.onSurfaceVariant,
                             ),
                           ),
                         ),
                       ],
                     ),
                   );

                 case 'Type':
                   return Container(
                     alignment: Alignment.centerLeft,
                     padding: const EdgeInsets.only(left: 12.0),
                     child: TypeColor(type: transaction.type),
                   );

                 case 'Amount':
                   return Container(
                     alignment: Alignment.centerLeft,
                     padding: const EdgeInsets.only(left: 24),
                     child: Text(
                       toCurrency(transaction.amount, userDetails.userProfile),
                       style: isMobile(context)
                           ? bodyMediumStyle
                           : bodyLargeMediumStyle,
                     ),
                   );

                 case 'Notes':
                   return Container(
                     alignment: Alignment.centerLeft,
                     child: Text(
                       transaction.remark,
                       style: isMobile(context)
                           ? bodyMediumStyle
                           : bodyLargeMediumStyle,
                     ),
                   );

                 default:
                   return Container();
               }
             },
       );

  @override
  final int rowsPerPage;
}

class TransactionCenterDialog extends StatelessWidget {
  const TransactionCenterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
