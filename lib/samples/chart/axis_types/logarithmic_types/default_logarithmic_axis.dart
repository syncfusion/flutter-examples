import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//ignore: must_be_immutable
class LogarithmicAxisDefault extends StatefulWidget {
  LogarithmicAxisDefault({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _LogarithmicAxisDefaultState createState() =>
      _LogarithmicAxisDefaultState(sample);
}

class _LogarithmicAxisDefaultState extends State<LogarithmicAxisDefault> {
  _LogarithmicAxisDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultLogarithmicAxisChart(false), sample);
  }
}

SfCartesianChart getDefaultLogarithmicAxisChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 1,
    title:
        ChartTitle(text: isTileView ? '' : 'Growth of a product [1995-2005]'),
    primaryXAxis: DateTimeAxis(),
    primaryYAxis: LogarithmicAxis(
        minorTicksPerInterval: 5,
        majorGridLines: MajorGridLines(width: 1.5),
        minorTickLines: MinorTickLines(size: 4),
        labelFormat: '\${value}',
        interval: 1),
    series: _getSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<LineSeries<ChartSampleData, DateTime>> _getSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(1996, 1, 1), yValue: 200),
    ChartSampleData(x: DateTime(1997, 1, 1), yValue: 400),
    ChartSampleData(x: DateTime(1998, 1, 1), yValue: 600),
    ChartSampleData(x: DateTime(1999, 1, 1), yValue: 700),
    ChartSampleData(x: DateTime(2000, 1, 1), yValue: 1400),
    ChartSampleData(x: DateTime(2001, 1, 1), yValue: 2000),
    ChartSampleData(x: DateTime(2002, 1, 1), yValue: 4000),
    ChartSampleData(x: DateTime(2003, 1, 1), yValue: 6000),
    ChartSampleData(x: DateTime(2004, 1, 1), yValue: 8000),
    ChartSampleData(x: DateTime(2005, 1, 1), yValue: 11000)
  ];
  return <LineSeries<ChartSampleData, DateTime>>[
    LineSeries<ChartSampleData, DateTime>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        markerSettings: MarkerSettings(isVisible: true))
  ];
}
