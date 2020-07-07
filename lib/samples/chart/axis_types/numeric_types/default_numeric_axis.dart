import 'package:flutter/material.dart';
import 'package:flutter_examples/model/helper.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//ignore: must_be_immutable
class NumericDefault extends StatefulWidget {
  NumericDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _NumericDefaultState createState() => _NumericDefaultState(sample);
}

class _NumericDefaultState extends State<NumericDefault> {
  _NumericDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.google.com/search?q=india+vs+australia+odi+result+2019&oq=indian+vs+australia+odi+res&aqs=chrome.2.69i57j0l5.11336j1j4&sourceid=chrome&ie=UTF-8';
    const String source = 'www.google.com';
    return getScopedModel(
        getDefaultNumericAxisChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getDefaultNumericAxisChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Australia vs India ODI - 2019'),
    plotAreaBorderWidth: 0,
    legend: Legend(
        isVisible: isTileView ? false : true, position: LegendPosition.top),
    primaryXAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Match'),
        minimum: 0,
        maximum: 6,
        interval: 1,
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        edgeLabelPlacement: EdgeLabelPlacement.hide),
    primaryYAxis: NumericAxis(
        title: AxisTitle(text: isTileView ? '' : 'Score'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getDefaultNumericSeries(isTileView),
    tooltipBehavior: TooltipBehavior(
        enable: true, format: 'Score: point.y', canShowMarker: false),
  );
}

List<ColumnSeries<ChartSampleData, num>> getDefaultNumericSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(xValue: 1, yValue: 240, yValue2: 236),
    ChartSampleData(xValue: 2, yValue: 250, yValue2: 242),
    ChartSampleData(xValue: 3, yValue: 281, yValue2: 313),
    ChartSampleData(xValue: 4, yValue: 358, yValue2: 359),
    ChartSampleData(xValue: 5, yValue: 237, yValue2: 272)
  ];
  return <ColumnSeries<ChartSampleData, num>>[
    ColumnSeries<ChartSampleData, num>(
        enableTooltip: true,
        dataSource: chartData,
        color: const Color.fromRGBO(237, 221, 76, 1),
        name: 'Australia',
        xValueMapper: (ChartSampleData sales, _) => sales.xValue,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2),
    ColumnSeries<ChartSampleData, num>(
        enableTooltip: true,
        dataSource: chartData,
        color: const Color.fromRGBO(2, 109, 213, 1),
        xValueMapper: (ChartSampleData sales, _) => sales.xValue,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'India'),
  ];
}
