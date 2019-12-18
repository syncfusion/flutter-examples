import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class AreaGradient extends StatefulWidget {
  AreaGradient({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _AreaGradientState createState() => _AreaGradientState(sample);
}

class _AreaGradientState extends State<AreaGradient> {
  _AreaGradientState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getGradientAreaChart(false), sample);
  }
}

SfCartesianChart getGradientAreaChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Annual rainfall of Paris'),
    primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
        majorGridLines: MajorGridLines(width: 0),
        title: AxisTitle(text: 'Year')),
    primaryYAxis: NumericAxis(
        minimum: 200,
        maximum: 600,
        interval: 100,
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}mm',
        majorTickLines: MajorTickLines(size: 0)),
    series: getGradientAreaSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<AreaSeries<ChartSampleData, DateTime>> getGradientAreaSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(1924), y: 400),
    ChartSampleData(x: DateTime(1925), y: 415),
    ChartSampleData(x: DateTime(1926), y: 408),
    ChartSampleData(x: DateTime(1927), y: 415),
    ChartSampleData(x: DateTime(1928), y: 350),
    ChartSampleData(x: DateTime(1929), y: 375),
    ChartSampleData(x: DateTime(1930), y: 500),
    ChartSampleData(x: DateTime(1931), y: 390),
    ChartSampleData(x: DateTime(1932), y: 450),
    ChartSampleData(x: DateTime(1933), y: 440),
    ChartSampleData(x: DateTime(1934), y: 350),
    ChartSampleData(x: DateTime(1935), y: 400),
    ChartSampleData(x: DateTime(1936), y: 365),
    ChartSampleData(x: DateTime(1937), y: 490),
    ChartSampleData(x: DateTime(1938), y: 400),
    ChartSampleData(x: DateTime(1939), y: 520),
    ChartSampleData(x: DateTime(1940), y: 510),
    ChartSampleData(x: DateTime(1941), y: 395),
    ChartSampleData(x: DateTime(1942), y: 380),
    ChartSampleData(x: DateTime(1943), y: 404),
    ChartSampleData(x: DateTime(1944), y: 400),
    ChartSampleData(x: DateTime(1945), y: 500)
  ];
  final List<Color> color = <Color>[];
  color.add(Colors.blue[50]);
  color.add(Colors.blue[200]);
  color.add(Colors.blue);

  final List<double> stops = <double>[];
  stops.add(0.0);
  stops.add(0.5);
  stops.add(1.0);

  final LinearGradient gradientColors =
      LinearGradient(colors: color, stops: stops);
  return <AreaSeries<ChartSampleData, DateTime>>[
    AreaSeries<ChartSampleData, DateTime>(
      enableTooltip: true,
      gradient: gradientColors,
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      name: 'Annual Rainfall',
    )
  ];
}
