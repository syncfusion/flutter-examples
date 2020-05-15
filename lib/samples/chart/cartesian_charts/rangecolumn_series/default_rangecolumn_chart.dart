import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class RangeColumnDefault extends StatefulWidget {
  RangeColumnDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeColumnDefaultState createState() => _RangeColumnDefaultState(sample);
}

class _RangeColumnDefaultState extends State<RangeColumnDefault> {
  _RangeColumnDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.holiday-weather.com/london/averages/';
    const String source = 'holiday-weather.com';
    return getScopedModel(
        getDefaultRangeColumnChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getDefaultRangeColumnChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView
            ? ''
            : 'Average half-yearly temperature variation of London, UK'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        interval: isTileView ? 5 : 2,
        labelFormat: '{value}°C',
        majorTickLines: MajorTickLines(size: 0)),
    series: getDefaultRangeColumnSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<RangeColumnSeries<ChartSampleData, String>> getDefaultRangeColumnSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Jan', y: 3, yValue: 6),
    ChartSampleData(x: 'Feb', y: 3, yValue: 7),
    ChartSampleData(x: 'Mar', y: 4, yValue: 10),
    ChartSampleData(x: 'Apr', y: 6, yValue: 13),
    ChartSampleData(x: 'May', y: 9, yValue: 17),
    ChartSampleData(x: 'June', y: 12, yValue: 20),
  ];
  return <RangeColumnSeries<ChartSampleData, String>>[
    RangeColumnSeries<ChartSampleData, String>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      lowValueMapper: (ChartSampleData sales, _) => sales.y,
      highValueMapper: (ChartSampleData sales, _) => sales.yValue,
      dataLabelSettings: DataLabelSettings(
          isVisible: isTileView ? false : true,
          labelAlignment: ChartDataLabelAlignment.top,
          textStyle: ChartTextStyle(fontSize: 10)),
    )
  ];
}
