import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import '../../../../model/helper.dart';
import '../../../../model/model.dart';

//ignore: must_be_immutable
class SplineArea extends StatefulWidget {
  SplineArea({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _SplineAreaState createState() => _SplineAreaState(sample);
}

class _SplineAreaState extends State<SplineArea> {
  _SplineAreaState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getSplineAreaChart(false), sample);
  }
}

SfCartesianChart getSplineAreaChart(bool isTileView) {
  return SfCartesianChart(
    legend: Legend(isVisible: isTileView ? false : true, opacity: 0.7),
    title: ChartTitle(text: isTileView ? '' : 'Inflation rate'),
    plotAreaBorderWidth: 0,
    primaryXAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: _getSplieAreaSeries(isTileView),
    tooltipBehavior: TooltipBehavior(enable: true),
  );
}

List<ChartSeries<_SplineAreaData, double>> _getSplieAreaSeries(
    bool isTileView) {
  final List<_SplineAreaData> chartData = <_SplineAreaData>[
    _SplineAreaData(2010, 10.53, 3.3),
    _SplineAreaData(2011, 9.5, 5.4),
    _SplineAreaData(2012, 10, 2.65),
    _SplineAreaData(2013, 9.4, 2.62),
    _SplineAreaData(2014, 5.8, 1.99),
    _SplineAreaData(2015, 4.9, 1.44),
    _SplineAreaData(2016, 4.5, 2),
    _SplineAreaData(2017, 3.6, 1.56),
    _SplineAreaData(2018, 3.43, 2.1),
  ];
  return <ChartSeries<_SplineAreaData, double>>[
    SplineAreaSeries<_SplineAreaData, double>(
      dataSource: chartData,
      name: 'India',
      xValueMapper: (_SplineAreaData sales, _) => sales.year,
      yValueMapper: (_SplineAreaData sales, _) => sales.y1,
    ),
    SplineAreaSeries<_SplineAreaData, double>(
      dataSource: chartData,
      name: 'China',
      xValueMapper: (_SplineAreaData sales, _) => sales.year,
      yValueMapper: (_SplineAreaData sales, _) => sales.y2,
    )
  ];
}

class _SplineAreaData {
  _SplineAreaData(this.year, this.y1, this.y2);
  final double year;
  final double y1;
  final double y2;
}
