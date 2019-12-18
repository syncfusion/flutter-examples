import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class NumericOpposed extends StatefulWidget {
  NumericOpposed({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _NumericOpposedState createState() => _NumericOpposedState(sample);
}

class _NumericOpposedState extends State<NumericOpposed> {
  _NumericOpposedState(this.sample);

  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.statista.com/statistics/199983/us-vehicle-sales-since-1951/';
    const String source = 'www.statista.com';
    return getScopedModel(
        getOpposedNumericAxisChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getOpposedNumericAxisChart(bool isTileView) {
  return SfCartesianChart(
    title:
        ChartTitle(text: isTileView ? '' : 'Light vehicle retail sales in US'),
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(
        minimum: 1974,
        maximum: 2022,
        majorGridLines: MajorGridLines(width: 0),
        opposedPosition: true,
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Sales in thousands'),
        opposedPosition: true,
        numberFormat: NumberFormat.decimalPattern(),
        minimum: 8000,
        interval: 2000,
        maximum: 20000,
        majorTickLines: MajorTickLines(size: 0)),
    series: getOpposedNumericAxisSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ColumnSeries<ChartSampleData, num>> getOpposedNumericAxisSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 1978, y: 14981),
    ChartSampleData(x: 1983, y: 12107.1),
    ChartSampleData(x: 1988, y: 15443.2),
    ChartSampleData(x: 1993, y: 13882.7),
    ChartSampleData(x: 1998, y: 15543),
    ChartSampleData(x: 2003, y: 16639.1),
    ChartSampleData(x: 2008, y: 13198.8),
    ChartSampleData(x: 2013, y: 15530.1),
    ChartSampleData(x: 2018, y: 17213.5),
  ];
  return <ColumnSeries<ChartSampleData, num>>[
    ColumnSeries<ChartSampleData, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    )
  ];
}
