/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the Chart with multiple axes.
class MultipleAxis extends SampleView {
  const MultipleAxis(Key key) : super(key: key);

  @override
  _MultipleAxisState createState() => _MultipleAxisState();
}

/// State class of the Chart with multiple axes.
class _MultipleAxisState extends SampleViewState {
  _MultipleAxisState();

  List<ChartSampleData>? temperatureData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    temperatureData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2019, 5), y: 13, secondSeriesYValue: 69.8),
      ChartSampleData(x: DateTime(2019, 5, 2), y: 26, secondSeriesYValue: 87.8),
      ChartSampleData(x: DateTime(2019, 5, 3), y: 13, secondSeriesYValue: 78.8),
      ChartSampleData(x: DateTime(2019, 5, 4), y: 22, secondSeriesYValue: 75.2),
      ChartSampleData(x: DateTime(2019, 5, 5), y: 14, secondSeriesYValue: 68),
      ChartSampleData(x: DateTime(2019, 5, 6), y: 23, secondSeriesYValue: 78.8),
      ChartSampleData(x: DateTime(2019, 5, 7), y: 21, secondSeriesYValue: 80.6),
      ChartSampleData(x: DateTime(2019, 5, 8), y: 22, secondSeriesYValue: 73.4),
      ChartSampleData(x: DateTime(2019, 5, 9), y: 16, secondSeriesYValue: 78.8),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with multiple series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      title: ChartTitle(
        text: isCardView ? '' : 'Washington vs New York temperature',
      ),
      primaryXAxis: const DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        minimum: 0,
        maximum: 50,
        interval: 10,
        labelFormat: '{value}°C',
      ),

      /// API for multiple axis. It can returns the various axis to the Chart.
      axes: const <ChartAxis>[
        NumericAxis(
          opposedPosition: true,
          name: 'yAxis1',
          majorGridLines: MajorGridLines(width: 0),
          labelFormat: '{value}°F',
          minimum: 40,
          maximum: 100,
          interval: 10,
        ),
      ],
      series: _buildMultipleSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<CartesianSeries<ChartSampleData, DateTime>> _buildMultipleSeries() {
    return <CartesianSeries<ChartSampleData, DateTime>>[
      ColumnSeries<ChartSampleData, DateTime>(
        dataSource: temperatureData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'New York',
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: temperatureData,
        yAxisName: 'yAxis1',
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: 'Washington',
      ),
    ];
  }

  @override
  void dispose() {
    temperatureData!.clear();
    super.dispose();
  }
}
