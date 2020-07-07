import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

//ignore:must_be_immutable
class DefaultTooltip extends StatefulWidget {
  DefaultTooltip({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DefaultTooltipState createState() => _DefaultTooltipState(sample);
}

class _DefaultTooltipState extends State<DefaultTooltip> {
  _DefaultTooltipState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.indexmundi.com/g/g.aspx?v=72&c=gm&c=mx&l=en';
    const String source = 'www.indexmundi.com';
    return getScopedModel(
        getDefaultTooltipChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getDefaultTooltipChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Labour force'),
    legend: Legend(isVisible: isTileView ? false : true),
    primaryXAxis: NumericAxis(
        minimum: 2004,
        maximum: 2013,
        interval: 1,
        title: AxisTitle(text: isTileView ? '' : 'Year'),
        majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}M',
        minimum: 30,
        maximum: 60,
        axisLine: AxisLine(width: 0)),
    series: getDefaultTooltipSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<LineSeries<ChartSampleData, num>> getDefaultTooltipSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 2004, y: 42.630000, yValue2: 34.730000),
    ChartSampleData(x: 2005, y: 43.320000, yValue2: 43.400000),
    ChartSampleData(x: 2006, y: 43.660000, yValue2: 38.090000),
    ChartSampleData(x: 2007, y: 43.540000, yValue2: 44.710000),
    ChartSampleData(x: 2008, y: 43.600000, yValue2: 45.320000),
    ChartSampleData(x: 2009, y: 43.500000, yValue2: 46.200000),
    ChartSampleData(x: 2010, y: 43.350000, yValue2: 46.990000),
    ChartSampleData(x: 2011, y: 43.620000, yValue2: 49.170000),
    ChartSampleData(x: 2012, y: 43.930000, yValue2: 50.640000),
    ChartSampleData(x: 2013, y: 44.200000, yValue2: 51.480000),
  ];
  return <LineSeries<ChartSampleData, num>>[
    LineSeries<ChartSampleData, num>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2,
        name: 'Germany',
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<ChartSampleData, num>(
      enableTooltip: true,
      dataSource: chartData,
      width: 2,
      name: 'Mexico',
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
      markerSettings: MarkerSettings(isVisible: true),
    )
  ];
}
