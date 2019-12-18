import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class StepLineDefault extends StatefulWidget {
  StepLineDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StepLineDefaultState createState() => _StepLineDefaultState(sample);
}

class _StepLineDefaultState extends State<StepLineDefault> {
  _StepLineDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultStepLineChart(false), sample);
  }
}

SfCartesianChart getDefaultStepLineChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(text: isTileView ? '' : 'Electricity-Production'),
    primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        title: AxisTitle(text: isTileView ? '' : 'Production (kWh)'),
        labelFormat: '{value}B'),
    legend: Legend(isVisible: isTileView ? false : true),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: getDefaultStepLineSeries(isTileView),
  );
}

List<StepLineSeries<ChartSampleData, num>> getDefaultStepLineSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 2000, y: 416, yValue2: 180),
    ChartSampleData(x: 2001, y: 490, yValue2: 240),
    ChartSampleData(x: 2002, y: 470, yValue2: 370),
    ChartSampleData(x: 2003, y: 500, yValue2: 200),
    ChartSampleData(x: 2004, y: 449, yValue2: 229),
    ChartSampleData(x: 2005, y: 470, yValue2: 210),
    ChartSampleData(x: 2006, y: 437, yValue2: 337),
    ChartSampleData(x: 2007, y: 458, yValue2: 258),
    ChartSampleData(x: 2008, y: 500, yValue2: 300),
    ChartSampleData(x: 2009, y: 473, yValue2: 173),
    ChartSampleData(x: 2010, y: 520, yValue2: 220),
    ChartSampleData(x: 2011, y: 509, yValue2: 309)
  ];
  return <StepLineSeries<ChartSampleData, num>>[
    StepLineSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Renewable'),
    StepLineSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Non-Renewable')
  ];
}
