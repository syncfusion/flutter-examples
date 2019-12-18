import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class RangeBarChart extends StatefulWidget {
  RangeBarChart({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeBarChartState createState() => _RangeBarChartState(sample);
}

class _RangeBarChartState extends State<RangeBarChart> {
  _RangeBarChartState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.holiday-weather.com/sydney/averages/';
    const String source = 'holiday-weather.com';
    return getScopedModel(
        getRangeBarChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getRangeBarChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 1,
    title: ChartTitle(
        text: isTileView ? '' : 'Temperature variation – Sydney vs Melbourne'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    legend: Legend(isVisible: !isTileView),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}°F',
        minimum: 40,
        maximum: 80),
    series: getVerticalRangeColumnSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
    isTransposed: true,
  );
}

List<RangeColumnSeries<ChartSampleData, String>> getVerticalRangeColumnSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'Jul', y: 46, yValue: 63, yValue2: 43, yValue3: 57),
    ChartSampleData(x: 'Aug', y: 48, yValue: 64, yValue2: 45, yValue3: 59),
    ChartSampleData(x: 'Sep', y: 54, yValue: 68, yValue2: 48, yValue3: 63),
    ChartSampleData(x: 'Oct', y: 57, yValue: 72, yValue2: 50, yValue3: 68),
    ChartSampleData(x: 'Nov', y: 61, yValue: 75, yValue2: 54, yValue3: 72),
    ChartSampleData(x: 'Dec', y: 64, yValue: 79, yValue2: 57, yValue3: 75),
  ];
  return <RangeColumnSeries<ChartSampleData, String>>[
    RangeColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        lowValueMapper: (ChartSampleData sales, _) => sales.y,
        highValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Sydney',
        dataLabelSettings: DataLabelSettings(
            isVisible: !isTileView,
            labelAlignment: ChartDataLabelAlignment.top)),
    RangeColumnSeries<ChartSampleData, String>(
        enableTooltip: true,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        lowValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        highValueMapper: (ChartSampleData sales, _) => sales.yValue3,
        name: 'Melbourne',
        dataLabelSettings: DataLabelSettings(
            isVisible: !isTileView,
            labelAlignment: ChartDataLabelAlignment.top))
  ];
}
