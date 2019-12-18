import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class StackedLineChart extends StatefulWidget {
  StackedLineChart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StackedLineChartState createState() => _StackedLineChartState(sample);
}

class _StackedLineChartState extends State<StackedLineChart> {
  _StackedLineChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getStackedLineChart(false), sample);
  }
}

SfCartesianChart getStackedLineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Monthly expense of a family'),
    legend: Legend(isVisible: !isTileView),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
      labelRotation: isTileView ? 0 : 45,
    ),
    primaryYAxis: NumericAxis(
        maximum: 200,
        axisLine: AxisLine(width: 0),
        labelFormat: '\${value}',
        majorTickLines: MajorTickLines(size: 0)),
    series: getStackedLineSeries(isTileView),
    trackballBehavior: TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap),
    tooltipBehavior:
        TooltipBehavior(enable: false, header: '', canShowMarker: false),
  );
}

List<StackedLineSeries<ChartSampleData, String>> getStackedLineSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Food', y: 55, yValue: 40, yValue2: 45, yValue3: 48),
    ChartSampleData(
        x: 'Transport', y: 33, yValue: 45, yValue2: 54, yValue3: 28),
    ChartSampleData(x: 'Medical', y: 43, yValue: 23, yValue2: 20, yValue3: 34),
    ChartSampleData(x: 'Clothes', y: 32, yValue: 54, yValue2: 23, yValue3: 54),
    ChartSampleData(x: 'Books', y: 56, yValue: 18, yValue2: 43, yValue3: 55),
    ChartSampleData(x: 'Others', y: 23, yValue: 54, yValue2: 33, yValue3: 56),
  ];
  return <StackedLineSeries<ChartSampleData, String>>[
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Father',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Mother',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Son',
        markerSettings: MarkerSettings(isVisible: true)),
    StackedLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Daughter',
        markerSettings: MarkerSettings(isVisible: true))
  ];
}
