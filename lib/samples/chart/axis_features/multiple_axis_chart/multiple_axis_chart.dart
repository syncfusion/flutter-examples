/// Package import
import 'package:flutter/material.dart';
/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the chart with multiple axes.
class MultipleAxis extends SampleView {
  const MultipleAxis(Key key) : super(key: key);

  @override
  _MultipleAxisState createState() => _MultipleAxisState();
}

/// State class of the chart with multiple axes.
class _MultipleAxisState extends SampleViewState {
  _MultipleAxisState();

  @override
  Widget build(BuildContext context) {
    return getMultipleAxisLineChart();
  }

  /// Returns the chart with multiple axes.
  SfCartesianChart getMultipleAxisLineChart() {
    return SfCartesianChart(
      title: ChartTitle(
          text: isCardView ? '' : 'Washington vs New York temperature'),
      legend: Legend(isVisible: isCardView ? false : true),
      /// API for multiple axis. It can returns the various axis to the chart.
      axes: <ChartAxis>[
        NumericAxis(
            opposedPosition: true,
            name: 'yAxis1',
            majorGridLines: MajorGridLines(width: 0),
            labelFormat: '{value}°F',
            minimum: 40,
            maximum: 100,
            interval: 10)
      ],
      primaryXAxis: DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
          title: AxisTitle(textStyle: const TextStyle(color: Colors.black))),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        opposedPosition: false,
        minimum: 0,
        maximum: 50,
        interval: 10,
        labelFormat: '{value}°C',
      ),
      series: getMultipleAxisLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the multiple axes chart.
  List<ChartSeries<ChartSampleData, DateTime>> getMultipleAxisLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2019, 5, 1), y: 13, yValue2: 69.8),
      ChartSampleData(x: DateTime(2019, 5, 2), y: 26, yValue2: 87.8),
      ChartSampleData(x: DateTime(2019, 5, 3), y: 13, yValue2: 78.8),
      ChartSampleData(x: DateTime(2019, 5, 4), y: 22, yValue2: 75.2),
      ChartSampleData(x: DateTime(2019, 5, 5), y: 14, yValue2: 68),
      ChartSampleData(x: DateTime(2019, 5, 6), y: 23, yValue2: 78.8),
      ChartSampleData(x: DateTime(2019, 5, 7), y: 21, yValue2: 80.6),
      ChartSampleData(x: DateTime(2019, 5, 8), y: 22, yValue2: 73.4),
      ChartSampleData(x: DateTime(2019, 5, 9), y: 16, yValue2: 78.8),
    ];
    return <ChartSeries<ChartSampleData, DateTime>>[
      ColumnSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'New York'),
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          yAxisName: 'yAxis1',
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          name: 'Washington')
    ];
  }
}