/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the rounded corner bar chart sample.
class BarRounded extends SampleView {
  /// Creates the rounded corner bar chart sample.
  const BarRounded(Key key) : super(key: key);

  @override
  _BarRoundedState createState() => _BarRoundedState();
}

/// State class of the rounded bar chart.
class _BarRoundedState extends SampleViewState {
  _BarRoundedState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRoundedBarChart();
  }

  /// Returns the rounded cartesian bar chart.
  SfCartesianChart _buildRoundedBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Population growth rate of countries'),
      primaryXAxis:
          CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: -2,
          maximum: 2,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getRoundedBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series
  /// which need to render on the rounded bar chart.
  List<BarSeries<ChartSampleData, String>> _getRoundedBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Iceland', y: 1.13),
      ChartSampleData(x: 'Moldova', y: -1.05),
      ChartSampleData(x: 'Malaysia', y: 1.37),
      ChartSampleData(x: 'American Samoa', y: -1.3),
      ChartSampleData(x: 'Singapore', y: 1.82),
      ChartSampleData(x: 'Puerto Rico', y: -1.74),
      ChartSampleData(x: 'Algeria', y: 1.7)
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: chartData,

        /// If we set the border radius value for bar series,
        /// then the series will appear as rounder corner.
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}
