/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../../model/sample_view.dart';

/// Renders the stacked column 100 chart sample.
class StackedColumn100Chart extends SampleView {
  /// Creates the stacked column 100 chart sample.
  const StackedColumn100Chart(Key key) : super(key: key);

  @override
  _StackedColumn100ChartState createState() => _StackedColumn100ChartState();
}

/// State class of the stacked column 100 chart.
class _StackedColumn100ChartState extends SampleViewState {
  _StackedColumn100ChartState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedColumn100Chart();
  }

  /// Returns the cartesian stacked column 100 chart.
  SfCartesianChart _buildStackedColumn100Chart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Quarterly wise sales of products'),
      legend: Legend(
          isVisible: !isCardView, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.none,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getStackedColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series
  /// which need to render on the stacked column 1oo chart.
  List<ChartSeries<_ChartData, String>> _getStackedColumnSeries() {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData('Q1', 50, 55, 72, 65),
      _ChartData('Q2', 80, 75, 70, 60),
      _ChartData('Q3', 35, 45, 55, 52),
      _ChartData('Q4', 65, 50, 70, 65),
    ];
    return <ChartSeries<_ChartData, String>>[
      StackedColumn100Series<_ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y1,
          name: 'Product A'),
      StackedColumn100Series<_ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y2,
          name: 'Product B'),
      StackedColumn100Series<_ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y3,
          name: 'Product C'),
      StackedColumn100Series<_ChartData, String>(
          dataSource: chartData,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y4,
          name: 'Product D')
    ];
  }
}

/// Private class for storing the stacked column series data points.
class _ChartData {
  _ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
  final String x;
  final num y1;
  final num y2;
  final num y3;
  final num y4;
}
