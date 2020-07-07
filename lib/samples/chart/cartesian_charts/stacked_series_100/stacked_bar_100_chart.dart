import 'package:flutter_examples/model/helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';

//ignore: must_be_immutable
class StackedBar100Chart extends StatefulWidget {
  StackedBar100Chart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StackedBar100ChartState createState() => _StackedBar100ChartState(sample);
}

class _StackedBar100ChartState extends State<StackedBar100Chart> {
  _StackedBar100ChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getStackedBar100Chart(false), sample);
  }
}

SfCartesianChart getStackedBar100Chart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 1,
    title: ChartTitle(text: isTileView ? '' : 'Sales comparison of fruits'),
    legend: Legend(isVisible: !isTileView),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        rangePadding: ChartRangePadding.none,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: _getStackedBarSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ChartSeries<_ChartData, String>> _getStackedBarSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData('Jan', 6, 6, 1),
    _ChartData('Feb', 8, 8, 1.5),
    _ChartData('Mar', 12, 11, 2),
    _ChartData('Apr', 15.5, 16, 2.5),
    _ChartData('May', 20, 21, 3),
    _ChartData('June', 24, 25, 3.5),
  ];
  return <ChartSeries<_ChartData, String>>[
    StackedBar100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.apple,
        name: 'Apple'),
    StackedBar100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.orange,
        name: 'Orange'),
    StackedBar100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.wastage,
        name: 'Wastage')
  ];
}

class _ChartData {
  _ChartData(this.x, this.apple, this.orange, this.wastage);
  final String x;
  final num apple;
  final num orange;
  final num wastage;
}
