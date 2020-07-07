import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class StackedColumnChart extends StatefulWidget {
  StackedColumnChart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StackedColumnChartState createState() => _StackedColumnChartState(sample);
}

class _StackedColumnChartState extends State<StackedColumnChart> {
  _StackedColumnChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getStackedColumnChart(false), sample);
  }
}

SfCartesianChart getStackedColumnChart(bool isTileView) {
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
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}K',
        maximum: 300,
        majorTickLines: MajorTickLines(size: 0)),
    series: getStackedColumnSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<StackedColumnSeries<ChartSampleData, String>> getStackedColumnSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Q1', y: 50, yValue: 55, yValue2: 72, yValue3: 65),
    ChartSampleData(x: 'Q2', y: 80, yValue: 75, yValue2: 70, yValue3: 60),
    ChartSampleData(x: 'Q3', y: 35, yValue: 45, yValue2: 55, yValue3: 52),
    ChartSampleData(x: 'Q4', y: 65, yValue: 50, yValue2: 70, yValue3: 65),
  ];
  return <StackedColumnSeries<ChartSampleData, String>>[
    StackedColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Product A'),
    StackedColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Product B'),
    StackedColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Product C'),
    StackedColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Product D')
  ];
}
