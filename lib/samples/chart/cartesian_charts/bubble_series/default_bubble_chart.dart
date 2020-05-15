import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class BubbleDefault extends StatefulWidget {
  BubbleDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _BubbleDefaultState createState() => _BubbleDefaultState(sample);
}

class _BubbleDefaultState extends State<BubbleDefault> {
  _BubbleDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultBubbleChart(false), sample);
  }
}

SfCartesianChart getDefaultBubbleChart(bool isTileView) {
  return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isTileView ? '' : 'World countries details'),
      primaryXAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          title: AxisTitle(text: isTileView ? '' : 'Literacy rate'),
          minimum: 60,
          maximum: 100),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          title: AxisTitle(text: isTileView ? '' : 'GDP growth rate')),
      tooltipBehavior: TooltipBehavior(
          enable: true,
          textAlignment: ChartAlignment.near,
          header: '',
          canShowMarker: false,
          format:
              'point.x\nLiteracy rate : point.x%\nGDP growth rate : point.y\nPopulation : point.sizeB'),
      series: getDefaultBubbleSeries(isTileView));
}

List<BubbleSeries<ChartSampleData, num>> getDefaultBubbleSeries(
    bool isTileView) {
  final List<ChartSampleData> bubbleData = <ChartSampleData>[
    ChartSampleData(x: 'China', xValue: 92.2, y: 7.8, size: 1.347),
    ChartSampleData(x: 'India', xValue: 74, y: 6.5, size: 1.241),
    ChartSampleData(x: 'Indonesia', xValue: 90.4, y: 6.0, size: 0.238),
    ChartSampleData(x: 'US', xValue: 99.4, y: 2.2, size: 0.312),
    ChartSampleData(x: 'Germany', xValue: 99, y: 0.7, size: 0.0818),
    ChartSampleData(x: 'Egypt', xValue: 72, y: 2.0, size: 0.0826),
    ChartSampleData(x: 'Russia', xValue: 99.6, y: 3.4, size: 0.143),
    ChartSampleData(x: 'Japan', xValue: 99, y: 0.2, size: 0.128),
    ChartSampleData(x: 'Mexico', xValue: 86.1, y: 4.0, size: 0.115),
    ChartSampleData(x: 'Philippines', xValue: 92.6, y: 6.6, size: 0.096),
    ChartSampleData(x: 'Nigeria', xValue: 61.3, y: 1.45, size: 0.162),
    ChartSampleData(x: 'Hong Kong', xValue: 82.2, y: 3.97, size: 0.7),
    ChartSampleData(x: 'Netherland', xValue: 79.2, y: 3.9, size: 0.162),
    ChartSampleData(x: 'Jordan', xValue: 72.5, y: 4.5, size: 0.7),
    ChartSampleData(x: 'Australia', xValue: 81, y: 3.5, size: 0.21),
    ChartSampleData(x: 'Mongolia', xValue: 66.8, y: 3.9, size: 0.028),
    ChartSampleData(x: 'Taiwan', xValue: 78.4, y: 2.9, size: 0.231),
  ];
  return <BubbleSeries<ChartSampleData, num>>[
    BubbleSeries<ChartSampleData, num>(
      enableTooltip: true,
      opacity: 0.7,
      dataSource: bubbleData,
      xValueMapper: (ChartSampleData sales, _) => sales.xValue,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      sizeValueMapper: (ChartSampleData sales, _) => sales.size,
    )
  ];
}
