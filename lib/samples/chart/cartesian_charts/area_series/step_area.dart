import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class StepArea extends StatefulWidget {
  StepArea({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _StepAreaState createState() => _StepAreaState(sample);
}

class _StepAreaState extends State<StepArea> {
  _StepAreaState(this.sample);
  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    const String sourceLink =
        'https://www.accuweather.com/en/fr/paris/623/march-weather/623?year=2019';
    const String source = 'www.accuweather.com';
    return getScopedModel(
        getStepAreaChart(false), sample, null, sourceLink, source);
  }
}

SfCartesianChart getStepAreaChart(bool isTileView) {
  return SfCartesianChart(
    legend: Legend(isVisible: isTileView ? false : true),
    title: ChartTitle(text: isTileView ? '' : 'Temperature variation of Paris'),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}°C',
        interval: isTileView ? 4 : 2,
        maximum: 16,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: getStepAreaSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ChartSeries<_RangeAreaData, DateTime>> getStepAreaSeries(bool isTileView) {
  final List<_RangeAreaData> chartData = <_RangeAreaData>[
    _RangeAreaData(DateTime(2019, 3, 1), 12, 9),
    _RangeAreaData(DateTime(2019, 3, 2), 13, 7),
    _RangeAreaData(DateTime(2019, 3, 3), 14, 10),
    _RangeAreaData(DateTime(2019, 3, 4), 12, 5),
    _RangeAreaData(DateTime(2019, 3, 5), 12, 4),
    _RangeAreaData(DateTime(2019, 3, 6), 12, 8),
    _RangeAreaData(DateTime(2019, 3, 7), 13, 6),
    _RangeAreaData(DateTime(2019, 3, 8), 12, 4),
    _RangeAreaData(DateTime(2019, 3, 9), 15, 8),
    _RangeAreaData(DateTime(2019, 3, 10), 14, 7),
    _RangeAreaData(DateTime(2019, 3, 11), 10, 3),
    _RangeAreaData(DateTime(2019, 3, 12), 13, 4),
    _RangeAreaData(DateTime(2019, 3, 13), 12, 4),
    _RangeAreaData(DateTime(2019, 3, 14), 11, 6),
    _RangeAreaData(DateTime(2019, 3, 15), 14, 10),
    _RangeAreaData(DateTime(2019, 3, 16), 14, 9),
    _RangeAreaData(DateTime(2019, 3, 17), 11, 4),
    _RangeAreaData(DateTime(2019, 3, 18), 11, 2),
    // _RangeAreaData(DateTime(2019,3,19), 13, 0),
    // _RangeAreaData(DateTime(2019,3,20), 14, 2),
    // _RangeAreaData(DateTime(2019,3,21), 16, 3),
    // _RangeAreaData(DateTime(2019,3,22), 18, 4),
    // _RangeAreaData(DateTime(2019,3,23), 14, 4),
    // _RangeAreaData(DateTime(2019,3,24), 12, 5),
    // _RangeAreaData(DateTime(2019,3,25), 12, 3),
    // _RangeAreaData(DateTime(2019,3,26), 13, 5),
    // _RangeAreaData(DateTime(2019,3,27), 13, 4),
    // _RangeAreaData(DateTime(2019,3,28), 15, 4),
    // _RangeAreaData(DateTime(2019,3,29), 18, 5),
    // _RangeAreaData(DateTime(2019,3,30), 20, 4),
    // _RangeAreaData(DateTime(2019,3,31), 21, 4),
  ];
  return <ChartSeries<_RangeAreaData, DateTime>>[
    StepAreaSeries<_RangeAreaData, DateTime>(
      dataSource: chartData,
      name: 'High',
      xValueMapper: (_RangeAreaData sales, _) => sales.x,
      yValueMapper: (_RangeAreaData sales, _) => sales.high,
    ),
    StepAreaSeries<_RangeAreaData, DateTime>(
      dataSource: chartData,
      name: 'Low',
      xValueMapper: (_RangeAreaData sales, _) => sales.x,
      yValueMapper: (_RangeAreaData sales, _) => sales.low,
    )
  ];
}

class _RangeAreaData {
  _RangeAreaData(this.x, this.high, this.low);
  final DateTime x;
  final double high;
  final double low;
}
