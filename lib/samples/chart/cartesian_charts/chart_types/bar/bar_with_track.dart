/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Bar Chart sample with tracker.
class BarTracker extends SampleView {
  const BarTracker(Key key) : super(key: key);

  @override
  _BarTrackerState createState() => _BarTrackerState();
}

/// State class of tracker Bar Chart.
class _BarTrackerState extends SampleViewState {
  _BarTrackerState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Mike', y: 7.5),
      ChartSampleData(x: 'Chris', y: 7),
      ChartSampleData(x: 'Helana', y: 6),
      ChartSampleData(x: 'Tom', y: 5),
      ChartSampleData(x: 'Federer', y: 7),
      ChartSampleData(x: 'Hussain', y: 7),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Bar series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Working hours of employees'),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        title: AxisTitle(text: isCardView ? '' : 'Hours'),
        minimum: 0,
        maximum: 8,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Bar series.
  List<BarSeries<ChartSampleData, String>> _buildBarSeries() {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,

        /// Enable this property as true to show the track of series.
        isTrackVisible: true,
        trackColor: const Color.fromRGBO(198, 201, 207, 1),
        borderRadius: BorderRadius.circular(15),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
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
