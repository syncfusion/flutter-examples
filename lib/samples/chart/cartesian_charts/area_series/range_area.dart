import 'dart:math';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class RangeArea extends StatefulWidget {
  RangeArea({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeAreaState createState() => _RangeAreaState(sample);
}

class _RangeAreaState extends State<RangeArea> {
  _RangeAreaState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRangeAreaChart(false), sample);
  }
}

SfCartesianChart getRangeAreaChart(bool isTileView) {
  return SfCartesianChart(
    title: ChartTitle(text: isTileView ? '' : 'Average temperature variation'),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.y(),
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}°C',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    zoomPanBehavior:
        ZoomPanBehavior(zoomMode: ZoomMode.x, enableSelectionZooming: true),
    series: _getRangeAreaSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true, decimalPlaces: 1),
  );
}

dynamic getData() {
  List<_RangeAreaData> _chartData;
  _chartData = <_RangeAreaData>[];
  double value = 30;
  for (int i = 0; i < 100; i++) {
    final Random yValue = Random();
    if (yValue.nextDouble() > .5) {
      value += Random().nextDouble();
    } else {
      value -= Random().nextDouble();
    }
    _chartData.add(_RangeAreaData(DateTime(2000, i + 2, i), value, value + 10));
  }
  return _chartData;
}

List<ChartSeries<_RangeAreaData, DateTime>> _getRangeAreaSeries(
    bool isTileView) {
  final List<_RangeAreaData> chartData = getData();
  return <ChartSeries<_RangeAreaData, DateTime>>[
    RangeAreaSeries<_RangeAreaData, DateTime>(
      dataSource: chartData,
      name: 'London',
      borderWidth: 2,
      borderColor: Colors.blue,
      color: Colors.blue[50],
      borderDrawMode: RangeAreaBorderMode.excludeSides,
      xValueMapper: (_RangeAreaData sales, _) => sales.month,
      highValueMapper: (_RangeAreaData sales, _) => sales.high,
      lowValueMapper: (_RangeAreaData sales, _) => sales.low,
    )
  ];
}

class _RangeAreaData {
  _RangeAreaData(this.month, this.high, this.low);
  final DateTime month;
  final double high;
  final double low;
}
