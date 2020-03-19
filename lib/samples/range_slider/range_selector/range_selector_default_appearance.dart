import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_examples/model/model.dart';

// ignore: must_be_immutable
class RangeSelectorDefaultAppearance extends StatefulWidget {
  RangeSelectorDefaultAppearance({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSelectorDefaultAppearanceState createState() =>
      _RangeSelectorDefaultAppearanceState(sample);
}

class _RangeSelectorDefaultAppearanceState
    extends State<RangeSelectorDefaultAppearance>
    with SingleTickerProviderStateMixin {
  _RangeSelectorDefaultAppearanceState(this.sample);

  double rate = 2.325;
  final SubItem sample;
  final List<Data> chartData = <Data>[
    Data(x: DateTime(2002, 01, 01), y: 2.2),
    Data(x: DateTime(2003, 01, 01), y: 3.4),
    Data(x: DateTime(2004, 01, 01), y: 2.8),
    Data(x: DateTime(2005, 01, 01), y: 1.6),
    Data(x: DateTime(2006, 01, 01), y: 2.3),
    Data(x: DateTime(2007, 01, 01), y: 2.5),
    Data(x: DateTime(2008, 01, 01), y: 2.9),
    Data(x: DateTime(2009, 01, 01), y: 3.8),
    Data(x: DateTime(2010, 01, 01), y: 1.4),
    Data(x: DateTime(2011, 01, 01), y: 3.1),
  ];
  DateTime dateTimeMin = DateTime(2002, 01, 01),
      dateTimeMax = DateTime(2011, 01, 01);
  final SfRangeValues _dateTimeValues =
      SfRangeValues(DateTime(2005, 01, 01), DateTime(2008, 01, 01));
  RangeController _dateTimeController;
  LinearGradient gradientColors;
  @override
  void initState() {
    _dateTimeController = RangeController(
      start: DateTime(2005, 01, 01),
      end: DateTime(2008, 01, 01),
    );
    final List<Color> color = <Color>[];
    color.add(const Color.fromRGBO(255, 125, 30, 0.4));
    color.add(const Color.fromRGBO(255, 125, 30, 1));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    gradientColors = LinearGradient(colors: color, stops: stops);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final dynamic device = MediaQuery.of(context);
    return Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).orientation==Orientation.portrait ? 50:2, 0, 5),
              child: SizedBox(
                height: MediaQuery.of(context).orientation==Orientation.portrait?30:30,
                child: const Center(
                  child: Text(
                    'Inflation Rate in percentage',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: Center(
                child: SfRangeSelectorTheme(
                  data: SfRangeSliderThemeData(
                      brightness: Theme.of(context).brightness,
                      labelOffset: const Offset(0, 0),
                      activeLabelStyle: TextStyle(
                          fontSize: 10,
                          color: themeData.textTheme.body2.color.withOpacity(0.87)),
                      inactiveLabelStyle: TextStyle(
                          fontSize: 10,
                          color: themeData.textTheme.body2.color
                              .withOpacity(0.87))),
                  child: SfRangeSelector(
                    min: dateTimeMin,
                    max: dateTimeMax,
                    initialValues: _dateTimeValues,
                    labelPlacement: LabelPlacement.betweenTicks,
                    interval: 1,
                    controller: _dateTimeController,
                    dateFormat: DateFormat.y(),
                    showTicks: true,
                    showLabels: true,
                    showTooltip: true,
                    tooltipTextFormatterCallback: (dynamic actual, String formatted){
                      return DateFormat.yMMMd().format(actual).toString();
                    },
                    onChanged: (SfRangeValues values) {
                      rate = 0;
                      int count = 0;
                      double startRate = 1.6;
                      for(int i = 0;i < chartData.length; i++)
                          {
                            //ignore: avoid_as
                            if(chartData[i].x.year == (values.start as DateTime).year)
                              startRate = chartData[i].y;
                            //ignore: avoid_as
                            if(chartData[i].x.isAfter((values.start as DateTime).subtract(const Duration(hours: 12))) && chartData[i].x.isBefore((values.end as DateTime).add(const Duration(hours: 12))))
                            {
                              count++;
                              rate+= chartData[i].y;
                            }
                          }
                           setState(() {
                             rate= count != 0 ? rate/count : startRate;
                           });
                    },
                    child: Container(
                      child: SfCartesianChart(
                        margin: const EdgeInsets.all(0),
                        primaryXAxis: DateTimeAxis(minimum: dateTimeMin,maximum: dateTimeMax,isVisible: false,),
                        primaryYAxis: NumericAxis(isVisible: false , maximum: 4),
                        plotAreaBorderWidth: 0,
                        series: <SplineAreaSeries<Data, DateTime>>[
                          SplineAreaSeries<Data, DateTime>(
                              dataSource: chartData,
                              xValueMapper: (Data sales, _) => sales.x,
                              yValueMapper: (Data sales, _) => sales.y,
                              gradient: gradientColors)
                        ],
                      ),
                      height: device.orientation == Orientation.portrait ? device.size.height * 0.45 : device.size.height * 0.4,
                    ),
                  ),
                ),
              ),
            ),
            Center(child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height -120 )*0.8),child: SizedBox(height: 15,child: Text('Average rate   :   ' + rate.toStringAsFixed(2) + '%',style: const TextStyle(fontSize: 18),))))
          ],
        ));
  }
}

class Data {
  Data({this.x, this.y});
  final DateTime x;
  final double y;
}
