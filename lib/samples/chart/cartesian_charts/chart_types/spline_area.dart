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
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      legend: const Legend(isVisible: true, opacity: 0.7),
      title: const ChartTitle(text: 'Inflation rate'),
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(
          interval: 1,
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: const NumericAxis(
          labelFormat: '{value}%',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getSplineAreaSeries(
          themeData.useMaterial3, themeData.brightness == Brightness.light),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<_SplineAreaData>? chartData;

  @override
  void initState() {
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

  /// Returns the list of chart series
  /// which need to render on the spline area chart.
  List<CartesianSeries<_SplineAreaData, double>> _getSplineAreaSeries(
      bool isMaterial3, bool isLightMode) {
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
        color: seriesColor1.withOpacity(0.6),
        borderColor: seriesColor1,
        name: 'India',
        xValueMapper: (_SplineAreaData sales, _) => sales.year,
        yValueMapper: (_SplineAreaData sales, _) => sales.y1,
      ),
      SplineAreaSeries<_SplineAreaData, double>(
        dataSource: chartData,
        borderColor: seriesColor2,
        color: seriesColor2.withOpacity(0.6),
        name: 'China',
        xValueMapper: (_SplineAreaData sales, _) => sales.year,
        yValueMapper: (_SplineAreaData sales, _) => sales.y2,
      )
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}

/// Private class for storing the spline area chart datapoints.
class _SplineAreaData {
  _SplineAreaData(this.year, this.y1, this.y2);
  final double year;
  final double y1;
  final double y2;
}
