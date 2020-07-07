import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//ignore: must_be_immutable
class LogarithmicAxisInversed extends StatefulWidget {
  LogarithmicAxisInversed({this.sample, Key key}) : super(key: key);
  SubItem sample;
  @override
  _LogarithmicAxisInversedState createState() =>
      _LogarithmicAxisInversedState(sample);
}

class _LogarithmicAxisInversedState extends State<LogarithmicAxisInversed> {
  _LogarithmicAxisInversedState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.worldometers.info/world-population/population-by-country/';
    const String source = 'www.worldometers.info';
    return getScopedModel(getInversedLogarithmicAxisChart(false), sample, null,
        sourceLink, source);
  }
}

SfCartesianChart getInversedLogarithmicAxisChart(bool isTileView) {
  dynamic text;
  return SfCartesianChart(
    onTooltipRender: (TooltipArgs args) {
      final NumberFormat format = NumberFormat.decimalPattern();
      text = format.format(args.dataPoints[args.pointIndex].y).toString();
      args.text = text;
    },
    onAxisLabelRender: (AxisLabelRenderArgs args) {
      final NumberFormat format = NumberFormat.decimalPattern();
      if (args.axisName == 'primaryYAxis')
        args.text = format.format(double.parse(args.text)).toString();
    },
    plotAreaBorderWidth: 0,
    title:
        ChartTitle(text: isTileView ? '' : 'Population of various countries'),
    primaryXAxis: CategoryAxis(
      labelIntersectAction: isTileView
          ? AxisLabelIntersectAction.hide
          : AxisLabelIntersectAction.none,
      labelRotation: isTileView ? 0 : -45,
    ),
    primaryYAxis: LogarithmicAxis(
      minorTicksPerInterval: 5,
      majorGridLines: MajorGridLines(width: 1.5),
      minorTickLines: MinorTickLines(size: 4),
      isInversed: true,
      interval: 1,
    ),
    series: _getInversedLogarithmicSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        enable: true, format: 'point.y', header: '', canShowMarker: false),
  );
}

List<ChartSeries<ChartSampleData, String>> _getInversedLogarithmicSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'China', yValue: 1433783686),
    ChartSampleData(x: 'India', yValue: 1366417754),
    ChartSampleData(x: 'US', yValue: 329064917),
    ChartSampleData(x: 'Japan', yValue: 126860301),
    ChartSampleData(x: 'UK', yValue: 67530172),
    ChartSampleData(x: 'Canada', yValue: 37411047),
    ChartSampleData(x: 'Greece', yValue: 10473455),
    ChartSampleData(x: 'Maldives', yValue: 530953),
    ChartSampleData(x: 'Dominica', yValue: 71808),
  ];
  return <ChartSeries<ChartSampleData, String>>[
    StepLineSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        markerSettings: MarkerSettings(
            isVisible: true,
            width: 5,
            height: 5,
            shape: DataMarkerType.rectangle))
  ];
}
