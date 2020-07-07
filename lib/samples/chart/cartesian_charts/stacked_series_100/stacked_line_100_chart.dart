import 'package:flutter_examples/model/helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';

//ignore: must_be_immutable
class StackedLine100Chart extends StatefulWidget {
  StackedLine100Chart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StackedLineChartState createState() => _StackedLineChartState(sample);
}

class _StackedLineChartState extends State<StackedLine100Chart> {
  _StackedLineChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getStackedLine100Chart(false), sample);
  }
}

SfCartesianChart getStackedLine100Chart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Monthly expense of a family'),
    legend: Legend(isVisible: !isTileView),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
      labelRotation: isTileView ? 0 : -45,
    ),
    primaryYAxis: NumericAxis(
        rangePadding: ChartRangePadding.none,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: _getStackedLine100Series(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ChartSeries<_ChartData, String>> _getStackedLine100Series(
    bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData('Food', 55, 40, 45, 48),
    _ChartData('Transport', 33, 45, 54, 28),
    _ChartData('Medical', 43, 23, 20, 34),
    _ChartData('Clothes', 32, 54, 23, 54),
    _ChartData('Books', 56, 18, 43, 55),
    _ChartData('Others', 23, 54, 33, 56),
  ];
  return <ChartSeries<_ChartData, String>>[
    StackedLine100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.father,
        name: 'Father',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLine100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.mother,
        name: 'Mother',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLine100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.son,
        name: 'Son',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLine100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.daughter,
        name: 'Daughter',
        markerSettings: MarkerSettings(isVisible: true))
  ];
}

class _ChartData {
  _ChartData(this.x, this.father, this.mother, this.son, this.daughter);
  final String x;
  final num father;
  final num mother;
  final num son;
  final num daughter;
}
