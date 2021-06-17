/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the range column chart with tracker.
class RangeColumnWithTrack extends SampleView {
  /// Creates the range column chart with tracker.
  const RangeColumnWithTrack(Key key) : super(key: key);

  @override
  _RangeColumnWithTrackState createState() => _RangeColumnWithTrackState();
}

/// State class of range column chart with tracker.
class _RangeColumnWithTrackState extends SampleViewState {
  _RangeColumnWithTrackState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, canShowMarker: false, header: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRangeColumnwithTrack();
  }

  /// Returns the range column chart with tracker.
  SfCartesianChart _buildRangeColumnwithTrack() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title:
          ChartTitle(text: isCardView ? '' : 'Meeting timings of an employee'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          minimum: 1,
          maximum: 10,
          labelFormat: '{value} PM',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getRangeColumnSerieswithTrack(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on the
  ///  range column cahrt series with tracker.
  List<RangeColumnSeries<ChartSampleData, String>>
      _getRangeColumnSerieswithTrack() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Day 1', y: 3, yValue: 5),
      ChartSampleData(x: 'Day 2', y: 4, yValue: 7),
      ChartSampleData(x: 'Day 3', y: 4, yValue: 8),
      ChartSampleData(x: 'Day 4', y: 2, yValue: 5),
      ChartSampleData(x: 'Day 5', y: 5, yValue: 7),
    ];
    return <RangeColumnSeries<ChartSampleData, String>>[
      RangeColumnSeries<ChartSampleData, String>(
          dataSource: chartData,

          /// To enable tracker for range column using this property.
          isTrackVisible: true,
          trackColor: const Color.fromRGBO(198, 201, 207, 1),
          borderRadius: BorderRadius.circular(15),
          trackBorderColor: Colors.grey[100]!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          lowValueMapper: (ChartSampleData sales, _) => sales.y,
          highValueMapper: (ChartSampleData sales, _) => sales.yValue,
          dataLabelSettings: DataLabelSettings(
              isVisible: !isCardView,
              labelAlignment: ChartDataLabelAlignment.top))
    ];
  }
}
