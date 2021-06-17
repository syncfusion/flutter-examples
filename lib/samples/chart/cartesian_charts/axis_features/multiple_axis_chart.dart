/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the chart with multiple axes.
class MultipleAxis extends SampleView {
  /// Creates the chart with multiple axes.
  const MultipleAxis(Key key) : super(key: key);

  @override
  _MultipleAxisState createState() => _MultipleAxisState();
}

/// State class of the chart with multiple axes.
class _MultipleAxisState extends SampleViewState {
  _MultipleAxisState();

  @override
  Widget build(BuildContext context) {
    return _buildMultipleAxisLineChart();
  }

  /// Returns the chart with multiple axes.
  SfCartesianChart _buildMultipleAxisLineChart() {
    return SfCartesianChart(
      title: ChartTitle(
          text: isCardView ? '' : 'Washington vs New York temperature'),
      legend: Legend(isVisible: !isCardView),

      /// API for multiple axis. It can returns the various axis to the chart.
      axes: <ChartAxis>[
        NumericAxis(
            opposedPosition: true,
            name: 'yAxis1',
            majorGridLines: const MajorGridLines(width: 0),
            labelFormat: '{value}°F',
            minimum: 40,
            maximum: 100,
            interval: 10)
      ],
      primaryXAxis:
          DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        opposedPosition: false,
        minimum: 0,
        maximum: 50,
        interval: 10,
        labelFormat: '{value}°C',
      ),
      series: _getMultipleAxisLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to
  /// render on the multiple axes chart.
  List<ChartSeries<ChartSampleData, DateTime>> _getMultipleAxisLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2019, 5, 1), y: 13, secondSeriesYValue: 69.8),
      ChartSampleData(x: DateTime(2019, 5, 2), y: 26, secondSeriesYValue: 87.8),
      ChartSampleData(x: DateTime(2019, 5, 3), y: 13, secondSeriesYValue: 78.8),
      ChartSampleData(x: DateTime(2019, 5, 4), y: 22, secondSeriesYValue: 75.2),
      ChartSampleData(x: DateTime(2019, 5, 5), y: 14, secondSeriesYValue: 68),
      ChartSampleData(x: DateTime(2019, 5, 6), y: 23, secondSeriesYValue: 78.8),
      ChartSampleData(x: DateTime(2019, 5, 7), y: 21, secondSeriesYValue: 80.6),
      ChartSampleData(x: DateTime(2019, 5, 8), y: 22, secondSeriesYValue: 73.4),
      ChartSampleData(x: DateTime(2019, 5, 9), y: 16, secondSeriesYValue: 78.8),
    ];
    return <ChartSeries<ChartSampleData, DateTime>>[
      ColumnSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'New York'),
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          yAxisName: 'yAxis1',
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Washington')
    ];
  }
}
