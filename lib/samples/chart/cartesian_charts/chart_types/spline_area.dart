/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../model/sample_view.dart';

/// Renders the spline area chart sample.
class SplineArea extends SampleView {
  /// Creates the spline area chart sample.
  const SplineArea(Key key) : super(key: key);

  @override
  _SplineAreaState createState() => _SplineAreaState();
}

/// State class of the spline area chart.
class _SplineAreaState extends SampleViewState {
  _SplineAreaState();

  @override
  Widget build(BuildContext context) {
    return _buildSplineAreaChart();
  }

  /// Returns the cartesian spline are chart.
  SfCartesianChart _buildSplineAreaChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: true, opacity: 0.7),
      title: ChartTitle(text: 'Inflation rate'),
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          interval: 1,
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}%',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getSplieAreaSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the spline area chart.
  List<ChartSeries<_SplineAreaData, double>> _getSplieAreaSeries() {
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
        color: const Color.fromRGBO(75, 135, 185, 0.6),
        borderColor: const Color.fromRGBO(75, 135, 185, 1),
        borderWidth: 2,
        name: 'India',
        xValueMapper: (_SplineAreaData sales, _) => sales.year,
        yValueMapper: (_SplineAreaData sales, _) => sales.y1,
      ),
      SplineAreaSeries<_SplineAreaData, double>(
        dataSource: chartData,
        borderColor: const Color.fromRGBO(192, 108, 132, 1),
        color: const Color.fromRGBO(192, 108, 132, 0.6),
        borderWidth: 2,
        name: 'China',
        xValueMapper: (_SplineAreaData sales, _) => sales.year,
        yValueMapper: (_SplineAreaData sales, _) => sales.y2,
      )
    ];
  }
}

/// Private class for storing the spline area chart datapoints.
class _SplineAreaData {
  _SplineAreaData(this.year, this.y1, this.y2);
  final double year;
  final double y1;
  final double y2;
}
