import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class StackedBarChart extends StatefulWidget {
  StackedBarChart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StackedBarChartState createState() => _StackedBarChartState(sample);
}

class _StackedBarChartState extends State<StackedBarChart> {
  _StackedBarChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getStackedBarChart(false), sample);
  }
}

SfCartesianChart getStackedBarChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 1,
    title: ChartTitle(text: isTileView ? '' : 'Sales comparison of fruits'),
    legend: Legend(isVisible: !isTileView),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}%',
        majorTickLines: MajorTickLines(size: 0)),
    series: getStackedBarSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<StackedBarSeries<ChartSampleData, String>> getStackedBarSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Jan', y: 6, yValue: 6, yValue2: -1),
    ChartSampleData(x: 'Feb', y: 8, yValue: 8, yValue2: -1.5),
    ChartSampleData(x: 'Mar', y: 12, yValue: 11, yValue2: -2),
    ChartSampleData(x: 'Apr', y: 15.5, yValue: 16, yValue2: -2.5),
    ChartSampleData(x: 'May', y: 20, yValue: 21, yValue2: -3),
    ChartSampleData(x: 'June', y: 24, yValue: 25, yValue2: -3.5),
  ];
  return <StackedBarSeries<ChartSampleData, String>>[
    StackedBarSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Apple'),
    StackedBarSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Orange'),
    StackedBarSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Wastage')
  ];
}
