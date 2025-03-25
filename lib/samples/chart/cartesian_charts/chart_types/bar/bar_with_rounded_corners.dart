/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the rounded corner Bar Chart sample.
class BarRounded extends SampleView {
  const BarRounded(Key key) : super(key: key);

  @override
  _BarRoundedState createState() => _BarRoundedState();
}

/// State class of the rounded Bar Chart.
class _BarRoundedState extends SampleViewState {
  _BarRoundedState();

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
      ChartSampleData(x: 'Iceland', y: 1.13),
      ChartSampleData(x: 'Moldova', y: -1.05),
      ChartSampleData(x: 'Malaysia', y: 1.37),
      ChartSampleData(x: 'American Samoa', y: -1.3),
      ChartSampleData(x: 'Singapore', y: 1.82),
      ChartSampleData(x: 'Puerto Rico', y: -1.74),
      ChartSampleData(x: 'Algeria', y: 1.7),
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
      title: ChartTitle(
        text: isCardView ? '' : 'Population growth rate of countries',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        minimum: -2,
        maximum: 2,
        majorTickLines: MajorTickLines(size: 0),
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

        /// If we set the border radius value for Bar series,
        /// then the series will appear as rounder corner.
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
