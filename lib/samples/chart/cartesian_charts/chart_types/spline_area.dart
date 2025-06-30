/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the spline area series chart sample.
class SplineArea extends SampleView {
  /// Creates the spline area series chart sample.
  const SplineArea(Key key) : super(key: key);

  @override
  _SplineAreaState createState() => _SplineAreaState();
}

/// State class for the spline area series chart.
class _SplineAreaState extends SampleViewState {
  _SplineAreaState();

  List<_SplineAreaData>? chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    chartData = <_SplineAreaData>[
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplineAreaChart();
  }

  /// Returns the cartesian spline area series chart.
  SfCartesianChart _buildSplineAreaChart() {
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      legend: const Legend(isVisible: true, opacity: 0.7),
      title: const ChartTitle(text: 'Inflation rate'),
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(
        interval: 1,
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildSplineAreaSeries(
        themeData.useMaterial3,
        themeData.brightness == Brightness.light,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian spline area series.
  List<CartesianSeries<_SplineAreaData, double>> _buildSplineAreaSeries(
    bool isMaterial3,
    bool isLightMode,
  ) {
    final Color seriesColor1 = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(6, 174, 224, 1)
              : const Color.fromRGBO(255, 245, 0, 1))
        : const Color.fromRGBO(75, 135, 185, 1);
    final Color seriesColor2 = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(99, 85, 199, 1)
              : const Color.fromRGBO(51, 182, 119, 1))
        : const Color.fromRGBO(192, 108, 132, 1);
    return <CartesianSeries<_SplineAreaData, double>>[
      SplineAreaSeries<_SplineAreaData, double>(
        dataSource: chartData,
        xValueMapper: (_SplineAreaData data, int index) => data.year,
        yValueMapper: (_SplineAreaData data, int index) => data.y1,
        color: seriesColor1.withValues(alpha: 0.6),
        borderColor: seriesColor1,
        name: 'India',
      ),
      SplineAreaSeries<_SplineAreaData, double>(
        dataSource: chartData,
        xValueMapper: (_SplineAreaData data, int index) => data.year,
        yValueMapper: (_SplineAreaData data, int index) => data.y2,
        borderColor: seriesColor2,
        color: seriesColor2.withValues(alpha: 0.6),
        name: 'China',
      ),
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}

/// Private class for storing the spline area chart data points.
class _SplineAreaData {
  _SplineAreaData(this.year, this.y1, this.y2);
  final double year;
  final double y1;
  final double y2;
}
