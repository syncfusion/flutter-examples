/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders dashed Line series sample.
class LineDashed extends SampleView {
  /// Creates dashed Line series sample.
  const LineDashed(Key key) : super(key: key);

  @override
  _LineDashedState createState() => _LineDashedState();
}

class _LineDashedState extends SampleViewState {
  _LineDashedState();

  List<_ChartData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <_ChartData>[
      _ChartData(2010, 6.6, 9.0, 15.1, 18.8),
      _ChartData(2011, 6.3, 9.3, 15.5, 18.5),
      _ChartData(2012, 6.7, 10.2, 14.5, 17.6),
      _ChartData(2013, 6.7, 10.2, 13.9, 16.1),
      _ChartData(2014, 6.4, 10.9, 13, 17.2),
      _ChartData(2015, 6.8, 9.3, 13.4, 18.9),
      _ChartData(2016, 7.7, 10.1, 14.2, 19.4),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Capital investment as a share of exports',
      ),
      primaryXAxis: const NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(width: 0),
        interval: 2,
      ),
      primaryYAxis: NumericAxis(
        minimum: 3,
        maximum: 21,
        interval: isCardView ? 6 : 3,
        labelFormat: '{value}%',
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
      ),
      series: _buildLineSeries(),
      legend: Legend(
        isVisible: isCardView ? false : true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<_ChartData, num>> _buildLineSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,

        /// The property uses to render a Line with dashes.
        dashArray: const <double>[15, 3, 3, 3],
        name: 'Singapore',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y2,
        dashArray: const <double>[15, 3, 3, 3],
        name: 'Saudi Arabia',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y3,
        dashArray: const <double>[15, 3, 3, 3],
        name: 'Spain',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y4,
        dashArray: const <double>[15, 3, 3, 3],
        name: 'Portugal',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2, this.y3, this.y4);
  final double x;
  final double y;
  final double y2;
  final double y3;
  final double y4;
}
