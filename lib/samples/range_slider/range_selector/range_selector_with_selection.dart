import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_examples/model/model.dart';

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

  static List<ChartData> data = <ChartData>[
    ChartData(DateTime(2019, 04, 01), 2 / 10),
    ChartData(DateTime(2019, 04, 02), 3 / 10),
    ChartData(DateTime(2019, 04, 03), 4 / 10),
    ChartData(DateTime(2019, 04, 04), 6 / 10),
    ChartData(DateTime(2019, 04, 05), 8 / 10),
    ChartData(DateTime(2019, 04, 06), 12 / 10),
    ChartData(DateTime(2019, 04, 07), 16 / 10),
    ChartData(DateTime(2019, 04, 08), 24 / 10),
    ChartData(DateTime(2019, 04, 09), 32 / 10),
    ChartData(DateTime(2019, 04, 10), 48 / 10),
    ChartData(DateTime(2019, 04, 11), 64 / 10),
    ChartData(DateTime(2019, 04, 12), 96 / 10),
    ChartData(DateTime(2019, 04, 13), 128 / 10),
    ChartData(DateTime(2019, 04, 14), 160 / 10),
    ChartData(DateTime(2019, 04, 15), 220 / 10),
    ChartData(DateTime(2019, 04, 16), 256 / 10),
    ChartData(DateTime(2019, 04, 17), 200 / 10),
    ChartData(DateTime(2019, 04, 18), 145 / 10),
    ChartData(DateTime(2019, 04, 19), 128 / 10),
    ChartData(DateTime(2019, 04, 20), 100 / 10),
    ChartData(DateTime(2019, 04, 21), 66 / 10),
    ChartData(DateTime(2019, 04, 22), 50 / 10),
    ChartData(DateTime(2019, 04, 23), 32 / 10),
    ChartData(DateTime(2019, 04, 24), 32 / 10),
    ChartData(DateTime(2019, 04, 25), 16 / 10),
    ChartData(DateTime(2019, 04, 26), 16 / 10),
    ChartData(DateTime(2019, 04, 27), 8 / 10),
    ChartData(DateTime(2019, 04, 28), 8 / 10),
    ChartData(DateTime(2019, 04, 29), 4 / 10),
    ChartData(DateTime(2019, 04, 30), 0.2)
  ];
  DateTime dateTimeMin = DateTime(2019, 04, 01),
      dateTimeMax = DateTime(2019, 04, 30, 24);
  final SfRangeValues _dateTimeValues =
      SfRangeValues(DateTime(2019, 04, 6), DateTime(2019, 04, 15));
  RangeController _dateTimeController;
  TextEditingController textController;
  List<int> selectedItems;
  SfCartesianChart chart;

  @override
  void initState() {
    textController = TextEditingController(text: 'Total Data Usage : 80GB');
    _dateTimeController = RangeController(
      start: DateTime(2019, 04, 6),
      end: DateTime(2019, 04, 15),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double usage = 0;
    selectedItems = <int>[];
    for (int i = 0; i < data.length; i++) {
      if (data[i].date.millisecondsSinceEpoch >=
              _dateTimeController.start.millisecondsSinceEpoch &&
          data[i].date.millisecondsSinceEpoch <=
              _dateTimeController.end.millisecondsSinceEpoch) {
        selectedItems.add(data.indexOf(data[i]));
      }
    }
    final ThemeData themeData = Theme.of(context);
    chart = SfCartesianChart(
      title: ChartTitle(text:'Data Usage for April 2019'),
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
              selectionController: _dateTimeController),
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
                        brightness: Theme.of(context).brightness,
                        labelOffset: const Offset(0, 2),
                        thumbColor: Colors.white,
                        overlayColor: const Color.fromRGBO(0, 178, 206, 0.24),
                        activeTrackColor: const Color.fromRGBO(0, 178, 206, 1),
                        inactiveTrackColor: const Color.fromRGBO(194, 194, 194, 1),
                        activeLabelStyle: TextStyle(
                            fontSize: 12,
                            color: themeData.textTheme.body2.color.withOpacity(0.87)),
                        inactiveLabelStyle: TextStyle(
                            fontSize: 12,
                            color: themeData.textTheme.body2.color.withOpacity(0.87)),
                        inactiveRegionColor: Colors.transparent),
                    child: SfRangeSelector(
                      min: dateTimeMin,
                      max: dateTimeMax,
                      dateIntervalType: DateIntervalType.days,
                      initialValues: _dateTimeValues,
                      interval: 5,
                      controller: _dateTimeController,
                      thumbShape: _ThumbShape(),
                      dateFormat: DateFormat.MMMd(),
                      showTicks: true,
                      showLabels: true,
                      onChanged: (SfRangeValues values) {
                        usage = 0;
                        for(int i = 0;i < data.length; i++)
                        {
                          //ignore: avoid_as
                          if(data[i].date.isAfter((values.start as DateTime).subtract(const Duration(hours: 1))) && data[i].date.isBefore((values.end as DateTime).add(const Duration(hours: 1))))
                          {
                            usage+= data[i].runs;
                          }
                        }
                      textController.text = 'Total Data Usage : ' + usage.toStringAsFixed(1) + 'GB';
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SfCartesianChart(
      title: ChartTitle(text:'Data Usage for April 2019'),
      margin: const EdgeInsets.all(0),
      primaryXAxis: DateTimeAxis(
                isVisible: false,
                minimum: DateTime(2019, 04, 01),
                maximum: DateTime(2019, 04, 30, 24)),
      primaryYAxis: NumericAxis(isVisible: false,maximum: 26),
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
                    selectionController: _dateTimeController),
                dashArray: kIsWeb ? null : <double>[3, 2],
                color: const Color.fromRGBO(255, 255, 255, 0),
                borderColor: const Color.fromRGBO(194, 194, 194, 1),
                animationDuration: 0,
                borderWidth: 1,
                dataSource: data,
                xValueMapper: (ChartData score, _) => score.date,
                yValueMapper: (ChartData score, _) => score.runs,
        )
      ],
    ),
                        ),
                        height: MediaQuery.of(context).size.height * 0.55 - 25 
                      ),
                    ),
                  ),
                ),
              ),
              Center(child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height -120 )*0.8),child: SizedBox(width: 200,height : 20,child: TextField(controller: textController,enabled: false,readOnly: true,textAlign: TextAlign.center,decoration: InputDecoration(border: InputBorder.none), ))),
              )],
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
