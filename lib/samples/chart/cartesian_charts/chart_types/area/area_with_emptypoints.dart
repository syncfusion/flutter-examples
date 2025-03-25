/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Area with empty points Chart sample.
class AreaEmpty extends SampleView {
  const AreaEmpty(Key key) : super(key: key);

  @override
  _AreaEmptyState createState() => _AreaEmptyState();
}

/// State class for the Area with empty point Chart.
class _AreaEmptyState extends SampleViewState {
  _AreaEmptyState();

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
      ChartSampleData(x: 2002, y: 220000000),
      ChartSampleData(x: 2003, y: 340000000),
      ChartSampleData(x: 2004, y: 280000000),

      /// Data for empty point.
      ChartSampleData(x: 2005),
      ChartSampleData(x: 2006),
      ChartSampleData(x: 2007, y: 250000000),
      ChartSampleData(x: 2008, y: 290000000),
      ChartSampleData(x: 2009, y: 380000000),
      ChartSampleData(x: 2010, y: 140000000),
      ChartSampleData(x: 2011, y: 310000000),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Area series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Inflation rate of US'),
      primaryXAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        interval: 1,
      ),
      primaryYAxis: NumericAxis(
        minimum: 100000000,
        maximum: 500000000,
        title: AxisTitle(text: isCardView ? '' : 'Rates'),
        numberFormat: NumberFormat.compact(),
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildAreaSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Area series.
  List<AreaSeries<ChartSampleData, num>> _buildAreaSeries() {
    return <AreaSeries<ChartSampleData, num>>[
      AreaSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
