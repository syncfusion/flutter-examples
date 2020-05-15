import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// ignore: must_be_immutable
class RangeSelectorSelectionPage extends StatefulWidget {
  RangeSelectorSelectionPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSelectorSelectionPageState createState() =>
      _RangeSelectorSelectionPageState(sample);
}

class _RangeSelectorSelectionPageState extends State<RangeSelectorSelectionPage>
    with SingleTickerProviderStateMixin {
  _RangeSelectorSelectionPageState(this.sample);

  final SubItem sample;
  final DateTime min = DateTime(2019, 04, 01), max = DateTime(2019, 04, 30, 24);
  RangeController rangeController;
  TextEditingController textController;
  List<ChartData> data;
  List<int> selectedItems;
  SfCartesianChart cartesianChart;

  @override
  void initState() {
    super.initState();
    selectedItems = <int>[];
    textController = TextEditingController(text: 'Total data usage : 80GB');
    rangeController = RangeController(
      start: DateTime(2019, 04, 6),
      end: DateTime(2019, 04, 15),
    );
    data = <ChartData>[
      ChartData(DateTime(2019, 04, 01), 0.2),
      ChartData(DateTime(2019, 04, 02), 0.3),
      ChartData(DateTime(2019, 04, 03), 0.4),
      ChartData(DateTime(2019, 04, 04), 0.6),
      ChartData(DateTime(2019, 04, 05), 0.8),
      ChartData(DateTime(2019, 04, 06), 1.2),
      ChartData(DateTime(2019, 04, 07), 1.6),
      ChartData(DateTime(2019, 04, 08), 2.4),
      ChartData(DateTime(2019, 04, 09), 3.2),
      ChartData(DateTime(2019, 04, 10), 4.8),
      ChartData(DateTime(2019, 04, 11), 6.4),
      ChartData(DateTime(2019, 04, 12), 9.6),
      ChartData(DateTime(2019, 04, 13), 12.8),
      ChartData(DateTime(2019, 04, 14), 16.0),
      ChartData(DateTime(2019, 04, 15), 22.0),
      ChartData(DateTime(2019, 04, 16), 25.6),
      ChartData(DateTime(2019, 04, 17), 20.0),
      ChartData(DateTime(2019, 04, 18), 14.5),
      ChartData(DateTime(2019, 04, 19), 12.8),
      ChartData(DateTime(2019, 04, 20), 10.0),
      ChartData(DateTime(2019, 04, 21), 6.6),
      ChartData(DateTime(2019, 04, 22), 5.0),
      ChartData(DateTime(2019, 04, 23), 3.2),
      ChartData(DateTime(2019, 04, 24), 3.2),
      ChartData(DateTime(2019, 04, 25), 1.6),
      ChartData(DateTime(2019, 04, 26), 1.6),
      ChartData(DateTime(2019, 04, 27), 0.8),
      ChartData(DateTime(2019, 04, 28), 0.8),
      ChartData(DateTime(2019, 04, 29), 0.4),
      ChartData(DateTime(2019, 04, 30), 0.2)
    ];
  }

  void _setTotalDataUsage(SfRangeValues values) {
    double dataUsage = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].date.isAfter(
              //ignore: avoid_as
              (values.start as DateTime).subtract(const Duration(hours: 1))) &&
          data[i].date.isBefore(
              //ignore: avoid_as
              (values.end as DateTime).add(const Duration(hours: 1)))) {
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
    cartesianChart = SfCartesianChart(
      title: ChartTitle(text: 'Data usage for April 2019'),
      margin: const EdgeInsets.all(0),
      primaryXAxis: DateTimeAxis(
          isVisible: false,
          minimum: DateTime(2019, 04, 01),
          maximum: DateTime(2019, 04, 30, 24)),
      primaryYAxis: NumericAxis(isVisible: false),
      plotAreaBorderWidth: 0,
      plotAreaBackgroundColor: Colors.transparent,
      series: <CartesianSeries<ChartData, DateTime>>[
        ColumnSeries<ChartData, DateTime>(
          width: 0.8,
          initialSelectedDataIndexes: selectedItems,
          selectionSettings: SelectionSettings(
              enable: true,
              unselectedOpacity: 0,
              selectedBorderColor: const Color.fromRGBO(0, 178, 206, 1),
              selectedColor: const Color.fromRGBO(0, 178, 206, 1),
              unselectedColor: Colors.transparent,
              selectionController: rangeController),
          dashArray: <double>[3, 2],
          color: const Color.fromRGBO(255, 255, 255, 0),
          borderColor: const Color.fromRGBO(194, 194, 194, 1),
          animationDuration: 0,
          borderWidth: 1,
          dataSource: data,
          xValueMapper: (ChartData score, _) => score.date,
          yValueMapper: (ChartData score, _) => score.runs,
        )
      ],
    );
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(0),
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: SfRangeSelectorTheme(
                    data: SfRangeSliderThemeData(
                        brightness: themeData.brightness,
                        labelOffset: const Offset(0, 2),
                        thumbColor: Colors.white,
                        overlayColor: const Color.fromRGBO(0, 178, 206, 0.24),
                        activeTrackColor: const Color.fromRGBO(0, 178, 206, 1),
                        inactiveTrackColor:
                            const Color.fromRGBO(194, 194, 194, 1),
                        activeLabelStyle: TextStyle(
                            fontSize: 12,
                            color: themeData.textTheme.bodyText1.color
                                .withOpacity(0.87)),
                        inactiveLabelStyle: TextStyle(
                            fontSize: 12,
                            color: themeData.textTheme.bodyText1.color
                                .withOpacity(0.87)),
                        inactiveRegionColor: Colors.transparent),
                    child: SfRangeSelector(
                      min: min,
                      max: max,
                      dateIntervalType: DateIntervalType.days,
                      interval: 5,
                      controller: rangeController,
                      thumbShape: _ThumbShape(),
                      dateFormat: DateFormat.MMMd(),
                      showTicks: true,
                      showLabels: true,
                      onChanged: (SfRangeValues values) {
                        _setTotalDataUsage(values);
                      },
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SfCartesianChart(
                              title:
                                  ChartTitle(text: 'Data usage for April 2019'),
                              margin: const EdgeInsets.all(0),
                              primaryXAxis: DateTimeAxis(
                                  isVisible: false,
                                  minimum: DateTime(2019, 04, 01),
                                  maximum: DateTime(2019, 04, 30, 24)),
                              primaryYAxis:
                                  NumericAxis(isVisible: false, maximum: 26),
                              plotAreaBorderWidth: 0,
                              plotAreaBackgroundColor: Colors.transparent,
                              series: <CartesianSeries<ChartData, DateTime>>[
                                ColumnSeries<ChartData, DateTime>(
                                  width: 0.8,
                                  initialSelectedDataIndexes: selectedItems,
                                  selectionSettings: SelectionSettings(
                                      enable: true,
                                      unselectedOpacity: 0,
                                      selectedBorderColor:
                                          const Color.fromRGBO(0, 178, 206, 1),
                                      selectedColor:
                                          const Color.fromRGBO(0, 178, 206, 1),
                                      unselectedColor: Colors.transparent,
                                      selectionController: rangeController),
                                  dashArray: kIsWeb ? null : <double>[3, 2],
                                  color: const Color.fromRGBO(255, 255, 255, 0),
                                  borderColor:
                                      const Color.fromRGBO(194, 194, 194, 1),
                                  animationDuration: 0,
                                  borderWidth: 1,
                                  dataSource: data,
                                  xValueMapper: (ChartData score, _) =>
                                      score.date,
                                  yValueMapper: (ChartData score, _) =>
                                      score.runs,
                                )
                              ],
                            ),
                          ),
                          width: mediaQueryData.orientation ==
                                  Orientation.landscape
                              ? kIsWeb
                                  ? mediaQueryData.size.width * 0.5
                                  : mediaQueryData.size.width
                              : mediaQueryData.size.width,
                          height: mediaQueryData.size.height * 0.55 - 25),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                    height: mediaQueryData.size.height,
                    padding: EdgeInsets.only(
                        top: (mediaQueryData.size.height -
                                (kIsWeb ? 150 : 120)) *
                            0.8),
                    child: SizedBox(
                        width: 250,
                        height: 20,
                        child: TextField(
                          controller: textController,
                          enabled: false,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(border: InputBorder.none),
                        ))),
              )
            ],
          )),
    );
  }
}

class ChartData {
  ChartData(this.date, this.runs);
  final DateTime date;
  final num runs;
}

class _ThumbShape extends SfThumbShape {
  @override
  void paint(PaintingContext context, Offset center,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      TextDirection textDirection,
      SfThumb thumb}) {
    super.paint(context, center,
        isEnabled: isEnabled,
        parentBox: parentBox,
        themeData: themeData,
        animation: animation,
        textDirection: textDirection,
        thumb: thumb);
    context.canvas.drawCircle(
        center,
        getPreferredSize(themeData, isEnabled).width / 2,
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..color = const Color.fromRGBO(0, 178, 206, 1));
  }
}
