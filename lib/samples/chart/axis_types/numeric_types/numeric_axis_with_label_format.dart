import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//ignore: must_be_immutable
class NumericLabel extends StatefulWidget {
  NumericLabel({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _NumericLabelState createState() => _NumericLabelState(sample);
}

class _NumericLabelState extends State<NumericLabel> {
  _NumericLabelState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getLabelNumericAxisChart(false), sample);
  }
}

SfCartesianChart getLabelNumericAxisChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Farenheit - Celsius conversion'),
    primaryXAxis: NumericAxis(
        labelFormat: '{value}°C',
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}°F',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getNumericLabelSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        canShowMarker: false,
        format: 'point.x / point.y'),
  );
}

List<LineSeries<ChartSampleData, num>> getNumericLabelSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(xValue: 0, yValue: 32),
    ChartSampleData(xValue: 5, yValue: 41),
    ChartSampleData(xValue: 10, yValue: 50),
    ChartSampleData(xValue: 15, yValue: 59),
    ChartSampleData(xValue: 20, yValue: 68),
    ChartSampleData(xValue: 25, yValue: 77),
    ChartSampleData(xValue: 30, yValue: 86),
    ChartSampleData(xValue: 35, yValue: 95),
    ChartSampleData(xValue: 40, yValue: 104),
    ChartSampleData(xValue: 45, yValue: 113),
    ChartSampleData(xValue: 50, yValue: 122)
  ];
  return <LineSeries<ChartSampleData, num>>[
    LineSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.xValue,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        width: 2,
        markerSettings: MarkerSettings(height: 10, width: 10, isVisible: true)),
  ];
}
