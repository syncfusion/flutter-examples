import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../enum.dart';
import '../model/chart_data.dart';
import '../notifier/stock_chart_notifier.dart';
import '../stock_home/stock_chart_view/stock_chart.dart';
import '../stock_home/stock_chart_view/stock_date_picker.dart';

const String stockFontIconFamily = 'Stock Analysis Font Icon';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

extension StringCasingExtension on String {
  String capitalizeFirst() {
    if (isEmpty) {
      return '';
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

FontWeight? fontWeight400() {
  return kIsWeb ? FontWeight.w500 : null;
}

FontWeight? fontWeight500() {
  return kIsWeb ? FontWeight.w600 : FontWeight.w500;
}

Widget buildCloseIconButton(BuildContext context, VoidCallback? onPressed) {
  return IconButton(
    icon: const Icon(
      IconData(0xe717, fontFamily: stockFontIconFamily),
      size: 24,
    ),
    onPressed: onPressed,
  );
}

Future<void> showDatePickerDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ExtendableRangeSelectionDatepickerDialog(
            onRangeDateSelected: (DateTime startDate, DateTime endDate) {
              final StockChartProvider provider = context
                  .read<StockChartProvider>();
              primaryChartAxisController?.visibleMinimum = startDate;
              primaryChartAxisController?.visibleMaximum = endDate;
              for (final DateTimeAxisController? axisController
                  in provider.zoomingHandlerList.values) {
                axisController?.visibleMinimum = startDate;
                axisController?.visibleMaximum = endDate;
              }
              context.read<StockChartProvider>()
                ..customDateRange = CustomDateRange(
                  start: startDate,
                  end: endDate,
                )
                ..selectedDateRange = DateRange.customRange
                ..isFilteringRange(true);
            },
          );
        },
      );
    },
  );
}

void updateDateRange(BuildContext context, DateRange selectedDateRange) {
  final DateTime now = DateTime(2025);
  final StockChartProvider provider = context.read<StockChartProvider>();
  primaryChartAxisController?.visibleMaximum = now;
  switch (selectedDateRange) {
    case DateRange.oneMonth:
      primaryChartAxisController?.visibleMinimum = DateTime(
        now.year,
        now.month - 1,
        now.day,
      );
      for (final DateTimeAxisController? axisController
          in provider.zoomingHandlerList.values) {
        axisController?.visibleMinimum = DateTime(
          now.year,
          now.month - 1,
          now.day,
        );
        axisController?.visibleMaximum = now;
      }
      break;
    case DateRange.threeMonth:
      primaryChartAxisController?.visibleMinimum = DateTime(
        now.year,
        now.month - 3,
        now.day,
      );
      for (final DateTimeAxisController? axisController
          in provider.zoomingHandlerList.values) {
        axisController?.visibleMinimum = DateTime(
          now.year,
          now.month - 3,
          now.day,
        );
        axisController?.visibleMaximum = now;
      }
      break;
    case DateRange.fiveMonth:
      primaryChartAxisController?.visibleMinimum = DateTime(
        now.year,
        now.month - 5,
        now.day,
      );
      for (final DateTimeAxisController? axisController
          in provider.zoomingHandlerList.values) {
        axisController?.visibleMinimum = DateTime(
          now.year,
          now.month - 5,
          now.day,
        );
        axisController?.visibleMaximum = now;
      }
      break;
    case DateRange.oneYear:
      primaryChartAxisController?.visibleMinimum = DateTime(
        now.year - 1,
        now.month,
        now.day,
      );
      for (final DateTimeAxisController? axisController
          in provider.zoomingHandlerList.values) {
        axisController?.visibleMinimum = DateTime(
          now.year - 1,
          now.month,
          now.day,
        );
        axisController?.visibleMaximum = now;
      }
      break;
    case DateRange.customRange:
      primaryChartAxisController?.visibleMinimum =
          provider.customDateRange.start ??
          DateTime.parse(provider.viewModel.dataCollections.first.date);
      primaryChartAxisController?.visibleMinimum =
          provider.customDateRange.end ??
          DateTime.parse(provider.viewModel.dataCollections.last.date);
      for (final DateTimeAxisController? axisController
          in provider.zoomingHandlerList.values) {
        axisController?.visibleMinimum =
            provider.customDateRange.start ??
            DateTime.parse(provider.viewModel.dataCollections.first.date);
        axisController?.visibleMaximum =
            provider.customDateRange.end ??
            DateTime.parse(provider.viewModel.dataCollections.last.date);
      }
      break;
    case DateRange.all:
      primaryChartAxisController?.visibleMinimum = DateTime.parse(
        provider.viewModel.dataCollections.first.date,
      );
      for (final DateTimeAxisController? axisController
          in provider.zoomingHandlerList.values) {
        axisController?.visibleMinimum = DateTime.parse(
          provider.viewModel.dataCollections.first.date,
        );
        axisController?.visibleMaximum = now;
      }
      // // For "All" view, we still want to set the range to show all data
      // final List<Data> dataToUse = provider.viewModel.dataCollections;
      // if (dataToUse.isNotEmpty) {
      //   primaryChartAxisController?.visibleMinimum = DateTime.parse(
      //     dataToUse.first.date,
      //   );

      //   for (final DateTimeAxisController? axisController
      //       in provider.zoomingHandlerList.values) {
      //     axisController?.visibleMinimum = DateTime.parse(dataToUse.first.date);
      //     axisController?.visibleMaximum = now;
      //   }
      // }
      break;
  }
}
