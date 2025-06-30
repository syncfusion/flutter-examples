import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../constants.dart';
import '../custom_widgets/chip_and_drop_down_button.dart';
import '../custom_widgets/custom_buttons.dart';
import '../custom_widgets/custom_data_grid.dart';
import '../custom_widgets/date_picker_drop_down_menu.dart';
import '../data_processing/saving_handler.dart'
    if (dart.library.html) '../data_processing/saving_web_handler.dart';
import '../enum.dart';
import '../helper/common_helper.dart';
import '../helper/currency_and_data_format/currency_format.dart';
import '../helper/currency_and_data_format/date_format.dart';
import '../helper/dashboard.dart';
import '../helper/delete_confirmation_dialog.dart';
import '../helper/responsive_layout.dart';
import '../helper/savings_center_dialog.dart';
import '../helper/type_color.dart';
import '../layouts/dashboard/dashboard_layout.dart';
import '../models/saving.dart';
import '../models/user.dart';
import '../notifiers/mobile_app_bar.dart';
import '../notifiers/savings_notifier.dart';
import '../notifiers/text_field_valid_notifier.dart';
import '../notifiers/view_notifier.dart';
import 'base_home.dart';

enum SavingsPageLayoutSlot {
  totalSavings,
  thisMonthSavings,
  savingTransactions,
}

class SavingsPageWidget extends StatelessWidget {
  const SavingsPageWidget(this.userDetails, {super.key});
  final UserDetails userDetails;

  double monthSavings(BuildContext context) {
    final SavingsNotifier savingsNotifier = context.watch<SavingsNotifier>();
    final List<Saving> savings = savingsNotifier.savings;
    double monthSavings = 0;
    for (final Saving saving in savings) {
      if (saving.savingDate.month == DateTime.now().month) {
        monthSavings += saving.savedAmount;
      }
    }
    return monthSavings;
  }

  double totalSavings(BuildContext context) {
    final SavingsNotifier savingsNotifier = context.watch<SavingsNotifier>();
    final List<Saving> savings = savingsNotifier.savings;
    double totalSavings = 0;
    for (final Saving saving in savings) {
      totalSavings += saving.savedAmount;
    }
    return totalSavings;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isMobile(context) ? 16.0 : 24.0),
      child: SavingsPageLayout(
        userDetails,
        context,
        totalSavings(context),
        monthSavings(context),
      ),
    );
  }
}

class SavingsPageLayout
    extends
        SlottedMultiChildRenderObjectWidget<
          SavingsPageLayoutSlot,
          RenderObject
        > {
  const SavingsPageLayout(
    this.userDetails,
    this.context,
    this.totalSavings,
    this.monthSavings, {
    super.key,
  });
  final UserDetails userDetails;
  final BuildContext context;
  final double totalSavings;
  final double monthSavings;

  @override
  Widget? childForSlot(SavingsPageLayoutSlot slot) {
    switch (slot) {
      case SavingsPageLayoutSlot.totalSavings:
        return OverallDetails(
          insightTitle: 'Total Savings',
          insightValue: toCurrency(totalSavings, userDetails.userProfile),
          iconData: Icons.savings_outlined,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          iconColor: Theme.of(context).colorScheme.primary,
          isIconNeeded: false,
        );
      case SavingsPageLayoutSlot.thisMonthSavings:
        return Padding(
          padding: EdgeInsets.only(left: isMobile(context) ? 12.0 : 16.0),
          child: OverallDetails(
            insightTitle: 'This Month Saving',
            insightValue: toCurrency(monthSavings, userDetails.userProfile),
            iconData: Icons.attach_money_outlined,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            iconColor: Theme.of(context).colorScheme.primary,
            isIconNeeded: false,
          ),
        );
      case SavingsPageLayoutSlot.savingTransactions:
        return SavingsPage(userDetails);
    }
  }

  @override
  SlottedContainerRenderObjectMixin<SavingsPageLayoutSlot, RenderObject>
  createRenderObject(BuildContext context) {
    return RenderSavingsPageLayout(context);
  }

  @override
  SlottedContainerRenderObjectMixin<SavingsPageLayoutSlot, RenderObject>
  updateRenderObject(
    BuildContext context,
    SlottedContainerRenderObjectMixin<SavingsPageLayoutSlot, RenderObject>
    renderObject,
  ) {
    return RenderSavingsPageLayout(context);
  }

  @override
  Iterable<SavingsPageLayoutSlot> get slots => SavingsPageLayoutSlot.values;
}

class SavingsWidgetParentData extends ContainerBoxParentData<RenderBox> {}

class RenderSavingsPageLayout extends RenderBox
    with SlottedContainerRenderObjectMixin<SavingsPageLayoutSlot, RenderBox> {
  RenderSavingsPageLayout(this.buildContext);
  final BuildContext buildContext;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SavingsWidgetParentData) {
      child.parentData = SavingsWidgetParentData();
    }
    super.setupParentData(child);
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;

    // Iterate over children and check hit testing in reverse paint order
    visitChildren((RenderObject child) {
      final RenderBox renderBoxChild = child as RenderBox;
      final SavingsWidgetParentData parentData =
          child.parentData! as SavingsWidgetParentData;

      // Transform the position into the child's coordinate system
      final Offset childPosition = position - parentData.offset;

      // Perform hit testing for this child
      if (renderBoxChild.hitTest(result, position: childPosition)) {
        isHit = true;
      }
    });

    return isHit;
  }

  @override
  void performLayout() {
    final Size availableSize = constraints.biggest;
    final double commonInsightTileMinimumHeight = isMobile(buildContext)
        ? 64.0
        : 96.0;
    const double insightWidthFactor = 0.5;

    final RenderBox? totalSavingsRenderBox = childForSlot(
      SavingsPageLayoutSlot.totalSavings,
    );
    if (totalSavingsRenderBox != null &&
        totalSavingsRenderBox.parentData != null) {
      totalSavingsRenderBox.layout(
        BoxConstraints.tight(
          Size(
            availableSize.width * insightWidthFactor,
            commonInsightTileMinimumHeight,
          ),
        ),
        parentUsesSize: true,
      );
      final SavingsWidgetParentData totalSavingsParentData =
          totalSavingsRenderBox.parentData! as SavingsWidgetParentData;
      totalSavingsParentData.offset = Offset.zero;
    }

    final RenderBox? thisMonthSavingsRenderBox = childForSlot(
      SavingsPageLayoutSlot.thisMonthSavings,
    );
    if (thisMonthSavingsRenderBox != null &&
        thisMonthSavingsRenderBox.parentData != null) {
      thisMonthSavingsRenderBox.layout(
        BoxConstraints.tight(
          Size(
            availableSize.width * insightWidthFactor,
            commonInsightTileMinimumHeight,
          ),
        ),
        parentUsesSize: true,
      );
      final SavingsWidgetParentData thisMonthSavingsParentData =
          thisMonthSavingsRenderBox.parentData! as SavingsWidgetParentData;
      if (totalSavingsRenderBox != null) {
        thisMonthSavingsParentData.offset = Offset(
          totalSavingsRenderBox.size.width,
          0,
        );
      }
    }

    final RenderBox? savingTransactionsRenderBox = childForSlot(
      SavingsPageLayoutSlot.savingTransactions,
    );
    if (savingTransactionsRenderBox != null &&
        savingTransactionsRenderBox.parentData != null) {
      savingTransactionsRenderBox.layout(
        BoxConstraints.tight(
          Size(
            availableSize.width,
            availableSize.height - commonInsightTileMinimumHeight,
          ),
        ),
        parentUsesSize: true,
      );
      final SavingsWidgetParentData savingsTransactionsParentData =
          savingTransactionsRenderBox.parentData! as SavingsWidgetParentData;
      if (totalSavingsRenderBox != null) {
        savingsTransactionsParentData.offset = Offset(
          0,
          totalSavingsRenderBox.size.height,
        );
      }
    }

    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? totalSavingsRenderBox = childForSlot(
      SavingsPageLayoutSlot.totalSavings,
    );
    if (totalSavingsRenderBox != null &&
        totalSavingsRenderBox.parentData != null) {
      final SavingsWidgetParentData totalSavingsParentData =
          totalSavingsRenderBox.parentData! as SavingsWidgetParentData;
      context.paintChild(
        totalSavingsRenderBox,
        offset + totalSavingsParentData.offset,
      );
    }

    final RenderBox? thisMonthSavingsRenderBox = childForSlot(
      SavingsPageLayoutSlot.thisMonthSavings,
    );
    if (thisMonthSavingsRenderBox != null &&
        thisMonthSavingsRenderBox.parentData != null) {
      final SavingsWidgetParentData thisMonthSavingsParentData =
          thisMonthSavingsRenderBox.parentData! as SavingsWidgetParentData;
      context.paintChild(
        thisMonthSavingsRenderBox,
        offset + thisMonthSavingsParentData.offset,
      );
    }

    final RenderBox? savingsTransactionRenderBox = childForSlot(
      SavingsPageLayoutSlot.savingTransactions,
    );
    if (savingsTransactionRenderBox != null &&
        savingsTransactionRenderBox.parentData != null) {
      final SavingsWidgetParentData savingsWidgetParentData =
          savingsTransactionRenderBox.parentData! as SavingsWidgetParentData;
      context.paintChild(
        savingsTransactionRenderBox,
        offset + savingsWidgetParentData.offset,
      );
    }
  }
}

class SavingsPage extends StatefulWidget {
  const SavingsPage(this.currentUserDetails, {super.key});

  final UserDetails currentUserDetails;

  @override
  State<StatefulWidget> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  late String _selectedSegment;
  late List<Saving> _savings;
  late SavingsGridSource _dataSource;
  late UserInteractions _userInteraction;
  late SavingsSelectedCountNotifier _selectedCountNotifier;

  final DataGridController _dataGridController = DataGridController();

  final Set<DataGridRow> _selectedRows = <DataGridRow>{};

  final List<String> segmentedButtons = <String>['All', 'Withdraw', 'Deposit'];

  @override
  void initState() {
    _userInteraction = UserInteractions.add;
    _selectedSegment = segmentedButtons.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final SavingsNotifier savingsNotifier = context.read<SavingsNotifier>();
      final List<Saving> savings = readSavings(widget.currentUserDetails);
      savingsNotifier.updateSavings(savings);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _buildSegmentedFilterButtons(
    void Function(Set<String>)? onSelectionChanged,
    String selectedSegment,
  ) {
    final SavingsNotifier savingsNotifier = context.watch<SavingsNotifier>();
    return isTablet(context)
        ? ChartsDropdownFilter(
            intervalFilters: segmentedButtons,
            selectedDuration: savingsNotifier.selectedSegment,
            showLeadingIcon: false,
            horizontalPadding: 16.0,
            onTap: (String? value) {
              _onSelectedEvent(savingsNotifier, value);
            },
          )
        : SegmentedFilterButtons(
            options: segmentedButtons,
            onSelectionChanged: (Set<String> selections) {
              _onSelectedEvent(savingsNotifier, selections.first);
            },
            selectedSegment: savingsNotifier.selectedSegment,
          );
  }

  void _onSelectedEvent(SavingsNotifier savingsNotifier, String? value) {
    savingsNotifier.updateSelectedSegment(value!);
    savingsNotifier.updateCardCount();
    savingsNotifier.updateSavings(_savings);
  }

  Widget _buildAddAndSegmentedButtons(
    BuildContext context,
    void Function(Set<String>)? onSelectionChanged,
    void Function() onTap,
  ) {
    if (isMobile(context)) {
      return _buildMobileSegmentButton(context, onSelectionChanged);
    } else {
      return _buildDesktopSegmentButton(context, onSelectionChanged);
    }
  }

  Widget _buildDesktopSegmentButton(
    BuildContext context,
    void Function(Set<String>)? onSelectionChanged,
  ) {
    return SizedBox(
      height: 40.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildSegmentButton(onSelectionChanged),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: <Widget>[_buildFilter(), _buildExportButton(context)],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileSegmentButton(
    BuildContext context,
    void Function(Set<String>)? onSelectionChanged,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: _buildSegmentButton(onSelectionChanged),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: ExportButton(
        onTap: () async {
          handleOnTapExportLogic(context, 'Savings', 'Saving');
        },
      ),
    );
  }

  Widget _buildFilter() {
    return _buildSavingsFilter(context);
  }

  Widget _buildSegmentButton(void Function(Set<String>)? onSelectionChanged) {
    return _buildSegmentedFilterButtons(onSelectionChanged, _selectedSegment);
  }

  Widget _buildEditAndDeleteTag(SavingsNotifier savingsNotifier) {
    return Consumer<SavingsSelectedCountNotifier>(
      builder:
          (
            BuildContext context,
            SavingsSelectedCountNotifier selectedCountNotifier,
            Widget? child,
          ) {
            final bool isWebFullView =
                kIsWeb ||
                Platform.isWindows ||
                Platform.isMacOS ||
                Platform.isLinux;
            return SizedBox(
              height: isWebFullView ? 40 : 46,
              child: SelectedCountsTag(
                selectedCount: selectedCountNotifier.selectedCount,
                closeButtonPressed: () {
                  _dataGridController.selectedRows = <DataGridRow>[];
                  selectedCountNotifier.countChecking(0);
                  selectedCountNotifier.countChecking(
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
                    showDialog<Saving>(
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
                                  validateNotifier: value,
                                  userInteraction: UserInteractions.edit,
                                  savingsNotifier: savingsNotifier,
                                  currentMobileDialog: MobileDialogs.savings,
                                  title: 'Edit savings',
                                  buttonText: 'Save',
                                  index: selectedIndexes[0],
                                  userDetails: widget.currentUserDetails,
                                  onCancelPressed: () {
                                    Navigator.pop(context);
                                  },
                                  onPressed: () {
                                    if (savingsNotifier
                                            .savingsTextFieldDetails !=
                                        null) {
                                      final Saving saving = Saving(
                                        name: savingsNotifier
                                            .savingsTextFieldDetails!
                                            .name,
                                        savedAmount: savingsNotifier
                                            .savingsTextFieldDetails!
                                            .amount,
                                        type: savingsNotifier
                                            .savingsTextFieldDetails!
                                            .type,
                                        remark: savingsNotifier
                                            .savingsTextFieldDetails!
                                            .remarks,
                                        savingDate: savingsNotifier
                                            .savingsTextFieldDetails!
                                            .date,
                                      );
                                      savingsNotifier.editSavings(
                                        selectedIndexes[0],
                                        saving,
                                      );
                                      selectedCountNotifier.countChecking(0);

                                      // updateSavings(
                                      //   widget.currentUserDetails,
                                      //   saving,
                                      //   _userInteraction,
                                      //   savingsNotifier.selectedIndexes,
                                      // );
                                      value.isTextButtonValid(false);
                                      Navigator.pop(context);
                                    }
                                  },
                                );
                              },
                        );
                      },
                    );
                  } else {
                    showDialog<Saving>(
                      context: context,
                      builder: (BuildContext context) {
                        return Consumer<TextButtonValidNotifier>(
                          builder:
                              (
                                BuildContext context,
                                TextButtonValidNotifier validNotifier,
                                Widget? child,
                              ) {
                                return SavingsCenterDialog(
                                  notifier: savingsNotifier,
                                  validNotifier: validNotifier,
                                  selectedCountNotifier: selectedCountNotifier,
                                  addButtonOnPressedEvent: () {},
                                  userInteraction: _userInteraction,
                                  userDetails: widget.currentUserDetails,
                                  selectedIndex: selectedIndexes[0],
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
                      'Delete Saving?',
                      'Do you want delete this saving?',
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
                        savingsNotifier.deleteSavings(selectedIndexes);
                        selectedCountNotifier.countChecking(0);
                        // updateSavings(
                        //   widget.currentUserDetails,
                        //   _savings[0],
                        //   UserInteractions.delete,
                        //   savingsNotifier.selectedIndexes,
                        // );
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    showDeleteConfirmationDialog(
                      context: context,
                      title: 'Delete Saving?',
                      content: 'Do you want delete this saving?',
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
                        savingsNotifier.deleteSavings(selectedIndexes);
                        selectedCountNotifier.countChecking(0);
                        // updateSavings(
                        //   widget.currentUserDetails,
                        //   _savings[0],
                        //   UserInteractions.delete,
                        //   savingsNotifier.selectedIndexes,
                        // );
                      },
                    );
                  }
                },
              ),
            );
          },
    );
  }

  Widget _buildSavingsPage(
    BuildContext context,
    SavingsNotifier savingsNotifier,
  ) {
    return Column(
      spacing: 20.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Consumer<SavingsSelectedCountNotifier>(
          builder:
              (
                BuildContext context,
                SavingsSelectedCountNotifier value,
                Widget? child,
              ) {
                _selectedCountNotifier = value;
                if (value.selectedCount > 0) {
                  return _buildEditAndDeleteTag(savingsNotifier);
                } else {
                  return _buildAddAndSegmentedButtons(
                    context,
                    (Set<String> newSelection) {
                      _selectedSegment = newSelection.first;
                    },
                    () {
                      _userInteraction = UserInteractions.add;
                      showDialog<Saving>(
                        context: context,
                        builder: (BuildContext context) {
                          return Consumer<TextButtonValidNotifier>(
                            builder:
                                (
                                  BuildContext context,
                                  TextButtonValidNotifier validNotifier,
                                  Widget? child,
                                ) {
                                  return SavingsCenterDialog(
                                    notifier: savingsNotifier,
                                    validNotifier: validNotifier,
                                    selectedCountNotifier: context
                                        .watch<SavingsSelectedCountNotifier>(),
                                    addButtonOnPressedEvent: () {},
                                    userInteraction: _userInteraction,
                                    userDetails: widget.currentUserDetails,
                                  );
                                },
                          );
                        },
                      );
                    },
                  );
                }
              },
        ),
        if (isMobile(context))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: <Widget>[_buildFilter(), _buildExportButton(context)],
          ),
        Expanded(
          child: Consumer<ViewNotifier>(
            builder: (BuildContext context, ViewNotifier view, Widget? child) {
              if (savingsNotifier.filteredSavings.isEmpty) {
                return Center(child: buildNoRecordsFound(context));
              } else {
                return _buildListCardsView(context);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsFilter(BuildContext context) {
    final SavingsNotifier savingsNotifier = context.watch<SavingsNotifier>();
    return ChartsDropdownFilter(
      width: 200,
      intervalFilters: dateDuration,
      onTap: (String? newValue) {
        if (newValue != null) {
          savingsNotifier.updateSelectedDuration(newValue);
          savingsNotifier.updateSavings(_savings);
        }
      },
      selectedDuration: savingsNotifier.selectedDuration,
    );
  }

  Widget _buildListCardsView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.785,
      child: _buildSavingDataGrid(context),
    );
  }

  Widget _buildSavingDataGrid(BuildContext context) {
    final SavingsNotifier savingsNotifier = Provider.of<SavingsNotifier>(
      context,
      listen: false,
    );
    final List<Saving> filteredSavings = savingsNotifier.filteredSavings;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double dataGridHeight = constraints.maxHeight;
        final int rowsPerPage = ((dataGridHeight - 45.0) / 64.0).floor();
        _dataSource = SavingsGridSource(
          context: context,
          savings: filteredSavings,
          userDetails: widget.currentUserDetails,
          rowsPerPage: rowsPerPage >= 2 ? rowsPerPage - 1 : rowsPerPage,
        );
        _selectedRows.clear();
        return CustomDataGrid(
          dataSource: _dataSource,
          rowsPerPage: _dataSource.rowsPerPage,
          dataGridController: _dataGridController,
          columnHeaders: buildSavingsColumnNames(context),
          totalRecords: filteredSavings.length,
          onSelectionChanged:
              (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
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
    return Consumer<SavingsNotifier>(
      builder: (BuildContext context, SavingsNotifier value, Widget? child) {
        _savings = value.savings;
        return Padding(
          padding: EdgeInsets.only(top: isMobile(context) ? 12.0 : 16.0),
          child: ExpenseCard(child: _buildSavingsPage(context, value)),
        );
      },
    );
  }
}

class SavingsGridSource extends CustomDataGridSource<Saving> {
  SavingsGridSource({
    required super.context,
    required List<Saving> savings,
    required this.userDetails,
    required this.rowsPerPage,
  }) : super(
         data: savings,
         rowsPerPage: rowsPerPage,
         columns: buildSavingsColumnNames(context),
         buildCell: (Saving saving, String column, BuildContext context) {
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
                   formatDate(saving.savingDate, user: userDetails),
                   style: isMobile(context)
                       ? bodyMediumStyle
                       : bodyLargeMediumStyle,
                 ),
               );
             case 'Name':
               return Container(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 12.0),
                   child: Text(
                     saving.name,
                     style: isMobile(context)
                         ? bodyMediumStyle
                         : bodyLargeMediumStyle,
                   ),
                 ),
               );
             case 'Type':
               return Container(
                 alignment: Alignment.centerLeft,
                 padding: const EdgeInsets.only(left: 12.0),
                 child: TypeColor(type: saving.type),
               );
             case 'Amount':
               return Container(
                 alignment: Alignment.centerLeft,
                 padding: const EdgeInsets.only(left: 24),
                 child: Text(
                   toCurrency(saving.savedAmount, userDetails.userProfile),
                   style: isMobile(context)
                       ? bodyMediumStyle
                       : bodyLargeMediumStyle,
                 ),
               );
             case 'Notes':
               return Container(
                 alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 12.0),
                   child: Text(
                     saving.remark,
                     style: isMobile(context)
                         ? bodyMediumStyle
                         : bodyLargeMediumStyle,
                   ),
                 ),
               );
             default:
               return Container();
           }
         },
       );

  final UserDetails userDetails;
  @override
  final int rowsPerPage;
}
