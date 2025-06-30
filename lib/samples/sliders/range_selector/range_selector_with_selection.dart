///Package imports
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

///Chart import
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;

///Core import
import 'package:syncfusion_flutter_core/core.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local import
import '../../../model/sample_view.dart';

/// Renders the range selector with column chart selection option
class RangeSelectorSelectionPage extends SampleView {
  /// Creates the range selector with column chart selection option
  const RangeSelectorSelectionPage(Key key) : super(key: key);

  @override
  _RangeSelectorSelectionPageState createState() =>
      _RangeSelectorSelectionPageState();
}

class _RangeSelectorSelectionPageState extends SampleViewState
    with SingleTickerProviderStateMixin {
  _RangeSelectorSelectionPageState();

  final DateTime min = DateTime(2019, 04), max = DateTime(2019, 04, 30, 24);
  late RangeController rangeController;
  late TextEditingController textController;
  late List<_ChartData> data;
  late List<int> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = <int>[];
    textController = TextEditingController(text: 'Total data usage : 80GB');
    rangeController = RangeController(
      start: DateTime(2019, 04, 6),
      end: DateTime(2019, 04, 15),
    );
    data = <_ChartData>[
      _ChartData(DateTime(2019, 04), 0.2),
      _ChartData(DateTime(2019, 04, 02), 0.3),
      _ChartData(DateTime(2019, 04, 03), 0.4),
      _ChartData(DateTime(2019, 04, 04), 0.6),
      _ChartData(DateTime(2019, 04, 05), 0.8),
      _ChartData(DateTime(2019, 04, 06), 1.2),
      _ChartData(DateTime(2019, 04, 07), 1.6),
      _ChartData(DateTime(2019, 04, 08), 2.4),
      _ChartData(DateTime(2019, 04, 09), 3.2),
      _ChartData(DateTime(2019, 04, 10), 4.8),
      _ChartData(DateTime(2019, 04, 11), 6.4),
      _ChartData(DateTime(2019, 04, 12), 9.6),
      _ChartData(DateTime(2019, 04, 13), 12.8),
      _ChartData(DateTime(2019, 04, 14), 16.0),
      _ChartData(DateTime(2019, 04, 15), 22.0),
      _ChartData(DateTime(2019, 04, 16), 25.6),
      _ChartData(DateTime(2019, 04, 17), 20.0),
      _ChartData(DateTime(2019, 04, 18), 14.5),
      _ChartData(DateTime(2019, 04, 19), 12.8),
      _ChartData(DateTime(2019, 04, 20), 10.0),
      _ChartData(DateTime(2019, 04, 21), 6.6),
      _ChartData(DateTime(2019, 04, 22), 5.0),
      _ChartData(DateTime(2019, 04, 23), 3.2),
      _ChartData(DateTime(2019, 04, 24), 3.2),
      _ChartData(DateTime(2019, 04, 25), 1.6),
      _ChartData(DateTime(2019, 04, 26), 1.6),
      _ChartData(DateTime(2019, 04, 27), 0.8),
      _ChartData(DateTime(2019, 04, 28), 0.8),
      _ChartData(DateTime(2019, 04, 29), 0.4),
      _ChartData(DateTime(2019, 04, 30), 0.2),
    ];
  }

  @override
  void dispose() {
    textController.dispose();
    rangeController.dispose();
    data.clear();
    selectedItems.clear();
    super.dispose();
  }

  void _setTotalDataUsage(SfRangeValues values) {
    double dataUsage = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].date.isAfter(
            //ignore: avoid_as
            (values.start as DateTime).subtract(const Duration(hours: 1)),
          ) &&
          data[i].date.isBefore(
            //ignore: avoid_as
            (values.end as DateTime).add(const Duration(hours: 1)),
          )) {
        dataUsage += data[i].runs;
      }
    }
    textController.text =
        'Total data usage : ' + dataUsage.toStringAsFixed(1) + 'GB';
  }

  @override
  Widget build(BuildContext context) {
    selectedItems.clear();
    final ThemeData themeData = Theme.of(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    for (int i = 0; i < data.length; i++) {
      if (data[i].date.millisecondsSinceEpoch >=
              rangeController.start.millisecondsSinceEpoch &&
          data[i].date.millisecondsSinceEpoch <=
              rangeController.end.millisecondsSinceEpoch) {
        selectedItems.add(data.indexOf(data[i]));
      }
    }

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Center(
              child: SfRangeSelectorTheme(
                data: SfRangeSelectorThemeData(
                  labelOffset: const Offset(0, 2),
                  thumbColor: Colors.white,
                  overlayColor: const Color.fromRGBO(0, 178, 206, 0.24),
                  activeTrackColor: const Color.fromRGBO(0, 178, 206, 1),
                  thumbStrokeColor: const Color.fromRGBO(0, 178, 206, 1),
                  thumbStrokeWidth: 2.0,
                  inactiveTrackColor: const Color.fromRGBO(194, 194, 194, 1),
                  activeLabelStyle: TextStyle(
                    fontSize: 12,
                    color: themeData.textTheme.bodyLarge!.color!.withValues(
                      alpha: 0.87,
                    ),
                  ),
                  inactiveLabelStyle: TextStyle(
                    fontSize: 12,
                    color: themeData.textTheme.bodyLarge!.color!.withValues(
                      alpha: 0.87,
                    ),
                  ),
                  inactiveRegionColor: Colors.transparent,
                ),
                child: SfRangeSelector(
                  min: min,
                  max: max,
                  dateIntervalType: DateIntervalType.days,
                  interval: 5.0,
                  controller: rangeController,
                  stepDuration: const SliderStepDuration(days: 1),
                  dateFormat: DateFormat.MMMd(),
                  showTicks: true,
                  showLabels: true,
                  onChanged: (SfRangeValues values) {
                    _setTotalDataUsage(values);
                  },
                  child: SizedBox(
                    width: mediaQueryData.orientation == Orientation.landscape
                        ? model.isWebFullView
                              ? mediaQueryData.size.width * 0.5
                              : mediaQueryData.size.width
                        : mediaQueryData.size.width,
                    height: mediaQueryData.size.height * 0.55 - 25,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SfCartesianChart(
                        title: const ChartTitle(
                          text: 'Data Usage For April 2019',
                        ),
                        margin: EdgeInsets.zero,
                        primaryXAxis: DateTimeAxis(
                          isVisible: false,
                          minimum: DateTime(2019, 04),
                          maximum: DateTime(2019, 05),
                          interval: 5,
                          intervalType: DateTimeIntervalType.days,
                          enableAutoIntervalOnZooming: false,
                        ),
                        primaryYAxis: const NumericAxis(
                          isVisible: false,
                          maximum: 26,
                        ),
                        plotAreaBorderWidth: 0,
                        plotAreaBackgroundColor: Colors.transparent,
                        enableMultiSelection: true,
                        series: <CartesianSeries<_ChartData, DateTime>>[
                          ColumnSeries<_ChartData, DateTime>(
                            width: 0.8,
                            initialSelectedDataIndexes: selectedItems,
                            selectionBehavior: SelectionBehavior(
                              enable: true,
                              // unselectedOpacity: 0,
                              selectedBorderColor: const Color.fromRGBO(
                                0,
                                178,
                                206,
                                1,
                              ),
                              selectedColor: const Color.fromRGBO(
                                0,
                                178,
                                206,
                                1,
                              ),
                              unselectedColor: Colors.transparent,
                              unselectedBorderColor: const Color.fromRGBO(
                                194,
                                194,
                                194,
                                1,
                              ),
                              selectionController: rangeController,
                            ),
                            dashArray: model.isWebFullView
                                ? null
                                : <double>[3, 2],
                            color: const Color.fromRGBO(255, 255, 255, 0),
                            borderColor: const Color.fromRGBO(194, 194, 194, 1),
                            animationDuration: 0,
                            borderWidth: 1,
                            dataSource: data,
                            xValueMapper: (_ChartData score, _) => score.date,
                            yValueMapper: (_ChartData score, _) => score.runs,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                mediaQueryData.orientation == Orientation.landscape ||
                    model.isWebFullView
                ? EdgeInsets.only(bottom: mediaQueryData.size.height * 0.025)
                : EdgeInsets.only(bottom: mediaQueryData.size.height * 0.1),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 250,
                height: 20,
                child: TextField(
                  controller: textController,
                  enabled: false,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.runs);
  final DateTime date;
  final num runs;
}
