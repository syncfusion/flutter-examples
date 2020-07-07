import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// ignore: must_be_immutable
class DefaultRangeSelectorPage extends StatefulWidget {
  DefaultRangeSelectorPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DefaultRangeSelectorPageState createState() =>
      _DefaultRangeSelectorPageState(sample);
}

class _DefaultRangeSelectorPageState extends State<DefaultRangeSelectorPage> {
  _DefaultRangeSelectorPageState(this.sample);

  final SubItem sample;
  final DateTime min = DateTime(2002, 01, 01), max = DateTime(2011, 01, 01);
  List<Data> chartData;
  RangeController rangeController;
  LinearGradient gradientColors;

  @override
  void initState() {
    super.initState();
    chartData = <Data>[
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
    rangeController = RangeController(
      start: DateTime(2005, 01, 01),
      end: DateTime(2008, 01, 01),
    );
    gradientColors = const LinearGradient(colors: <Color>[
      Color.fromRGBO(255, 125, 30, 0.4),
      Color.fromRGBO(255, 125, 30, 1)
    ], stops: <double>[
      0.0,
      0.5
    ]);
  }

  double _getAverageInflationRate(RangeController values) {
    double totalData = 0;
    int dataCount = 0;
    double startRate = 1.6;
    for (int i = 0; i < chartData.length; i++) {
      //ignore: avoid_as
      if (chartData[i].x.year == (values.start as DateTime).year) {
        startRate = chartData[i].y;
      }
      if (chartData[i].x.isAfter(
              //ignore: avoid_as
              (values.start as DateTime).subtract(const Duration(hours: 12))) &&
          chartData[i].x.isBefore(
              //ignore: avoid_as
              (values.end as DateTime).add(const Duration(hours: 12)))) {
        dataCount++;
        totalData += chartData[i].y;
      }
    }
    return totalData = dataCount != 0 ? totalData / dataCount : startRate;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final SfRangeSliderThemeData sliderThemeData = SfRangeSelectorTheme.of(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  mediaQueryData.orientation == Orientation.portrait
                      ? 50
                      : kIsWeb ? 15 : 2,
                  0,
                  5),
              child: const SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    'Inflation rate in percentage',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: SfRangeSelectorTheme(
                  data: SfRangeSliderThemeData(
                      brightness: themeData.brightness,
                      labelOffset: const Offset(0, 0),
                      activeLabelStyle: kIsWeb
                          ? sliderThemeData.activeLabelStyle
                          : TextStyle(
                          fontSize: 10,
                          color: themeData.textTheme.bodyText1.color
                              .withOpacity(0.87)),
                      inactiveLabelStyle: kIsWeb
                          ? sliderThemeData.inactiveLabelStyle
                          : TextStyle(
                          fontSize: 10,
                          color: themeData.textTheme.bodyText1.color
                              .withOpacity(0.87))),
                  child: SfRangeSelector(
                    min: min,
                    max: max,
                    labelPlacement: LabelPlacement.betweenTicks,
                    interval: (kIsWeb && mediaQueryData.size.width <= 1000) ? 2 : 1,
                    controller: rangeController,
                    dateFormat: DateFormat.y(),
                    showTicks: true,
                    showLabels: true,
                    showTooltip: true,
                    tooltipTextFormatterCallback:
                        (dynamic actualLabel, String formattedText) {
                      return DateFormat.yMMMd().format(actualLabel).toString();
                    },
                    onChanged: (SfRangeValues values) {
                      setState(() {});
                    },
                    child: Container(
                      child: SfCartesianChart(
                        margin: const EdgeInsets.all(0),
                        primaryXAxis: DateTimeAxis(
                          minimum: min,
                          maximum: max,
                          isVisible: false,
                        ),
                        primaryYAxis: NumericAxis(isVisible: false, maximum: 4),
                        plotAreaBorderWidth: 0,
                        series: <SplineAreaSeries<Data, DateTime>>[
                          SplineAreaSeries<Data, DateTime>(
                              dataSource: chartData,
                              xValueMapper: (Data sales, _) => sales.x,
                              yValueMapper: (Data sales, _) => sales.y,
                              gradient: gradientColors,
                              animationDuration: 0)
                        ],
                      ),
                      width: mediaQueryData.orientation == Orientation.landscape
                          ? kIsWeb
                              ? mediaQueryData.size.width * 0.6
                              : mediaQueryData.size.width
                          : mediaQueryData.size.width,
                      height: mediaQueryData.orientation == Orientation.portrait
                          ? mediaQueryData.size.height * 0.45
                          : kIsWeb
                              ? mediaQueryData.size.height * 0.38
                              : mediaQueryData.size.height * 0.4,
                    ),
                  ),
                ),
              ),
            ),
            Center(
                child: Container(
                    height: mediaQueryData.size.height,
                    padding: EdgeInsets.only(
                        top: (mediaQueryData.size.height -
                                (kIsWeb ? 150 : 100)) *
                            0.8),
                    child: SizedBox(
                        height: 15,
                        child: Text(
                          'Average rate   :   ' +
                              _getAverageInflationRate(rangeController)
                                  .toStringAsFixed(2) +
                              '%',
                          style: const TextStyle(fontSize: 18),
                        ))))
          ],
        ));
  }
}

class Data {
  Data({this.x, this.y});
  final DateTime x;
  final double y;
}
