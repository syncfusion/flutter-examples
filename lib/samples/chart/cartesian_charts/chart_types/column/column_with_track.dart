/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders column chart with trackers
class ColumnTracker extends SampleView {
  /// Renders column chart with trackers
  const ColumnTracker(Key key) : super(key: key);

  @override
  _ColumnTrackerState createState() => _ColumnTrackerState();
}

class _ColumnTrackerState extends SampleViewState {
  _ColumnTrackerState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: '',
        format: 'point.y marks in point.x');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackerColumnChart();
  }

  /// Get column series with track
  SfCartesianChart _buildTrackerColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Marks of a student'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getTracker(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Get column series with tracker
  List<ColumnSeries<ChartSampleData, String>> _getTracker() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Subject 1', y: 71),
      ChartSampleData(x: 'Subject 2', y: 84),
      ChartSampleData(x: 'Subject 3', y: 48),
      ChartSampleData(x: 'Subject 4', y: 80),
      ChartSampleData(x: 'Subject 5', y: 76),
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: chartData,

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: const Color.fromRGBO(198, 201, 207, 1),
          borderRadius: BorderRadius.circular(15),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Marks',
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: const TextStyle(fontSize: 10, color: Colors.white)))
    ];
  }
}
