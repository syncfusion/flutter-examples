import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';

//ignore: must_be_immutable
class AnimationDefault extends StatefulWidget {
  AnimationDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _AnimationDefaultState createState() => _AnimationDefaultState(sample);
}

class _AnimationDefaultState extends State<AnimationDefault> {
  _AnimationDefaultState(this.sample);
  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultAnimationChart(false), sample);
  }
}

SfCartesianChart getDefaultAnimationChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Sales report'),
    legend: Legend(isVisible: isTileView ? false : true),
    plotAreaBorderWidth: 0,
    primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        minimum: 0,
        interval: isTileView ? 50 : 25,
        maximum: 150,
        majorGridLines: MajorGridLines(width: 0)),
    axes: <ChartAxis>[
      NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          opposedPosition: true,
          name: 'yAxis1',
          minimum: 0,
          maximum: 7000)
    ],
    series: getDefaultAnimationSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ChartSeries<ChartSampleData, String>> getDefaultAnimationSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Jan', y: 45, yValue2: 1000),
    ChartSampleData(x: 'Feb', y: 100, yValue2: 3000),
    ChartSampleData(x: 'March', y: 25, yValue2: 1000),
    ChartSampleData(x: 'April', y: 100, yValue2: 7000),
    ChartSampleData(x: 'May', y: 85, yValue2: 5000),
    ChartSampleData(x: 'June', y: 140, yValue2: 7000)
  ];
  return <ChartSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
        animationDuration: 2000,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Unit Sold'),
    LineSeries<ChartSampleData, String>(
        animationDuration: 4500,
        dataSource: chartData,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        yAxisName: 'yAxis1',
        markerSettings: MarkerSettings(isVisible: true),
        name: 'Total Transaction')
  ];
}
