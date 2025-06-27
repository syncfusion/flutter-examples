/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the line series chart with various marker shapes sample.
class MarkerDefault extends SampleView {
  /// Creates the line series chart with various marker shapes sample.
  const MarkerDefault(Key key) : super(key: key);

  @override
  _MarkerDefaultState createState() => _MarkerDefaultState();
}

/// State class for the line series chart with
/// various marker shapes.
class _MarkerDefaultState extends SampleViewState {
  _MarkerDefaultState();

  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: DateTime(2018, 3, 1, 8),
        y: 60,
        secondSeriesYValue: 28,
        thirdSeriesYValue: 15,
      ),
      ChartSampleData(
        x: DateTime(2018, 3, 1, 8, 30),
        y: 49,
        secondSeriesYValue: 40,
        thirdSeriesYValue: 28,
      ),
      ChartSampleData(
        x: DateTime(2018, 3, 1, 9),
        y: 70,
        secondSeriesYValue: 32,
        thirdSeriesYValue: 16,
      ),
      ChartSampleData(
        x: DateTime(2018, 3, 1, 9, 30),
        y: 56,
        secondSeriesYValue: 36,
        thirdSeriesYValue: 66,
      ),
      ChartSampleData(
        x: DateTime(2018, 3, 1, 10),
        y: 66,
        secondSeriesYValue: 50,
        thirdSeriesYValue: 26,
      ),
      ChartSampleData(
        x: DateTime(2018, 3, 1, 10, 30),
        y: 50,
        secondSeriesYValue: 35,
        thirdSeriesYValue: 14,
      ),
      ChartSampleData(
        x: DateTime(2018, 3, 1, 11),
        y: 55,
        secondSeriesYValue: 32,
        thirdSeriesYValue: 20,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMarkerDefaultChart();
  }

  /// Returns a cartesian line chart with various marker shapes.
  SfCartesianChart _buildMarkerDefaultChart() {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Vehicles crossed tollgate'),
      legend: const Legend(isVisible: true),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        dateFormat: DateFormat.Hm(),
        title: const AxisTitle(text: 'Time'),
      ),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(text: 'Count'),
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of cartesian line series.
  List<LineSeries<ChartSampleData, DateTime>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'Truck',
        markerSettings: const MarkerSettings(
          isVisible: true,

          /// To return the marker shape to marker settings.
          shape: DataMarkerType.pentagon,
          image: AssetImage('images/truck.png'),
        ),
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        name: 'Bike',
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.triangle,
        ),
      ),
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        name: 'Car',
        markerSettings: const MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.rectangle,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
