import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class ColumnRounded extends StatefulWidget {
  ColumnRounded({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _ColumnRoundedState createState() => _ColumnRoundedState(sample);
}

class _ColumnRoundedState extends State<ColumnRounded> {
  _ColumnRoundedState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.worldatlas.com/articles/largest-cities-in-the-world-by-land-area.html';
    const String source = 'www.worldatlas.com';
    return getScopedModel(
        getRoundedColumnChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getRoundedColumnChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView ? '' : 'Land area of various cities (sq.km)'),
    primaryXAxis: CategoryAxis(
      labelStyle: ChartTextStyle(color: Colors.white),
      axisLine: AxisLine(width: 0),
      labelPosition: ChartDataLabelPosition.inside,
      majorTickLines: MajorTickLines(width: 0),
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(isVisible: false, minimum: 0, maximum: 9000),
    series: getRoundedColumnSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: false,
        format: 'point.x : point.y sq.km',
        header: ''),
  );
}

List<ColumnSeries<ChartSampleData, String>> getRoundedColumnSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'New York', y: 8683),
    ChartSampleData(x: 'Tokyo', y: 6993),
    ChartSampleData(x: 'Chicago', y: 5498),
    ChartSampleData(x: 'Atlanta', y: 5083),
    ChartSampleData(x: 'Boston', y: 4497),
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
      enableTooltip: true,
      width: 0.9,
      dataLabelSettings: DataLabelSettings(
          isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
      dataSource: chartData,
      borderRadius: BorderRadius.circular(10),
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
  ];
}
