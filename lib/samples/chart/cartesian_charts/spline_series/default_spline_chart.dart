import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class SplineDefault extends StatefulWidget {
  SplineDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _SplineDefaultState createState() => _SplineDefaultState(sample);
}

class _SplineDefaultState extends State<SplineDefault> {
  _SplineDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.holiday-weather.com/london/averages/';
    const String source = 'www.holiday-weather.com';
    return getScopedModel(
        getDefaultSplineChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getDefaultSplineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView ? '' : 'Average high/low temperature of London'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks),
    primaryYAxis: NumericAxis(
        minimum: 30,
        maximum: 80,
        axisLine: AxisLine(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelFormat: '{value}°F',
        majorTickLines: MajorTickLines(size: 0)),
    series: getDefaultSplineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<SplineSeries<ChartSampleData, String>> getDefaultSplineSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Jan', y: 43, yValue2: 37, yValue3: 41),
    ChartSampleData(x: 'Feb', y: 45, yValue2: 37, yValue3: 45),
    ChartSampleData(x: 'Mar', y: 50, yValue2: 39, yValue3: 48),
    ChartSampleData(x: 'Apr', y: 55, yValue2: 43, yValue3: 52),
    ChartSampleData(x: 'May', y: 63, yValue2: 48, yValue3: 57),
    ChartSampleData(x: 'Jun', y: 68, yValue2: 54, yValue3: 61),
    ChartSampleData(x: 'Jul', y: 72, yValue2: 57, yValue3: 66),
    ChartSampleData(x: 'Aug', y: 70, yValue2: 57, yValue3: 66),
    ChartSampleData(x: 'Sep', y: 66, yValue2: 54, yValue3: 63),
    ChartSampleData(x: 'Oct', y: 57, yValue2: 48, yValue3: 55),
    ChartSampleData(x: 'Nov', y: 50, yValue2: 43, yValue3: 50),
    ChartSampleData(x: 'Dec', y: 45, yValue2: 37, yValue3: 45)
  ];
  return <SplineSeries<ChartSampleData, String>>[
    SplineSeries<ChartSampleData, String>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      markerSettings: MarkerSettings(isVisible: true),
      name: 'High',
    ),
    SplineSeries<ChartSampleData, String>(
      enableTooltip: true,
      dataSource: chartData,
      name: 'Low',
      markerSettings: MarkerSettings(isVisible: true),
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
    )
  ];
}
