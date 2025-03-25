/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the stacked bar 100 series chart sample.
class StackedBar100Chart extends SampleView {
  /// Creates the stacked bar 100 series chart sample.
  const StackedBar100Chart(Key key) : super(key: key);

  @override
  _StackedBar100ChartState createState() => _StackedBar100ChartState();
}

/// State class for the stacked bar 100 series chart.
class _StackedBar100ChartState extends SampleViewState {
  _StackedBar100ChartState();

  List<_ChartData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _chartData = <_ChartData>[
      _ChartData('Jan', 6, 6, 1),
      _ChartData('Feb', 8, 8, 1.5),
      _ChartData('Mar', 12, 11, 2),
      _ChartData('Apr', 15.5, 16, 2.5),
      _ChartData('May', 20, 21, 3),
      _ChartData('June', 24, 25, 3.5),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedBar100Chart();
  }

  /// Returns the cartesian stacked bar 100 chart.
  SfCartesianChart _buildStackedBar100Chart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title: ChartTitle(text: isCardView ? '' : 'Sales comparison of fruits'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.none,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildStackedBar100Series(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian stacked bar 100 series.
  List<CartesianSeries<_ChartData, String>> _buildStackedBar100Series() {
    return <CartesianSeries<_ChartData, String>>[
      StackedBar100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.apple,
        name: 'Apple',
      ),
      StackedBar100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.orange,
        name: 'Orange',
      ),
      StackedBar100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.wastage,
        name: 'Wastage',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

/// Private class for storing the stacked bar 100 series data points.
class _ChartData {
  _ChartData(this.x, this.apple, this.orange, this.wastage);
  final String x;
  final num apple;
  final num orange;
  final num wastage;
}
