/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the stacked line 100 chart sample.
class StackedLine100Chart extends SampleView {
  /// Creates the stacked line 100 chart sample.
  const StackedLine100Chart(Key key) : super(key: key);

  @override
  _StackedLineChartState createState() => _StackedLineChartState();
}

/// State class of the stacked line 100 chart.
class _StackedLineChartState extends SampleViewState {
  _StackedLineChartState();

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
      primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.none,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getStackedLine100Series(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of char series
  /// which need to render on the stacked line 100 chart.
  List<ChartSeries<_ChartData, String>> _getStackedLine100Series() {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData('Food', 55, 40, 45, 48),
      _ChartData('Transport', 33, 45, 54, 28),
      _ChartData('Medical', 43, 23, 20, 34),
      _ChartData('Clothes', 32, 54, 23, 54),
      _ChartData('Books', 56, 18, 43, 55),
      _ChartData('Others', 23, 54, 33, 56),
    ];
    return <ChartSeries<_ChartData, String>>[
      StackedLine100Series<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.father,
          name: 'Father',
          markerSettings: const MarkerSettings(isVisible: true)),
      StackedLine100Series<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.mother,
          name: 'Mother',
          markerSettings: const MarkerSettings(isVisible: true)),
      StackedLine100Series<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.son,
          name: 'Son',
          markerSettings: const MarkerSettings(isVisible: true)),
      StackedLine100Series<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.daughter,
          name: 'Daughter',
          markerSettings: const MarkerSettings(isVisible: true))
    ];
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
