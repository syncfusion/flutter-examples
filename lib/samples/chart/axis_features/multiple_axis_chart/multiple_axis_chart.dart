import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class MultipleAxis extends StatefulWidget {
  MultipleAxis({this.sample, Key key}) : super(key: key);

  SubItem sample;

  @override
  _MultipleAxisState createState() => _MultipleAxisState(sample);
}

class _MultipleAxisState extends State<MultipleAxis> {
  _MultipleAxisState(this.sample);

  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.accuweather.com/en/us/new-york-ny/10007/month/349727?monyr=5/01/2019';
    const String source = 'www.accuweather.com';
    return getScopedModel(
        getMultipleAxisLineChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getMultipleAxisLineChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(
        text: isTileView ? '' : 'Washington vs New York temperature'),
    legend: Legend(isVisible: isTileView ? false : true),
    axes: <ChartAxis>[
      NumericAxis(
          opposedPosition: true,
          name: 'yAxis1',
          majorGridLines: MajorGridLines(width: 0),
          labelFormat: '{value}°F',
          minimum: 40,
          maximum: 100,
          interval: 10)
    ],
    primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        title: AxisTitle(textStyle: ChartTextStyle(color: Colors.black))),
    primaryYAxis: NumericAxis(
      majorGridLines: MajorGridLines(width: 0),
      opposedPosition: false,
      minimum: 0,
      maximum: 50,
      interval: 10,
      labelFormat: '{value}°C',
    ),
    series: getMultipleAxisLineSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ChartSeries<ChartSampleData, DateTime>> getMultipleAxisLineSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: DateTime(2019, 5, 1), y: 13, yValue2: 69.8),
    ChartSampleData(x: DateTime(2019, 5, 2), y: 26, yValue2: 87.8),
    ChartSampleData(x: DateTime(2019, 5, 3), y: 13, yValue2: 78.8),
    ChartSampleData(x: DateTime(2019, 5, 4), y: 22, yValue2: 75.2),
    ChartSampleData(x: DateTime(2019, 5, 5), y: 14, yValue2: 68),
    ChartSampleData(x: DateTime(2019, 5, 6), y: 23, yValue2: 78.8),
    ChartSampleData(x: DateTime(2019, 5, 7), y: 21, yValue2: 80.6),
    ChartSampleData(x: DateTime(2019, 5, 8), y: 22, yValue2: 73.4),
    ChartSampleData(x: DateTime(2019, 5, 9), y: 16, yValue2: 78.8),
  ];
  return <ChartSeries<ChartSampleData, DateTime>>[
    ColumnSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'New York'),
    LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        yAxisName: 'yAxis1',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        name: 'Washington')
  ];
}
