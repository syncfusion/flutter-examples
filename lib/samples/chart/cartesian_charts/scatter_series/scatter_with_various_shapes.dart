import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class ScatterShapes extends StatefulWidget {
  ScatterShapes({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _ScatterShapesState createState() => _ScatterShapesState(sample);
}

class _ScatterShapesState extends State<ScatterShapes> {
  _ScatterShapesState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getShapesScatterChart(false), sample);
  }
}

SfCartesianChart getShapesScatterChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Inflation Analysis'),
    primaryXAxis: NumericAxis(
      minimum: 1945,
      maximum: 2005,
      // interval: 5,
      title: AxisTitle(text: isTileView ? '' : 'Year'),
      labelIntersectAction: AxisLabelIntersectAction.multipleRows,
      majorGridLines: MajorGridLines(width: 0),
    ),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Inflation Rate(%)'),
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
    series: getScatterShapesSeries(isTileView),
  );
}

List<ScatterSeries<ChartSampleData, num>> getScatterShapesSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 1950, y: 0.8, yValue2: 1.4, yValue3: 2),
    ChartSampleData(x: 1955, y: 1.2, yValue2: 1.7, yValue3: 2.4),
    ChartSampleData(x: 1960, y: 0.9, yValue2: 1.5, yValue3: 2.2),
    ChartSampleData(x: 1965, y: 1, yValue2: 1.6, yValue3: 2.5),
    ChartSampleData(x: 1970, y: 0.8, yValue2: 1.4, yValue3: 2.2),
    ChartSampleData(x: 1975, y: 1, yValue2: 1.8, yValue3: 2.4),
    ChartSampleData(x: 1980, y: 1, yValue2: 1.7, yValue3: 2),
    ChartSampleData(x: 1985, y: 1.2, yValue2: 1.9, yValue3: 2.3),
    ChartSampleData(x: 1990, y: 1.1, yValue2: 1.4, yValue3: 2),
    ChartSampleData(x: 1995, y: 1.2, yValue2: 1.8, yValue3: 2.2),
    ChartSampleData(x: 2000, y: 1.4, yValue2: 2, yValue3: 2.4),
  ];
  return <ScatterSeries<ChartSampleData, num>>[
    ScatterSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        markerSettings: MarkerSettings(
            width: 15, height: 15, shape: DataMarkerType.diamond),
        name: 'India'),
    ScatterSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        markerSettings: MarkerSettings(
            width: 15, height: 15, shape: DataMarkerType.triangle),
        name: 'China'),
    ScatterSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        markerSettings: MarkerSettings(
            width: 15, height: 15, shape: DataMarkerType.pentagon),
        name: 'Japan')
  ];
}
