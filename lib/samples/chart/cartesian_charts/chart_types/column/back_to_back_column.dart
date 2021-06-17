/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the back to back column chart sample
class ColumnBack extends SampleView {
  /// Creates the back to back column chart sample
  const ColumnBack(Key key) : super(key: key);

  @override
  _ColumnBackState createState() => _ColumnBackState();
}

class _ColumnBackState extends SampleViewState {
  _ColumnBackState();

  @override
  Widget build(BuildContext context) {
    return _buildBackColumnChart();
  }

  SfCartesianChart _buildBackColumnChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        enableSideBySideSeriesPlacement: false,
        title: ChartTitle(
            text: isCardView ? '' : 'Population of various countries'),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(size: 0),
            numberFormat: NumberFormat.compact(),
            majorGridLines: const MajorGridLines(width: 0),
            rangePadding: ChartRangePadding.additional),
        series: _getBackToBackColumn(),
        tooltipBehavior: TooltipBehavior(enable: true));
  }

  List<ColumnSeries<ChartSampleData, String>> _getBackToBackColumn() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'France',
          y: 63621381,
          yValue: 65027507,
          secondSeriesYValue: 66316092),
      ChartSampleData(
          x: 'United Kingdom',
          y: 60846820,
          yValue: 62766365,
          secondSeriesYValue: 64613160),
      ChartSampleData(
          x: 'Italy',
          y: 58143979,
          yValue: 59277417,
          secondSeriesYValue: 60789140),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: 0.7,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: '2014'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: 0.5,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: '2010'),
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,
          width: 0.3,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: '2006')
    ];
  }
}
