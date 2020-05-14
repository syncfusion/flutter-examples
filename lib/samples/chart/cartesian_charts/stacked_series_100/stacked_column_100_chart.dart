import 'package:flutter_examples/model/helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';

//ignore: must_be_immutable
class StackedColumn100Chart extends StatefulWidget {
  StackedColumn100Chart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StackedColumn100ChartState createState() =>
      _StackedColumn100ChartState(sample);
}

class _StackedColumn100ChartState extends State<StackedColumn100Chart> {
  _StackedColumn100ChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getStackedColumn100Chart(false), sample);
  }
}

SfCartesianChart getStackedColumn100Chart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title:
        ChartTitle(text: isTileView ? '' : 'Quarterly wise sales of products'),
    legend: Legend(
        isVisible: !isTileView, overflowMode: LegendItemOverflowMode.wrap),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        rangePadding: ChartRangePadding.none,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: _getStackedColumnSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ChartSeries<_ChartData, String>> _getStackedColumnSeries(bool isTileView) {
  final List<_ChartData> chartData = <_ChartData>[
    _ChartData('Q1', 50, 55, 72, 65),
    _ChartData('Q2', 80, 75, 70, 60),
    _ChartData('Q3', 35, 45, 55, 52),
    _ChartData('Q4', 65, 50, 70, 65),
  ];
  return <ChartSeries<_ChartData, String>>[
    StackedColumn100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        dataLabelSettings: DataLabelSettings(isVisible: true),
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y1,
        name: 'Product A'),
    StackedColumn100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        dataLabelSettings: DataLabelSettings(isVisible: true),
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y2,
        name: 'Product B'),
    StackedColumn100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        dataLabelSettings: DataLabelSettings(isVisible: true),
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y3,
        name: 'Product C'),
    StackedColumn100Series<_ChartData, String>(
        enableTooltip: true,
        dataSource: chartData,
        dataLabelSettings: DataLabelSettings(isVisible: true),
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y4,
        name: 'Product D')
  ];
}

class _ChartData {
  _ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
  final String x;
  final num y1;
  final num y2;
  final num y3;
  final num y4;
}
