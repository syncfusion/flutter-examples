/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the bar chart sample with tracker.
class BarTracker extends SampleView {
  /// Creates the bar chart sample with tracker.
  const BarTracker(Key key) : super(key: key);

  @override
  _BarTrackerState createState() => _BarTrackerState();
}

/// State class of tracker bar chart.
class _BarTrackerState extends SampleViewState {
  _BarTrackerState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackerBarChart();
  }

  /// Returns the bar chart with trackers.
  SfCartesianChart _buildTrackerBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Working hours of employees'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          title: AxisTitle(text: isCardView ? '' : 'Hours'),
          minimum: 0,
          maximum: 8,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getTrackerBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the lsit of chart series
  /// which need to render on the bar chart with trackers.
  List<BarSeries<ChartSampleData, String>> _getTrackerBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Mike', y: 7.5),
      ChartSampleData(x: 'Chris', y: 7),
      ChartSampleData(x: 'Helana', y: 6),
      ChartSampleData(x: 'Tom', y: 5),
      ChartSampleData(x: 'Federer', y: 7),
      ChartSampleData(x: 'Hussain', y: 7),
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: chartData,
        borderRadius: BorderRadius.circular(15),
        trackColor: const Color.fromRGBO(198, 201, 207, 1),

        /// If we enable this property as true,
        /// then we can show the track of series.
        isTrackVisible: true,
        dataLabelSettings: DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}
