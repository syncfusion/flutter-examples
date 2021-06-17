/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the area with empty points chart sample.
class AreaEmpty extends SampleView {
  /// Creates the area with empty points chart sample.
  const AreaEmpty(Key key) : super(key: key);

  @override
  _AreaEmptyState createState() => _AreaEmptyState();
}

/// State class for the area with empty point chart.
class _AreaEmptyState extends SampleViewState {
  _AreaEmptyState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildEmptyPointAreaChart();
  }

  /// Returns the the Cartesian area chart with emptypoints.
  SfCartesianChart _buildEmptyPointAreaChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Inflation rate of US'),
      primaryXAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        interval: 1,
      ),
      primaryYAxis: NumericAxis(
          minimum: 100000000,
          maximum: 500000000,
          title: AxisTitle(text: isCardView ? '' : 'Rates'),
          numberFormat: NumberFormat.compact(),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getEmptyPointAreaSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series
  /// which need to render on the emptypoints area chart.
  List<AreaSeries<ChartSampleData, num>> _getEmptyPointAreaSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 2002, y: 220000000),
      ChartSampleData(x: 2003, y: 340000000),
      ChartSampleData(x: 2004, y: 280000000),

      /// Data for empty point.
      ChartSampleData(x: 2005, y: null),
      ChartSampleData(x: 2006, y: null),
      ChartSampleData(x: 2007, y: 250000000),
      ChartSampleData(x: 2008, y: 290000000),
      ChartSampleData(x: 2009, y: 380000000),
      ChartSampleData(x: 2010, y: 140000000),
      ChartSampleData(x: 2011, y: 310000000),
    ];
    return <AreaSeries<ChartSampleData, num>>[
      AreaSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y),
    ];
  }
}
