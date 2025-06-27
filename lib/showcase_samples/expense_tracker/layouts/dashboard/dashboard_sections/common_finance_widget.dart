import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants.dart';
import '../../../helper/common_helper.dart';
import '../../../helper/currency_and_data_format/currency_format.dart';
import '../../../helper/dashboard.dart';
import '../../../helper/responsive_layout.dart';
import '../../../helper/view_more.dart';
import '../../../models/saving.dart';
import '../../../models/user.dart';
import '../../../pages/base_home.dart';
import '../../../pages/dashboard.dart';

// Create a TimeFrameNotifier class that extends ChangeNotifier
class TimeFrameNotifier extends ChangeNotifier {
  TimeFrameNotifier(this._timeFrame);
  String _timeFrame;

  String get timeFrame => _timeFrame;

  set timeFrame(String value) {
    if (_timeFrame != value) {
      _timeFrame = value;
      notifyListeners();
    }
  }
}

class CommonFinanceWidget extends StatelessWidget {
  const CommonFinanceWidget({
    required this.userDetails,
    required this.controller,
    required this.title,
    required this.timeFrameNotifier,
    this.incomeDetails,
    this.expenseDetails,
    this.savings,
    this.accountBalance,
    this.showViewMore = false,
    this.width,
    super.key,
  });

  final double? width;
  final String title;
  final UserDetails userDetails;
  final List<IncomeDetails>? incomeDetails;
  final List<ExpenseDetails>? expenseDetails;
  final TextEditingController controller;
  final TimeFrameNotifier timeFrameNotifier; // Changed to TimeFrameNotifier
  final List<Saving>? savings;
  final double? accountBalance;
  final bool showViewMore;

  Widget _buildCurrentBalanceText(
    BuildContext context,
    String headerText, [
    int? maxLines,
  ]) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final Color headerTextColor = themeData.colorScheme.onSecondaryContainer;
    return Text(
      headerText,
      maxLines: maxLines ?? 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.titleMedium!.copyWith(
        color: headerTextColor,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bool isPopupOpen = false;
    return ExpenseCard(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Flexible(child: buildHeaderText(context, title)),
              horizontalSpacer10,
              if (showViewMore)
                buildViewMoreButton(context, () {
                  pageNavigatorNotifier.value = NavigationPagesSlot.savings;
                }),
            ],
          ),
          verticalSpacer16,
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (accountBalance != null)
                Flexible(
                  child: _buildCurrentBalanceText(
                    context,
                    'Balance : ${toCurrency(accountBalance!, userDetails.userProfile)}',
                    2,
                  ),
                ),
              Flexible(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: AnimatedBuilder(
                    animation: timeFrameNotifier,
                    builder: (BuildContext context, Widget? child) {
                      return _buildMonthlyFilterDropDown(
                        context,
                        controller,
                        timeFrameNotifier,
                        showViewMore,
                        isPopupOpen,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          verticalSpacer24,
          Flexible(
            child: AnimatedBuilder(
              animation: timeFrameNotifier,
              builder: (BuildContext context, _) {
                return AccountBalanceChart(
                  key: ValueKey(timeFrameNotifier.timeFrame),
                  expenseDetails: expenseDetails,
                  incomeDetails: incomeDetails,
                  userDetails: userDetails,
                  controller: controller,
                  timeFrameNotifier: timeFrameNotifier,
                  accountBalance: accountBalance,
                  savings: savings,
                  showViewMore: showViewMore,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountBalanceChart extends StatelessWidget {
  const AccountBalanceChart({
    required this.expenseDetails,
    required this.incomeDetails,
    required this.userDetails,
    required this.controller,
    required this.timeFrameNotifier,
    required this.accountBalance,
    required this.savings,
    required this.showViewMore,
    super.key,
  });

  final List<ExpenseDetails>? expenseDetails;
  final List<IncomeDetails>? incomeDetails;
  final UserDetails userDetails;
  final TextEditingController controller;
  final TimeFrameNotifier timeFrameNotifier; // Changed to TimeFrameNotifier
  final double? accountBalance;
  final List<Saving>? savings;
  final bool showViewMore;

  DateTimeCategoryAxis _buildSavingsPrimaryXAxis(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String timeFrame = timeFrameNotifier.timeFrame;

    return DateTimeCategoryAxis(
      labelStyle: isMobile(context)
          ? textTheme.bodySmall!.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontFamily: 'Roboto',
            )
          : textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontFamily: 'Roboto',
            ),
      axisLine: const AxisLine(width: 0),
      edgeLabelPlacement: EdgeLabelPlacement.shift,
      desiredIntervals: timeFrame == 'Last 3 Month'
          ? 3
          : timeFrame == 'Last 6 Month'
          ? 6
          : 15,
      intervalType: (timeFrame == 'Last 3 Month' || timeFrame == 'Last 6 Month')
          ? DateTimeIntervalType.months
          : DateTimeIntervalType.days,
      majorTickLines: const MajorTickLines(size: 0.0),
      dateFormat: (timeFrame == 'Last 3 Month' || timeFrame == 'Last 6 Month')
          ? DateFormat('MMM')
          : DateFormat('dd'),
    );
  }

  DateTimeAxis _buildPrimaryXAxis(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String timeFrame = timeFrameNotifier.timeFrame;
    final DateTime now = DateTime.now();

    DateTime? minimumDate;
    DateTime? maximumDate;

    if (timeFrame == 'This Year') {
      minimumDate = DateTime(now.year); // Start of the year
      // Find the last day of the current month
      maximumDate = DateTime(now.year, now.month, now.day);
    } else if (timeFrame == 'Last 6 Month') {
      minimumDate = DateTime(now.year, now.month - 5);
      maximumDate = DateTime(now.year, now.month, now.day);
    } else if (timeFrame == 'This Month') {
      minimumDate = DateTime(now.year, now.month); // Start of the month
      maximumDate = DateTime(now.year, now.month, now.day); // Current date
    } else if (timeFrame == 'Last Year') {
      final int pastYear = now.year - 1;
      minimumDate = DateTime(pastYear);
      maximumDate = DateTime(pastYear, 12, 31);
    }

    return DateTimeAxis(
      axisLine: const AxisLine(width: 0),
      minimum: minimumDate,
      maximum: maximumDate,
      labelStyle: isMobile(context)
          ? textTheme.bodySmall!.copyWith(color: colorScheme.onSurfaceVariant)
          : textTheme.bodyMedium!.copyWith(color: colorScheme.onSurfaceVariant),
      edgeLabelPlacement: EdgeLabelPlacement.shift,
      intervalType:
          (timeFrame == 'This Year' ||
              timeFrame == 'Last 6 Month' ||
              timeFrame == 'Last Year')
          ? DateTimeIntervalType.months
          : DateTimeIntervalType.days,
      majorTickLines: const MajorTickLines(size: 0.0),
      desiredIntervals: timeFrame == 'This Year'
          ? DateTime.now().month
          : timeFrame == 'Last 6 Month'
          ? 6
          : timeFrame == 'Last Year'
          ? 12
          : 30,
      dateFormat:
          (timeFrame == 'This Year' ||
              timeFrame == 'Last 6 Month' ||
              timeFrame == 'Last Year')
          ? DateFormat('MMM')
          : DateFormat('dd'),
    );
  }

  NumericAxis _buildPrimaryYAxis(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return NumericAxis(
      labelStyle: isMobile(context)
          ? textTheme.bodySmall!.copyWith(color: colorScheme.onSurfaceVariant)
          : textTheme.bodyMedium!.copyWith(color: colorScheme.onSurfaceVariant),
      rangePadding: ChartRangePadding.additionalEnd,
      axisLine: const AxisLine(width: 0),
      maximumLabels: 2,
      majorTickLines: const MajorTickLines(size: 0),
      minorTickLines: const MinorTickLines(size: 0),
      axisLabelFormatter: (AxisLabelRenderDetails axisLabelRenderArgs) {
        final String currencyFormat = toCurrency(
          parseCurrency(axisLabelRenderArgs.text, userDetails.userProfile),
          userDetails.userProfile,
        );
        final Map<String, String> currencyDetails = separateCurrency(
          currencyFormat,
        );
        final String formattedAmount = NumberFormat.compact().format(
          parseCurrency(currencyDetails['amount']!, userDetails.userProfile),
        );
        final String currencyValue =
            currencyDetails['currency']! + formattedAmount;
        return ChartAxisLabel(currencyValue, axisLabelRenderArgs.textStyle);
      },
      minimum: 0,
    );
  }

  SplineAreaSeries<Saving, DateTime> _buildSavingsFirstSplineAreaSeries(
    BuildContext context,
    List<Saving> savings,
  ) {
    savings.sort((Saving a, Saving b) => a.savingDate.compareTo(b.savingDate));

    return SplineAreaSeries<Saving, DateTime>(
      xValueMapper: (Saving data, int index) => data.savingDate,
      yValueMapper: (Saving data, int index) => data.savedAmount,
      splineType: SplineType.monotonic,
      dataSource: savings,
      markerSettings: const MarkerSettings(
        isVisible: true,
        borderColor: Color.fromRGBO(134, 24, 252, 1),
      ),
      borderColor: const Color.fromRGBO(134, 24, 252, 1),
      gradient: const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [0.1, 0.99],
        colors: [
          Color.fromRGBO(134, 24, 252, 0),
          Color.fromRGBO(134, 24, 252, 0.6),
        ],
      ),
    );
  }

  SplineAreaSeries<IncomeDetails, DateTime> _buildFirstSplineAreaSeries(
    BuildContext context,
    List<IncomeDetails> incomeDetails,
  ) {
    incomeDetails.sort(
      (IncomeDetails a, IncomeDetails b) => a.date.compareTo(b.date),
    );
    return SplineAreaSeries<IncomeDetails, DateTime>(
      xValueMapper: (IncomeDetails incomeDetails, int index) =>
          incomeDetails.date,
      yValueMapper: (IncomeDetails incomeDetails, int index) =>
          incomeDetails.amount,
      name: 'Income',
      splineType: SplineType.monotonic,
      dataSource: incomeDetails,
      borderColor: const Color.fromRGBO(36, 133, 250, 1),
      color: const Color.fromRGBO(36, 133, 250, 1),
      gradient: const LinearGradient(
        stops: <double>[0.25, 0.5, 0.75, 1.0],
        colors: <Color>[
          Color.fromRGBO(36, 133, 250, 0.5),
          Color.fromRGBO(36, 133, 250, 0.4),
          Color.fromRGBO(36, 133, 250, 0.2),
          Color.fromRGBO(36, 133, 250, 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      isVisibleInLegend: incomeDetails.isNotEmpty,
    );
  }

  SplineAreaSeries<ExpenseDetails, DateTime> _buildSecondSplineAreaSeries(
    BuildContext context,
    List<ExpenseDetails> expenseDetails,
  ) {
    expenseDetails.sort(
      (ExpenseDetails a, ExpenseDetails b) => a.date.compareTo(b.date),
    );

    return SplineAreaSeries<ExpenseDetails, DateTime>(
      xValueMapper: (ExpenseDetails expenseDetails, int index) =>
          expenseDetails.date,
      yValueMapper: (ExpenseDetails expenseDetails, int index) =>
          expenseDetails.amount,
      splineType: SplineType.monotonic,
      dataSource: expenseDetails,
      name: 'Expense',
      borderColor: const Color.fromRGBO(204, 74, 224, 1),
      color: const Color.fromRGBO(204, 74, 224, 1),
      gradient: const LinearGradient(
        stops: <double>[0.25, 0.5, 0.75, 1.0],
        colors: <Color>[
          Color.fromRGBO(204, 74, 224, 0.5),
          Color.fromRGBO(204, 74, 224, 0.4),
          Color.fromRGBO(204, 74, 224, 0.2),
          Color.fromRGBO(204, 74, 224, 0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      isVisibleInLegend: expenseDetails.isNotEmpty,
    );
  }

  List<ExpenseDetails> _filterExpenseDetails(String timeFrame) {
    if (expenseDetails == null || expenseDetails!.isEmpty) {
      return [];
    }
    final DateTime now = DateTime.now();

    // if (timeFrame == 'All') {
    //   final DateTime earliest = expenseDetails!
    //       .map((e) => e.date)
    //       .reduce((a, b) => a.isBefore(b) ? a : b);
    //   final DateTime latest = expenseDetails!
    //       .map((e) => e.date)
    //       .reduce((a, b) => a.isAfter(b) ? a : b);

    //   final Map<String, double> monthlyTotals = {
    //     for (DateTime date = earliest;
    //         date.isBefore(DateTime(latest.year, latest.month + 1));
    //         date = DateTime(date.year, date.month + 1))
    //       '${date.year}-${date.month}': 0.0,
    //   };

    //   for (final details in expenseDetails!) {
    //     final String monthKey = '${details.date.year}-${details.date.month}';
    //     monthlyTotals.update(
    //       monthKey,
    //       (value) => value + details.amount,
    //     );
    //   }

    //   return monthlyTotals.entries.map(
    //     (entry) {
    //       final parts = entry.key.split('-');
    //       return ExpenseDetails(
    //         date: DateTime(int.parse(parts[0]), int.parse(parts[1])),
    //         amount: entry.value,
    //         category: 'Total',
    //         budgetAmount: double.infinity,
    //       );
    //     },
    //   ).toList();
    // } else

    if (timeFrame == 'This Year') {
      final int currentMonth = DateTime.now().month;
      final int currentYear = DateTime.now().year;

      final Map<int, double> monthlyTotals = {
        for (int i = 1; i <= currentMonth; i++) i: 0.0,
      };

      for (final ExpenseDetails details in expenseDetails!) {
        if (details.date.year == currentYear &&
            details.date.month <= currentMonth) {
          monthlyTotals.update(
            details.date.month,
            (value) => value + details.amount,
            ifAbsent: () => details.amount,
          );
        }
      }

      return monthlyTotals.entries.map((entry) {
        final isCurrentMonth = entry.key == currentMonth;
        final day = isCurrentMonth ? DateTime.now().day : 1;

        return ExpenseDetails(
          date: DateTime(currentYear, entry.key, day),
          amount: entry.value,
          category: '',
          budgetAmount: double.infinity,
        );
      }).toList();
    } else if (timeFrame == 'Last Year') {
      // // final int currentDay = DateTime.now().day;
      final int pastYear = DateTime.now().year - 1;

      final Map<int, double> monthlyTotals = {
        for (int i = 1; i <= 12; i++) i: 0.0,
      };

      for (final ExpenseDetails details in expenseDetails!) {
        if (details.date.year == pastYear && details.date.month <= 12) {
          monthlyTotals.update(
            details.date.month,
            (value) => value + details.amount,
            ifAbsent: () => details.amount,
          );
        }
      }

      return monthlyTotals.entries
          .map(
            (entry) => ExpenseDetails(
              date: DateTime(pastYear, entry.key),
              amount: entry.value,
              category: '',
              budgetAmount: double.infinity,
            ),
          )
          .toList();
    } else if (timeFrame == 'Last 6 Month') {
      final List<DateTime> last6Months = List.generate(6, (index) {
        return DateTime(now.year, now.month - index);
      }).reversed.toList();

      final Map<DateTime, double> monthlyTotals = {
        for (final month in last6Months) month: 0.0,
      }; // Initialize all months with 0

      for (final details in expenseDetails!) {
        final DateTime monthKey = DateTime(
          details.date.year,
          details.date.month,
        );
        if (monthlyTotals.containsKey(monthKey)) {
          monthlyTotals.update(monthKey, (value) => value + details.amount);
        }
      }

      return last6Months.map((month) {
        final isCurrentMonth =
            month.year == now.year && month.month == now.month;
        final day = isCurrentMonth ? now.day : 1;
        return ExpenseDetails(
          date: DateTime(month.year, month.month, day),
          amount: monthlyTotals[month]!,
          category: '',
          budgetAmount: double.infinity,
        );
      }).toList();
    } else if (timeFrame == 'This Month') {
      final int daysInMonth = DateTime(
        now.year,
        now.month + 1,
        0,
      ).day; // Get total days in current month
      final Map<int, double> dailyTotals = {
        for (var i = 1; i <= daysInMonth; i++) i: 0.0,
      }; // Initialize all days with 0

      for (final ExpenseDetails details in expenseDetails!) {
        if (details.date.year == now.year && details.date.month == now.month) {
          dailyTotals.update(
            details.date.day,
            (value) => value + details.amount,
          );
        }
      }

      return dailyTotals.entries
          .map(
            (entry) => ExpenseDetails(
              date: DateTime(now.year, now.month, entry.key),
              amount: entry.value,
              category: '',
              budgetAmount: double.infinity,
            ),
          )
          .toList();
    }

    return expenseDetails!;
  }

  List<IncomeDetails> _filterIncomeDetails(String timeFrame) {
    if (incomeDetails!.isEmpty) {
      return [];
    }
    final DateTime now = DateTime.now();

    // if (timeFrame == 'All') {
    //   final DateTime earliest = incomeDetails!
    //       .map((e) => e.date)
    //       .reduce((a, b) => a.isBefore(b) ? a : b);
    //   final DateTime latest = incomeDetails!
    //       .map((e) => e.date)
    //       .reduce((a, b) => a.isAfter(b) ? a : b);

    //   final Map<String, double> monthlyTotals = {
    //     for (DateTime date = earliest;
    //         date.isBefore(DateTime(latest.year, latest.month + 1));
    //         date = DateTime(date.year, date.month + 1))
    //       '${date.year}-${date.month}': 0.0,
    //   };

    //   for (final details in incomeDetails!) {
    //     final String monthKey = '${details.date.year}-${details.date.month}';
    //     monthlyTotals.update(
    //       monthKey,
    //       (value) => value + details.amount,
    //     );
    //   }

    //   return monthlyTotals.entries.map(
    //     (entry) {
    //       final parts = entry.key.split('-');
    //       return IncomeDetails(
    //         date: DateTime(int.parse(parts[0]), int.parse(parts[1])),
    //         amount: entry.value,
    //         category: 'Total',
    //       );
    //     },
    //   ).toList();
    // } else
    if (timeFrame == 'This Year') {
      final int currentMonth = DateTime.now().month;
      final int currentYear = DateTime.now().year;

      final Map<int, double> monthlyTotals = {
        for (int i = 1; i <= currentMonth; i++) i: 0.0,
      };

      for (final IncomeDetails details in incomeDetails!) {
        if (details.date.year == currentYear &&
            details.date.month <= currentMonth) {
          monthlyTotals.update(
            details.date.month,
            (value) => value + details.amount,
            ifAbsent: () => details.amount,
          );
        }
      }

      return monthlyTotals.entries.map((entry) {
        final isCurrentMonth = entry.key == currentMonth;
        final day = isCurrentMonth ? DateTime.now().day : 1;

        return IncomeDetails(
          date: DateTime(currentYear, entry.key, day),
          amount: entry.value,
          category: '',
        );
      }).toList();
    } else if (timeFrame == 'Last Year') {
      // // final int currentDay = DateTime.now().day;

      final int pastYear = DateTime.now().year - 1;

      final Map<int, double> monthlyTotals = {
        for (int i = 1; i <= 12; i++) i: 0.0,
      };

      for (final IncomeDetails details in incomeDetails!) {
        if (details.date.year == pastYear) {
          monthlyTotals.update(
            details.date.month,
            (value) => value + details.amount,
            ifAbsent: () => details.amount,
          );
        }
      }

      return monthlyTotals.entries
          .map(
            (entry) => IncomeDetails(
              date: DateTime(pastYear, entry.key),
              amount: entry.value,
              category: '',
            ),
          )
          .toList();
    } else if (timeFrame == 'Last 6 Month') {
      final List<DateTime> last6Months = List.generate(6, (index) {
        return DateTime(now.year, now.month - index);
      }).reversed.toList();

      final Map<DateTime, double> monthlyTotals = {
        for (final DateTime month in last6Months) month: 0.0,
      };

      for (final IncomeDetails details in incomeDetails!) {
        final DateTime monthKey = DateTime(
          details.date.year,
          details.date.month,
        );
        if (monthlyTotals.containsKey(monthKey)) {
          monthlyTotals.update(monthKey, (value) => value + details.amount);
        }
      }

      return last6Months.map((month) {
        final isCurrentMonth =
            month.year == now.year && month.month == now.month;
        final day = isCurrentMonth ? now.day : 1;
        return IncomeDetails(
          date: DateTime(month.year, month.month, day),
          amount: monthlyTotals[month]!,
          category: '',
        );
      }).toList();
    } else if (timeFrame == 'This Month') {
      final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      final Map<int, double> dailyTotals = {
        for (var i = 1; i <= daysInMonth; i++) i: 0.0,
      };

      for (final IncomeDetails details in incomeDetails!) {
        if (details.date.year == now.year && details.date.month == now.month) {
          dailyTotals.update(
            details.date.day,
            (value) => value + details.amount,
          );
        }
      }

      return dailyTotals.entries
          .map(
            (entry) => IncomeDetails(
              date: DateTime(now.year, now.month, entry.key),
              amount: entry.value,
              category: '',
            ),
          )
          .toList();
    }

    return incomeDetails!;
  }

  List<Saving> _filterSavingsDetails(List<Saving>? savings, String timeFrame) {
    if (savings == null || savings.isEmpty) {
      return [];
    }

    final DateTime now = DateTime.now();

    // if (timeFrame == 'All') {
    //   final DateTime earliest = savings
    //       .map((s) => s.savingDate)
    //       .reduce((a, b) => a.isBefore(b) ? a : b);
    //   final DateTime latest = savings
    //       .map((s) => s.savingDate)
    //       .reduce((a, b) => a.isAfter(b) ? a : b);

    //   final Map<String, double> monthlyTotals = {
    //     for (DateTime date = earliest;
    //         date.isBefore(DateTime(latest.year, latest.month + 1));
    //         date = DateTime(date.year, date.month + 1))
    //       '${date.year}-${date.month}': 0.0,
    //   };

    //   for (final saving in savings) {
    //     final String monthKey =
    //         '${saving.savingDate.year}-${saving.savingDate.month}';
    //     monthlyTotals.update(
    //       monthKey,
    //       (value) => value + saving.savedAmount,
    //     );
    //   }

    //   return monthlyTotals.entries.map(
    //     (entry) {
    //       final parts = entry.key.split('-');
    //       return Saving(
    //         savingDate: DateTime(int.parse(parts[0]), int.parse(parts[1])),
    //         savedAmount: entry.value,
    //         name: 'Total',
    //         type: '',
    //       );
    //     },
    //   ).toList();
    // } else
    if (timeFrame == 'Last 3 Month') {
      final List<DateTime> last3Months = List.generate(3, (index) {
        return DateTime(now.year, now.month - index);
      }).reversed.toList();

      final Map<DateTime, double> monthlyTotals = {
        for (final DateTime month in last3Months) month: 0.0,
      };

      for (final Saving saving in savings) {
        final DateTime monthKey = DateTime(
          saving.savingDate.year,
          saving.savingDate.month,
        );
        if (monthlyTotals.containsKey(monthKey)) {
          monthlyTotals.update(monthKey, (value) => value + saving.savedAmount);
        }
      }

      return last3Months
          .map(
            (month) => Saving(
              savingDate: month,
              savedAmount: monthlyTotals[month]!,
              name: '',
              type: '',
            ),
          )
          .toList();
    } else if (timeFrame == 'Last 6 Month') {
      final List<DateTime> last6Months = List.generate(6, (index) {
        return DateTime(now.year, now.month - index);
      }).reversed.toList();

      final Map<DateTime, double> monthlyTotals = {
        for (final DateTime month in last6Months) month: 0.0,
      };

      for (final Saving saving in savings) {
        final DateTime monthKey = DateTime(
          saving.savingDate.year,
          saving.savingDate.month,
        );
        if (monthlyTotals.containsKey(monthKey)) {
          monthlyTotals.update(monthKey, (value) => value + saving.savedAmount);
        }
      }

      return last6Months
          .map(
            (month) => Saving(
              savingDate: month,
              savedAmount: monthlyTotals[month]!,
              name: '',
              type: '',
            ),
          )
          .toList();
    } else if (timeFrame == 'This Month') {
      final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      final Map<int, double> dailyTotals = {
        for (var i = 1; i <= daysInMonth; i++) i: 0.0,
      };

      for (final Saving saving in savings) {
        if (saving.savingDate.year == now.year &&
            saving.savingDate.month == now.month) {
          dailyTotals.update(
            saving.savingDate.day,
            (value) => value + saving.savedAmount,
          );
        }
      }

      return dailyTotals.entries
          .map(
            (entry) => Saving(
              savingDate: DateTime(now.year, now.month, entry.key),
              savedAmount: entry.value,
              name: '',
              type: '',
            ),
          )
          .toList();
    }

    return savings;
  }

  @override
  Widget build(BuildContext context) {
    final String selectedTimeFrame = timeFrameNotifier.timeFrame;
    List<ExpenseDetails> filteredExpenses = [];
    List<IncomeDetails> filteredIncome = [];
    List<Saving> processedSavings = [];

    if (showViewMore) {
      processedSavings = _filterSavingsDetails(savings, selectedTimeFrame);
    } else {
      filteredExpenses = _filterExpenseDetails(selectedTimeFrame);
      filteredIncome = _filterIncomeDetails(selectedTimeFrame);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SfCartesianChart(
        legend: Legend(
          isVisible: !showViewMore,
          position: LegendPosition.bottom,
          legendItemBuilder:
              (String name, dynamic series, dynamic point, int index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: series.color,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                );
              },
        ),
        margin: EdgeInsets.zero,
        primaryXAxis: showViewMore
            ? _buildSavingsPrimaryXAxis(context)
            : _buildPrimaryXAxis(context),
        primaryYAxis: _buildPrimaryYAxis(context),
        series: <CartesianSeries<dynamic, DateTime>>[
          if (showViewMore)
            _buildSavingsFirstSplineAreaSeries(context, processedSavings)
          else ...[
            _buildFirstSplineAreaSeries(context, filteredIncome),
            _buildSecondSplineAreaSeries(context, filteredExpenses),
          ],
        ],
      ),
    );
  }
}

Widget _buildMonthlyFilterDropDown(
  BuildContext context,
  TextEditingController controller,
  TimeFrameNotifier timeFrameNotifier,
  bool showViewMore,
  bool isPopupOpen,
) {
  return _buildDropDownMenu(
    context,
    controller,
    timeFrameNotifier,
    showViewMore,
    isPopupOpen,
  );
}

Widget _buildDropDownMenu(
  BuildContext context,
  TextEditingController controller,
  TimeFrameNotifier timeFrameNotifier,
  bool showViewMore,
  bool isPopupOpen,
) {
  // final AppLocalizations localizations = AppLocalizations.of(context)!;
  final List<String> timeFrames = [
    'This Month',
    'This Year',
    'Last Year',
    'Last 6 Month',
  ];

  final List<String> savingTimeFrames = [
    'Last 6 Month',
    'Last 3 Month',
    'This Month',
  ];

  final ThemeData themeData = Theme.of(context);

  if (!isMobile(context)) {
    if (isPopupOpen) {
      Navigator.of(context).maybePop();
      isPopupOpen = false;
    }
  }

  if (isMobile(context)) {
    return Theme(
      data: ThemeData(
        hoverColor: themeData.colorScheme.primaryContainer,
        highlightColor: themeData.colorScheme.primaryContainer,
        // menuPadding: const EdgeInsets.symmetric(
        //   horizontal: 16,
        //   vertical: 8,
        // ),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: PopupMenuButton(
          onSelected: (String? value) {
            if (value != null) {
              timeFrameNotifier.timeFrame =
                  value; // Using setter to trigger update
            }
          },
          color: themeData.colorScheme.onPrimary,
          surfaceTintColor: themeData.colorScheme.onPrimary,
          elevation: 4,
          iconSize: 32,
          tooltip: '',
          iconColor: themeData.colorScheme.onSurfaceVariant,
          position: PopupMenuPosition.under,
          icon: const Icon(
            IconData(0xe72b, fontFamily: fontIconFamily),
            // color: themeData.colorScheme.onSurfaceVariant,
            // size: 32.0,
          ),
          itemBuilder: (context) {
            return List.generate(
              showViewMore ? savingTimeFrames.length : timeFrames.length,
              (int index) {
                return PopupMenuItem(
                  value: showViewMore
                      ? savingTimeFrames[index]
                      : timeFrames[index],
                  child: showViewMore
                      ? Text(
                          savingTimeFrames[index],
                          style: themeData.textTheme.labelLarge!.copyWith(
                            color: themeData.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : Text(
                          timeFrames[index],
                          style: themeData.textTheme.labelLarge!.copyWith(
                            color: themeData.colorScheme.onSurfaceVariant,
                          ),
                        ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  return DropdownMenuTheme(
    data: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        mouseCursor: const WidgetStatePropertyAll(MouseCursor.uncontrolled),
        alignment: Alignment.bottomLeft,
        elevation: const WidgetStatePropertyAll(4),
        side: WidgetStatePropertyAll(
          BorderSide(color: themeData.colorScheme.surfaceContainerLow),
        ),
        shadowColor: WidgetStatePropertyAll(
          themeData.colorScheme.surfaceContainerLow,
        ),
        backgroundColor: WidgetStatePropertyAll(
          themeData.colorScheme.surfaceContainerLow,
        ),
        surfaceTintColor: WidgetStatePropertyAll(
          themeData.colorScheme.surfaceContainerLow,
        ),
        fixedSize: const WidgetStatePropertyAll(Size(200, double.infinity)),
      ),
      textStyle: themeData.textTheme.labelLarge!.copyWith(
        color: themeData.colorScheme.onSurfaceVariant,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isCollapsed: true,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        constraints: const BoxConstraints(maxHeight: 40.0),
        iconColor: themeData.colorScheme.onSurfaceVariant,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: themeData.colorScheme.outlineVariant),
        ),
        outlineBorder: BorderSide(color: themeData.colorScheme.outlineVariant),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: themeData.colorScheme.outlineVariant),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: themeData.colorScheme.outlineVariant),
        ),
        activeIndicatorBorder: BorderSide(
          color: themeData.colorScheme.outlineVariant,
        ),
        fillColor: themeData.colorScheme.surface,
        filled: true,
      ),
    ),
    child: DropdownMenu<String>(
      width: 200.0,
      requestFocusOnTap: false,
      inputFormatters: const [],
      leadingIcon: Icon(
        const IconData(0xe72b, fontFamily: fontIconFamily),
        color: themeData.colorScheme.onSurfaceVariant,
        size: 18.0,
      ),
      textAlign: TextAlign.left,
      trailingIcon: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Icon(
          Icons.arrow_drop_down,
          size: 18.0,
          color: themeData.colorScheme.onSurfaceVariant,
        ),
      ),
      selectedTrailingIcon: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Icon(
          Icons.arrow_drop_down,
          size: 18.0,
          color: themeData.colorScheme.onSurfaceVariant,
        ),
      ),
      enableSearch: false,
      textStyle: themeData.textTheme.bodyLarge!.copyWith(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        color: themeData.colorScheme.onSurfaceVariant,
      ),
      keyboardType: TextInputType.none,
      initialSelection: timeFrameNotifier.timeFrame,
      onSelected: (String? value) {
        if (value != null) {
          timeFrameNotifier.timeFrame = value; // Using setter to trigger update
        }
      },
      dropdownMenuEntries: List.generate(
        showViewMore ? savingTimeFrames.length : timeFrames.length,
        (int index) {
          final T = showViewMore ? savingTimeFrames[index] : timeFrames[index];
          final isSelected = timeFrameNotifier.timeFrame == T;
          return DropdownMenuEntry<String>(
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.only(left: 16, top: 8, bottom: 8),
              ),
              // overlayColor: WidgetStatePropertyAll(
              //   themeData.colorScheme.primaryContainer,
              // ),
              backgroundColor: WidgetStatePropertyAll(
                isSelected
                    ? themeData.colorScheme.primaryContainer
                    : themeData.colorScheme.surfaceContainerLow,
              ),
            ),
            value: showViewMore ? savingTimeFrames[index] : timeFrames[index],
            label: showViewMore ? savingTimeFrames[index] : timeFrames[index],
          );
        },
      ),
    ),
  );
}
