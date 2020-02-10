import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class BarRounded extends StatefulWidget {
  BarRounded({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BarRoundedState createState() => _BarRoundedState(sample);
}

class _BarRoundedState extends State<BarRounded> {
  _BarRoundedState(this.sample);
  final SubItem sample;

  
  @override
  Widget build(BuildContext context) {
    const String sourceLink = 'https://www.indexmundi.com/g/r.aspx?v=24';
    const String source = 'www.indexmundi.com';
    return getScopedModel(
        getRoundedBarChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getRoundedBarChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView ? '' : 'Population growth rate of countries'),
    primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        minimum: -2, maximum: 2, majorTickLines: MajorTickLines(size: 0)),
    series: getRoundedBarSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<BarSeries<ChartSampleData, String>> getRoundedBarSeries(bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Iceland', y: 1.13),
    ChartSampleData(x: 'Moldova', y: -1.05),
    ChartSampleData(x: 'Malaysia', y: 1.37),
    ChartSampleData(x: 'American Samoa', y: -1.3),
    ChartSampleData(x: 'Singapore', y: 1.82),
    ChartSampleData(x: 'Puerto Rico', y: -1.74),
    ChartSampleData(x: 'Algeria', y: 1.7)
  ];
  return <BarSeries<ChartSampleData, String>>[
    BarSeries<ChartSampleData, String>(
      enableTooltip: true,
      dataSource: chartData,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
  ];
}
