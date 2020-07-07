import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class ColumnDefault extends StatefulWidget {
  ColumnDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _ColumnDefaultState createState() => _ColumnDefaultState(sample);
}

class _ColumnDefaultState extends State<ColumnDefault> {
  _ColumnDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultColumnChart(false), sample);
  }
}

SfCartesianChart getDefaultColumnChart(bool isTileView) {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: isTileView ? '' : 'Population growth of various countries'),
    primaryXAxis: CategoryAxis(
      majorGridLines: MajorGridLines(width: 0),
    ),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}%',
        majorTickLines: MajorTickLines(size: 0)),
    series: getDefaultColumnSeries(isTileView),
    tooltipBehavior:
        TooltipBehavior(enable: true, header: '', canShowMarker: false),
  );
}

List<ColumnSeries<ChartSampleData, String>> getDefaultColumnSeries(
    bool isTileView) {
  final List<ChartSampleData> chartData = <ChartSampleData>[
    ChartSampleData(x: 'China', y: 0.541),
    ChartSampleData(x: 'Brazil', y: 0.818),
    ChartSampleData(x: 'Bolivia', y: 1.51),
    ChartSampleData(x: 'Mexico', y: 1.302),
    ChartSampleData(x: 'Egypt', y: 2.017),
    ChartSampleData(x: 'Mongolia', y: 1.683),
  ];
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (ChartSampleData sales, _) => sales.x,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
      dataLabelSettings: DataLabelSettings(
          isVisible: true, textStyle: ChartTextStyle(fontSize: 10)),
    )
  ];
}
