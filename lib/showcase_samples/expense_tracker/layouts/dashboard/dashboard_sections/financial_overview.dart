// ignore_for_file: prefer_foreach

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants.dart';
import '../../../custom_widgets/chip_and_drop_down_button.dart';
import '../../../custom_widgets/date_picker_drop_down_menu.dart';
import '../../../helper/common_helper.dart';
import '../../../helper/currency_and_data_format/currency_format.dart';
import '../../../helper/dashboard.dart';
import '../../../helper/responsive_layout.dart';
import '../../../models/user.dart';
import '../../../notifiers/dashboard_notifier.dart';
import '../../../pages/dashboard.dart';

class FinancialOverview extends StatelessWidget {
  const FinancialOverview({
    required this.userDetails,
    required this.incomeDetails,
    required this.expenseDetails,
    required this.controller,
    this.width,
    super.key,
  });

  final double? width;
  final UserDetails userDetails;
  final List<IncomeDetails> incomeDetails;
  final List<ExpenseDetails> expenseDetails;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final List<String> options = <String>['Income', 'Expense'];
    return Consumer<DashboardNotifier>(
      builder:
          (
            BuildContext context,
            DashboardNotifier financialNotifier,
            Widget? child,
          ) {
            return ExpenseCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Flexible(
                        child: buildHeaderText(context, 'Financial Overview'),
                      ),
                    ],
                  ),
                  if (isMobile(context)) ...[
                    verticalSpacer12,
                  ] else ...[
                    verticalSpacer16,
                  ],
                  Row(
                    spacing: 8.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SegmentedFilterButtons(
                          options: options,
                          icons: const [
                            IconData(0xe735, fontFamily: fontIconFamily),
                            IconData(0xe736, fontFamily: fontIconFamily),
                          ],
                          onSelectionChanged: (Set<String> selections) {
                            financialNotifier.updateFinancialView(
                              selections.first,
                            );
                          },
                          selectedSegment:
                              financialNotifier.financialOverviewType,
                        ),
                      ),
                      Flexible(
                        child: ChartsDropdownFilter(
                          width: 200.0,
                          intervalFilters: chartTimeFrames,
                          onTap: (String? value) {
                            if (value != null) {
                              financialNotifier.updateTimeFrame(value);
                            }
                          },
                          selectedDuration: financialNotifier.timeFrame,
                        ),
                      ),
                    ],
                  ),
                  if (isMobile(context)) verticalSpacer32 else verticalSpacer54,
                  Flexible(
                    child: FinancialOverviewChart(
                      key: ValueKey(financialNotifier.financialOverviewType),
                      expenseDetails: expenseDetails,
                      incomeDetails: incomeDetails,
                      userDetails: userDetails,
                      controller: controller,
                      financialViewType:
                          financialNotifier.financialOverviewType,
                      filteredTimeFrame: financialNotifier.timeFrame,
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}

class FinancialOverviewChart extends StatelessWidget {
  const FinancialOverviewChart({
    required this.expenseDetails,
    required this.incomeDetails,
    required this.userDetails,
    required this.controller,
    required this.financialViewType,
    required this.filteredTimeFrame,
    super.key,
  });

  final List<ExpenseDetails> expenseDetails;
  final List<IncomeDetails> incomeDetails;
  final UserDetails userDetails;
  final TextEditingController controller;
  final String financialViewType;
  final String filteredTimeFrame;

  double _amountPercentage(
    List<FinancialDetails> currentDetails,
    double currentAmount,
  ) {
    double totalAmount = 0;
    for (final FinancialDetails detail in currentDetails) {
      totalAmount += detail.amount;
    }
    return (currentAmount / totalAmount) * 100;
  }

  DoughnutSeries<FinancialDetails, String> _buildDoughnutSeries(
    BuildContext context,
    List<FinancialDetails> currentDetails,
    String financialViewType,
    bool isExpense,
  ) {
    return DoughnutSeries<FinancialDetails, String>(
      xValueMapper: (FinancialDetails details, int index) => details.category,
      yValueMapper: (FinancialDetails details, int index) => details.amount,
      dataLabelSettings: const DataLabelSettings(
        isVisible: true,
        labelIntersectAction: LabelIntersectAction.hide,
      ),
      radius: isMobile(context) ? '80%' : '100%',
      name: 'Expense',
      dataSource: currentDetails,
      animationDuration: 500,
    );
  }

  void _dataGrouping(
    List<ExpenseDetails> expenseDetailsReference,
    List<IncomeDetails> incomeDetailsReference,
  ) {
    final List<ExpenseDetails> expenseData = _filterByTimeFrame(
      expenseDetailsReference,
      filteredTimeFrame,
    );
    final List<IncomeDetails> incomeData = _filterByTimeFrame(
      incomeDetailsReference,
      filteredTimeFrame,
    );

    Map<String, double> expenseMap = {};
    Map<String, double> incomeMap = {};

    for (final ExpenseDetails detail in expenseData) {
      expenseMap.update(
        detail.category,
        (value) => value + detail.amount,
        ifAbsent: () => detail.amount,
      );
    }
    for (final IncomeDetails detail in incomeData) {
      incomeMap.update(
        detail.category,
        (value) => value + detail.amount,
        ifAbsent: () => detail.amount,
      );
    }

    if (expenseMap.isNotEmpty) {
      expenseMap = _othersValueMapping(expenseMap);
    }
    if (incomeMap.isNotEmpty) {
      incomeMap = _othersValueMapping(incomeMap);
    }

    incomeDetailsReference.clear();
    expenseDetailsReference.clear();

    final List<ExpenseDetails> expenseDetails = expenseMap.entries.map((entry) {
      return ExpenseDetails(
        category: entry.key,
        amount: entry.value,
        date: DateTime.now(),
        budgetAmount: 0,
      );
    }).toList();

    final List<IncomeDetails> incomeDetails = incomeMap.entries.map((entry) {
      return IncomeDetails(
        category: entry.key,
        amount: entry.value,
        date: DateTime.now(),
      );
    }).toList();

    expenseDetailsReference.addAll(expenseDetails);
    incomeDetailsReference.addAll(incomeDetails);
  }

  // Helper function to filter data by time frame
  List<T> _filterByTimeFrame<T extends dynamic>(
    List<T> items,
    final String frame,
  ) {
    final now = DateTime.now();
    return items.where((item) {
      final date = item is ExpenseDetails
          ? item.date
          : (item as IncomeDetails).date;
      switch (frame) {
        case 'This Year':
          return date.year == now.year;
        case 'Last Year':
          return date.year == now.year - 1;
        case 'This Month':
          return date.year == now.year && date.month == now.month;
        case 'Last 6 Month':
          final threshold = now.year * 12 + now.month - 5;
          return (date.year * 12 + date.month) >= threshold;
        default:
          return false;
      }
    }).toList();
  }

  Map<String, double> _othersValueMapping(Map<String, double> map) {
    final Map<String, double> updatedData = {};
    double othersTotalAmount = 0;
    final double totalAmount = map.values.reduce((sum, value) => sum + value);

    map.forEach((String key, double value) {
      if ((value / totalAmount) * 100 < 8) {
        othersTotalAmount += value;
      } else {
        updatedData[key] = value;
      }
    });

    if (othersTotalAmount > 0) {
      updatedData['Others'] = othersTotalAmount;
    }
    return updatedData;
  }

  Widget _buildDoughnutChart(
    BuildContext context,
    List<FinancialDetails> currentDetails,
    String financialViewType,
    bool isExpense,
  ) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 26.0),
      child: SfCircularChart(
        palette: doughnutPalette(Theme.of(context)),
        onDataLabelRender: (DataLabelRenderArgs dataLabelArgs) {
          final TextTheme textTheme = Theme.of(context).textTheme;
          final double currentAmount = parseCurrency(
            dataLabelArgs.text!,
            userDetails.userProfile,
          );
          dataLabelArgs.text =
              '${_amountPercentage(currentDetails, currentAmount).toStringAsFixed(2)}%';
          dataLabelArgs.textStyle = isMobile(context)
              ? textTheme.labelMedium!.copyWith(color: dataLabelArgs.color)
              : textTheme.labelLarge!.copyWith(color: dataLabelArgs.color);
        },
        annotations: [
          if (currentDetails.isNotEmpty)
            CircularChartAnnotation(
              widget: Text(
                financialViewType,
                style: isMobile(context)
                    ? theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      )
                    : theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
              ),
            ),
        ],
        legend: Legend(
          isVisible: true,
          padding: 0,
          itemPadding: 0,
          isResponsive: true,
          position: isMobile(context)
              ? LegendPosition.bottom
              : LegendPosition.auto,
          orientation: isMobile(context)
              ? LegendItemOrientation.vertical
              : LegendItemOrientation.auto,
          legendItemBuilder:
              (
                String legendText,
                ChartSeries<dynamic, dynamic>? series,
                ChartPoint<dynamic> point,
                int seriesIndex,
              ) {
                return _buildLegendTemplate(
                  context,
                  legendText,
                  toCurrency(point.y!.toDouble(), userDetails.userProfile),
                  seriesIndex,
                );
              },
        ),
        margin: EdgeInsets.zero,
        series: <CircularSeries<FinancialDetails, String>>[
          _buildDoughnutSeries(
            context,
            currentDetails,
            financialViewType,
            isExpense,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendTemplate(
    BuildContext context,
    String legendText,
    String amount,
    int pointIndex,
  ) {
    return isMobile(context)
        ? _buildMobileLegendTemplate(context, legendText, amount, pointIndex)
        : _buildWindowsLegendTemplate(context, legendText, amount, pointIndex);
  }

  Widget _buildWindowsLegendTemplate(
    BuildContext context,
    String legendText,
    String amount,
    int pointIndex,
  ) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: isMobile(context) || isTablet(context) ? 220 : 200,
      child: _buildLegendListTile(
        context,
        theme,
        pointIndex,
        legendText,
        amount,
      ),
    );
  }

  Widget _buildMobileLegendTemplate(
    BuildContext context,
    String legendText,
    String amount,
    int pointIndex,
  ) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: ListTile(
        minTileHeight: 0,
        mouseCursor: SystemMouseCursors.click,
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Row(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: doughnutPalette(theme)[pointIndex],
              radius: 6.0,
            ),
            Flexible(
              child: Text(
                legendText,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: Text(
          amount,
          textAlign: TextAlign.end,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendListTile(
    BuildContext context,
    ThemeData theme,
    int pointIndex,
    String legendText,
    String amount,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMobile(context) || isTablet(context) ? 0.0 : 16.0,
        bottom: 16.0,
      ),
      child: ListTile(
        minTileHeight: 0,
        mouseCursor: SystemMouseCursors.click,
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Row(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: doughnutPalette(theme)[pointIndex],
              radius: 6.0,
            ),
            Flexible(
              child: Text(
                legendText,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: Text(
          amount,
          textAlign: TextAlign.end,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpense = financialViewType == 'Expense';
    final List<IncomeDetails> incomeDetailsReference = List.from(incomeDetails);
    final List<ExpenseDetails> expenseDetailsReference = List.from(
      expenseDetails,
    );

    final List<ExpenseDetails> filteredExpenseDetails = _filterByTimeFrame(
      expenseDetailsReference,
      filteredTimeFrame,
    );

    final List<IncomeDetails> filteredIncomeDetails = _filterByTimeFrame(
      incomeDetailsReference,
      filteredTimeFrame,
    );

    // Check if there's data after filtering
    if ((isExpense && filteredExpenseDetails.isEmpty) ||
        (!isExpense && filteredIncomeDetails.isEmpty)) {
      return Center(child: buildNoRecordsFound(context));
    }

    _dataGrouping(expenseDetailsReference, incomeDetailsReference);
    final List<FinancialDetails> currentIncomeDetails = <FinancialDetails>[];
    final List<FinancialDetails> currentExpenseDetails = <FinancialDetails>[];

    for (final ExpenseDetails detail in expenseDetailsReference) {
      currentExpenseDetails.add(
        FinancialDetails(
          category: detail.category,
          date: detail.date,
          amount: detail.amount,
          type: 'Expense',
        ),
      );
    }

    for (final IncomeDetails detail in incomeDetailsReference) {
      currentIncomeDetails.add(
        FinancialDetails(
          category: detail.category,
          date: detail.date,
          amount: detail.amount,
          type: 'Income',
        ),
      );
    }
    currentExpenseDetails.sort(
      (FinancialDetails a, FinancialDetails b) => a.date.compareTo(b.date),
    );
    currentIncomeDetails.sort(
      (FinancialDetails a, FinancialDetails b) => a.date.compareTo(b.date),
    );

    return _buildDoughnutChart(
      context,
      isExpense ? currentExpenseDetails : currentIncomeDetails,
      financialViewType,
      isExpense,
    );
  }
}

class FinancialDetails {
  FinancialDetails({
    required this.category,
    required this.date,
    required this.amount,
    required this.type,
  });

  final String category;
  final DateTime date;
  double amount;
  String type;
}
