/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the rounded bar chart sample.
class BarRounded extends SampleView {
  const BarRounded(Key key) : super(key: key);

  @override
  _BarRoundedState createState() => _BarRoundedState();
}

/// State class of the rounded bar chart.
class _BarRoundedState extends SampleViewState {
  _BarRoundedState();

  @override
  Widget build(BuildContext context) {
    return getRoundedBarChart();
  }

  /// Returns the rounded cartesian bar chart.
  SfCartesianChart getRoundedBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Population growth rate of countries'),
      primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          minimum: -2, maximum: 2, majorTickLines: MajorTickLines(size: 0)),
      series: getRoundedBarSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on the rounded bar chart.
  List<BarSeries<ChartSampleData, String>> getRoundedBarSeries() {
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
        enableTooltip: true,
        dataSource: chartData,
        /// If we set the border radius value for bar series, then the series will appear as rounder corner.
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}