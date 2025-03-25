/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the stacked line 100 series chart sample.
class StackedLine100Chart extends SampleView {
  /// Creates the stacked line 100 series chart sample.
  const StackedLine100Chart(Key key) : super(key: key);

  @override
  _StackedLineChartState createState() => _StackedLineChartState();
}

/// State class for the stacked line 100 series chart.
class _StackedLineChartState extends SampleViewState {
  _StackedLineChartState();

  List<_ChartData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <_ChartData>[
      _ChartData('Food', 55, 40, 45, 48),
      _ChartData('Transport', 33, 45, 54, 28),
      _ChartData('Medical', 43, 23, 20, 34),
      _ChartData('Clothes', 32, 54, 23, 54),
      _ChartData('Books', 56, 18, 43, 55),
      _ChartData('Others', 23, 54, 33, 56),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedLine100Chart();
  }

  /// Returns the cartesian stacked line 100 chart.
  SfCartesianChart _buildStackedLine100Chart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Monthly expense of a family'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelRotation: isCardView ? 0 : -45,
      ),
      primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.none,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildStackedLine100Series(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian stacked line 100 series.
  List<CartesianSeries<_ChartData, String>> _buildStackedLine100Series() {
    return <CartesianSeries<_ChartData, String>>[
      StackedLine100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.father,
        name: 'Father',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      StackedLine100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.mother,
        name: 'Mother',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      StackedLine100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.son,
        name: 'Son',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      StackedLine100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.daughter,
        name: 'Daughter',
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

/// Private class for storing the stacked line 100 chart.
class _ChartData {
  _ChartData(this.x, this.father, this.mother, this.son, this.daughter);
  final String x;
  final num father;
  final num mother;
  final num son;
  final num daughter;
}
