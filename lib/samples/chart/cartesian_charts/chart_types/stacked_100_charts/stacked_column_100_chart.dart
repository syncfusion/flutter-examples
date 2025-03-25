/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the stacked column 100 series chart sample.
class StackedColumn100Chart extends SampleView {
  /// Creates the stacked column 100 series chart sample.
  const StackedColumn100Chart(Key key) : super(key: key);

  @override
  _StackedColumn100ChartState createState() => _StackedColumn100ChartState();
}

/// State class for the stacked column 100 chart.
class _StackedColumn100ChartState extends SampleViewState {
  _StackedColumn100ChartState();

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
      _ChartData('Q1', 50, 55, 72, 65),
      _ChartData('Q2', 80, 75, 70, 60),
      _ChartData('Q3', 35, 45, 55, 52),
      _ChartData('Q4', 65, 50, 70, 65),
    ];
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
        text: isCardView ? '' : 'Quarterly wise sales of products',
      ),
      legend: Legend(
        isVisible: !isCardView,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.none,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildStackedColumn100Series(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian stacked column 100 series.
  List<CartesianSeries<_ChartData, String>> _buildStackedColumn100Series() {
    return <CartesianSeries<_ChartData, String>>[
      StackedColumn100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.y1,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        name: 'Product A',
      ),
      StackedColumn100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.y2,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        name: 'Product B',
      ),
      StackedColumn100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.y3,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        name: 'Product C',
      ),
      StackedColumn100Series<_ChartData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.y4,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        name: 'Product D',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

/// Private class for storing the stacked column 100 series data points.
class _ChartData {
  _ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
  final String x;
  final num y1;
  final num y2;
  final num y3;
  final num y4;
}
