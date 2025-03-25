/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Range Column Chart with tracker.
class RangeColumnWithTrack extends SampleView {
  const RangeColumnWithTrack(Key key) : super(key: key);

  @override
  _RangeColumnWithTrackState createState() => _RangeColumnWithTrackState();
}

/// State class of Range Column Chart with tracker.
class _RangeColumnWithTrackState extends SampleViewState {
  _RangeColumnWithTrackState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      header: '',
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'Day 1', y: 3, yValue: 5),
      ChartSampleData(x: 'Day 2', y: 4, yValue: 7),
      ChartSampleData(x: 'Day 3', y: 4, yValue: 8),
      ChartSampleData(x: 'Day 4', y: 2, yValue: 5),
      ChartSampleData(x: 'Day 5', y: 5, yValue: 7),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Range Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Meeting timings of an employee',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        minimum: 1,
        maximum: 10,
        labelFormat: '{value} PM',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildRangeColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Range Column series.
  List<RangeColumnSeries<ChartSampleData, String>> _buildRangeColumnSeries() {
    return <RangeColumnSeries<ChartSampleData, String>>[
      RangeColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        lowValueMapper: (ChartSampleData sales, int index) => sales.y,
        highValueMapper: (ChartSampleData sales, int index) => sales.yValue,

        /// To enable tracker for range column using this property.
        isTrackVisible: true,
        trackColor: const Color.fromRGBO(198, 201, 207, 1),
        borderRadius: BorderRadius.circular(15),
        trackBorderColor: Colors.grey[100]!,
        dataLabelSettings: DataLabelSettings(
          isVisible: !isCardView,
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
