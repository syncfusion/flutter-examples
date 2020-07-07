/// Dart import
import 'dart:math';

/// Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';



class CustomLabelsEvent extends SampleView {
  const CustomLabelsEvent(Key key) : super(key: key);
  @override
  _CustomLabelsEventState createState() => _CustomLabelsEventState();
}

/// Here we define the chart data source.
List<LabelData> chartData = <LabelData>[
  LabelData(DateTime(2016), 57),
  LabelData(DateTime(2017), 70),
  LabelData(DateTime(2018), 58),
  LabelData(DateTime(2019), 65),
  LabelData(DateTime(2020), 38),
];
List<LabelData> tileViewData = <LabelData>[
  LabelData(DateTime(2016), 57),
  LabelData(DateTime(2017), 70),
  LabelData(DateTime(2018), 58),
  LabelData(DateTime(2019), 65),
  LabelData(DateTime(2020), 38),
];
int count = 5;
dynamic current = DateTime.now();
dynamic currentyear = current.year;
dynamic currentmonth = current.month;
dynamic currentdate = current.day;
dynamic currenthour = current.hour;
dynamic currentmin = current.minute;
dynamic formatter = DateFormat().add_d();
dynamic formatter1 = DateFormat().add_j();
dynamic formatter2 = DateFormat().add_m();
dynamic formatter3 = DateFormat().add_MMM();
dynamic formatter4 = DateFormat().add_y();
DateTimeIntervalType timeinterval = DateTimeIntervalType.years;
DateFormat format = DateFormat.y();
// DateTime max = DateTime(currentyear);
bool _isYear = true;
bool _isMonth = false;
bool _isDay = false;
bool _isHours = false;
bool _isMin = false;


class _CustomLabelsEventState extends SampleViewState {
  _CustomLabelsEventState();
    
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          _isYear = true;
          _isMonth = false;
          _isDay = false;
          _isHours = false;
          _isMin = false;
        });
  final double bottomPadding = isCardView ? 0 : 50;
  return Scaffold(
        backgroundColor: model.cardThemeColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, bottomPadding),
          child: Container(child: getEventLineChart(false, null, chartData)),
        ),
        floatingActionButton: isCardView ? null : _segmentedControl()
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
        //   child: Container(
        //     child: Stack(children: <Widget>[
        //       Align(
        //         alignment: Alignment.bottomCenter,
        //         child: Container(
        //           height: 50,
        //           child: InkWell(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: <Widget>[
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        //                   child: Tooltip(
        //                     message: 'year',
        //                     child: IconButton(
        //                       icon: Text('Y',
        //                           style: TextStyle(
        //                             color: model.backgroundColor,
        //                           )),
        //                       iconSize: 30,
        //                       onPressed: () {
        //                         setState(() {
        //                           chartData = <LabelData>[];
        //                           chartData = getYearData(model);
        //                         });
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        //                   child: Tooltip(
        //                     message: 'months',
        //                     child: IconButton(
        //                       icon: Text('M',
        //                           style: TextStyle(
        //                             color: model.backgroundColor,
        //                           )),
        //                       iconSize: 30,
        //                       onPressed: () {
        //                         setState(() {
        //                           chartData = <LabelData>[];
        //                           chartData = getMonthData(model);
        //                         });
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        //                   child: Tooltip(
        //                     message: 'days',
        //                     child: IconButton(
        //                       icon: Text('D',
        //                           style: TextStyle(
        //                             color: model.backgroundColor,
        //                           )),
        //                       iconSize: 30,
        //                       onPressed: () {
        //                         setState(() {
        //                           chartData = <LabelData>[];
        //                           chartData = getDaysData(model);
        //                         });
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        //                   child: Tooltip(
        //                     message: 'Hours',
        //                     child: IconButton(
        //                       icon: Text('H',
        //                           style: TextStyle(
        //                             color: model.backgroundColor,
        //                           )),
        //                       color: model.backgroundColor,
        //                       iconSize: 30,
        //                       onPressed: () {
        //                         setState(() {
        //                           chartData = <LabelData>[];
        //                           chartData = getHourData(model);
        //                         });
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        //                   child: Tooltip(
        //                     message: 'minutes',
        //                     child: IconButton(
        //                       icon: Text(
        //                         'Min',
        //                         style: TextStyle(
        //                           color: model.backgroundColor,
        //                         ),
        //                       ),
        //                       iconSize: 30,
        //                       onPressed: () {
        //                         setState(() {
        //                           chartData = <LabelData>[];
        //                           chartData = getMinData(model);
        //                         });
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ]),
        //   ),
        // )
        );
  }
  Widget _segmentedControl() => Container(
    width: MediaQuery.of(context).size.width,
    child: Container( 
      foregroundDecoration: const BoxDecoration(shape: BoxShape.circle),
      padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
      child:CupertinoSegmentedControl<int>(
      selectedColor: model.backgroundColor,
      borderColor: Colors.white,
      children: const <int,Widget>{
        0: Text('Y'),
        1: Text('M'),
        2: Text('D'),
        3: Text('H'),
        4: Text('Min'),
      },
      onValueChanged: (int val) {
        setState(() {
          segmentedControlValue = val;
          changeAxisLabel(val);
        });
      },
      groupValue: segmentedControlValue,
    )),
  );
  void changeAxisLabel(int index){
    switch (index) {
      case 0: 
        chartData = <LabelData>[];
        chartData = getYearData(model);
        break;
      case 1:
      chartData = <LabelData>[];
      chartData = getMonthData(model);
        break;
      case 2:
      chartData = <LabelData>[];
      chartData = getDaysData(model);
        break;
      case 3:
      chartData = <LabelData>[];
      chartData = getHourData(model);
        break;
      case 4:
      chartData = <LabelData>[];
      chartData = getMinData(model);
        break;
      default:
      chartData = <LabelData>[];
      chartData = getYearData(model);
    }
  }
  SfCartesianChart getEventLineChart(bool isTileView,
      [SampleModel model, List<LabelData> data]) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      onAxisLabelRender: (AxisLabelRenderArgs args) {
        if (args.axis is DateTimeAxis) {
          if (_isYear && formatter4.format(current).toString() == args.text) {
            args.text = 'Current\nYear';
            args.textStyle = const TextStyle(fontStyle: FontStyle.italic, color: Colors.red);
          }
          if (_isMonth && formatter3.format(current).toString() == args.text) {
            args.text = 'Current\nMonth';
            args.textStyle = const TextStyle(fontStyle: FontStyle.italic, color: Colors.red);
          }
          if (_isDay && formatter.format(current).toString() == args.text) {
            args.text = 'Today';
            args.textStyle = const TextStyle(fontStyle: FontStyle.italic, color: Colors.red);
          }
          if (_isHours && formatter1.format(current).toString() == args.text) {
            args.text = 'Current\nHour';
            args.textStyle = const TextStyle(fontStyle: FontStyle.italic, color: Colors.red);
          }
          if (_isMin && formatter2.format(current).toString() == args.text) {
            args.text = 'Now';
            args.textStyle = const TextStyle(fontStyle: FontStyle.italic, color: Colors.red);
          }
        }
      },
      primaryXAxis: DateTimeAxis(
          interval: 1,
          intervalType: timeinterval,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          dateFormat: format),
      series: getDefaultLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<LabelData, dynamic>> getDefaultLineSeries() {
    return <LineSeries<LabelData, dynamic>>[
      LineSeries<LabelData, dynamic>(
          enableTooltip: true,
          dataSource: isCardView ? tileViewData : chartData,
          xValueMapper: (LabelData sales, _) => sales.x,
          yValueMapper: (LabelData sales, _) => sales.y,
          width: 2,
          markerSettings: MarkerSettings(isVisible: true))
    ];
  }

  final Random random = Random();
  num getRandomInt(num min, num max) {
    return min + random.nextInt(max - min);
  }

  Widget sampleWidget(SampleModel model) =>
      getEventLineChart(true, model, chartData);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCurrentTime(){
    current = DateTime.now();
    currentyear = current.year;
    currentmonth = current.month;
    currentdate = current.day;
    currenthour = current.hour;
    currentmin = current.minute;
  }

  void setTimeVisibility(String time){
    switch (time) {
      case 'year':
        _isYear = true;
        _isMonth = false;
        _isDay = false;
        _isHours = false;
        _isMin = false;
        break;
      case 'month':
        _isYear = false;
        _isMonth = true;
        _isDay = false;
        _isHours = false;
        _isMin = false;
        break;
      case 'day':
        _isYear = false;
        _isMonth = false;
        _isDay = true;
        _isHours = false;
        _isMin = false;
        break;
      case 'hours':
        _isYear = false;
        _isMonth = false;
        _isDay = false;
        _isHours = true;
        _isMin = false;
        break;
      case 'min':
        _isYear = false;
        _isMonth = false;
        _isDay = false;
        _isHours = false;
        _isMin = true;
        break;
    }
  }

  /// It returns the data for year to the chart data source.
  List<LabelData> getYearData(SampleModel model) {
    setTimeVisibility('year');
    getCurrentTime();
    timeinterval = DateTimeIntervalType.years;
    format = DateFormat.y();
    dynamic temp = currentyear;
    for (int itr = count; itr > 0; itr--) {
      chartData.add(LabelData(DateTime(temp), getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return chartData;
  }

  /// It returns the data for month to the chart data source.
  List<LabelData> getMonthData(SampleModel model) {
    setTimeVisibility('month');
    getCurrentTime();
    timeinterval = DateTimeIntervalType.months;
    format = DateFormat.MMM();
    dynamic temp = currentmonth;
    for (int itr = count; itr > 0; itr--) {
      chartData
          .add(LabelData(DateTime(currentyear, temp), getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return chartData;
  }

  /// It returns the data for days to the chart data source.
  List<LabelData> getDaysData(SampleModel model) {
    setTimeVisibility('day');
    getCurrentTime();
    timeinterval = DateTimeIntervalType.days;
    format = DateFormat.d();
    dynamic temp = currentdate;
    for (int itr = count; itr > 0; itr--) {
      chartData.add(LabelData(
          DateTime(currentyear, currentmonth, temp), getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return chartData;
  }

  /// It returns the data for hour to the chart data source.
  List<LabelData> getHourData(SampleModel model) {
    setTimeVisibility('hours');
    getCurrentTime();
    timeinterval = DateTimeIntervalType.hours;
    format = DateFormat.j();
    dynamic temp = currenthour;
    for (int itr = count; itr > 0; itr--) {
      chartData.add(LabelData(
          DateTime(currentyear, currentmonth, currentdate, temp),
          getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return chartData;
  }

  /// It returns the data for minutes to the chart data source.
  List<LabelData> getMinData(SampleModel model) {
    setTimeVisibility('min');
    getCurrentTime();
    timeinterval = DateTimeIntervalType.minutes;
    format = DateFormat.m();
    dynamic temp = currentmin;
    for (int itr = count; itr > 0; itr--) {
      chartData.add(LabelData(
          DateTime(currentyear, currentmonth, currentdate, currenthour, temp),
          getRandomInt(10, 100)));
      temp = temp - 1;
    }
    return chartData;
  }
}

class LabelData {
  LabelData(this.x, this.y);
  final DateTime x;
  final num y;
}
int segmentedControlValue = 0;
