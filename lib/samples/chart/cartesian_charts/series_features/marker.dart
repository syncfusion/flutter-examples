/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the chart with various marker shapes sample.
class MarkerDefault extends SampleView {
  /// Creates the chart with various marker shapes sample.
  const MarkerDefault(Key key) : super(key: key);

  @override
  _MarkerDefaultState createState() => _MarkerDefaultState();
}

/// State class of the chart with various marker shapes.
class _MarkerDefaultState extends SampleViewState {
  _MarkerDefaultState();

  @override
  Widget build(BuildContext context) {
    return _buildMarkerDefaultChart();
  }

  /// Returns the chart with various marker shapes.
  SfCartesianChart _buildMarkerDefaultChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Vehicles crossed tollgate'),
      legend: Legend(isVisible: true),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        dateFormat: DateFormat.Hm(),
        title: AxisTitle(text: 'Time'),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Count'),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getMarkeSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart which need to
  /// render on the chart with various marker shapes.
  List<LineSeries<ChartSampleData, DateTime>> _getMarkeSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: DateTime(2018, 3, 1, 8, 0),
          y: 60,
          secondSeriesYValue: 28,
          thirdSeriesYValue: 15),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 8, 30),
          y: 49,
          secondSeriesYValue: 40,
          thirdSeriesYValue: 28),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 9, 0),
          y: 70,
          secondSeriesYValue: 32,
          thirdSeriesYValue: 16),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 9, 30),
          y: 56,
          secondSeriesYValue: 36,
          thirdSeriesYValue: 66),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 10, 0),
          y: 66,
          secondSeriesYValue: 50,
          thirdSeriesYValue: 26),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 10, 30),
          y: 50,
          secondSeriesYValue: 35,
          thirdSeriesYValue: 14),
      ChartSampleData(
          x: DateTime(2018, 3, 1, 11, 0),
          y: 55,
          secondSeriesYValue: 32,
          thirdSeriesYValue: 20),
    ];
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        width: 2,
        name: 'Truck',
        markerSettings: const MarkerSettings(
            isVisible: true,

            /// To return the marker shape to marker settings.
            shape: DataMarkerType.pentagon,
            image: AssetImage('images/truck.png')),
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
        name: 'Bike',
        markerSettings: const MarkerSettings(
            isVisible: true, shape: DataMarkerType.triangle),
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
        name: 'Car',
        markerSettings: const MarkerSettings(
            isVisible: true, shape: DataMarkerType.rectangle),
      )
    ];
  }
}
