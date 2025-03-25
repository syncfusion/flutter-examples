/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the stacked area 100 series chart sample.
class StackedArea100Chart extends SampleView {
  /// Creates the stacked area 100 series chart sample.
  const StackedArea100Chart(Key key) : super(key: key);

  @override
  _StackedAreaChartState createState() => _StackedAreaChartState();
}

/// State class for the stacked area 100 series chart.
class _StackedAreaChartState extends SampleViewState {
  _StackedAreaChartState();

  List<_ChartData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _chartData = <_ChartData>[
      _ChartData(DateTime(2000), 0.61, 0.03, 0.48, 0.23),
      _ChartData(DateTime(2001), 0.81, 0.05, 0.53, 0.17),
      _ChartData(DateTime(2002), 0.91, 0.06, 0.57, 0.17),
      _ChartData(DateTime(2003), 1.00, 0.09, 0.61, 0.20),
      _ChartData(DateTime(2004), 1.19, 0.14, 0.63, 0.23),
      _ChartData(DateTime(2005), 1.47, 0.20, 0.64, 0.36),
      _ChartData(DateTime(2006), 1.74, 0.29, 0.66, 0.43),
      _ChartData(DateTime(2007), 1.98, 0.46, 0.76, 0.52),
      _ChartData(DateTime(2008), 1.99, 0.64, 0.77, 0.72),
      _ChartData(DateTime(2009), 1.70, 0.75, 0.55, 1.29),
      _ChartData(DateTime(2010), 1.48, 1.06, 0.54, 1.38),
      _ChartData(DateTime(2011), 1.38, 1.25, 0.57, 1.82),
      _ChartData(DateTime(2012), 1.66, 1.55, 0.61, 2.16),
      _ChartData(DateTime(2013), 1.66, 1.55, 0.67, 2.51),
      _ChartData(DateTime(2014), 1.67, 1.65, 0.67, 2.61),
      _ChartData(DateTime(2015), 1.98, 1.96, 0.98, 2.93),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedArea100Chart();
  }

  /// Returns the stacked area 100 chart.
  SfCartesianChart _buildStackedArea100Chart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Sales comparison of fruits in a shop',
      ),
      legend: Legend(
        isVisible: !isCardView,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y(),
      ),
      primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.none,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildStackedArea100Series(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian stacked area 100 series.
  List<CartesianSeries<_ChartData, DateTime>> _buildStackedArea100Series() {
    return <CartesianSeries<_ChartData, DateTime>>[
      StackedArea100Series<_ChartData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.organic,
        name: 'Apple',
      ),
      StackedArea100Series<_ChartData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.fairTrade,
        name: 'Orange',
      ),
      StackedArea100Series<_ChartData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.veg,
        name: 'Pears',
      ),
      StackedArea100Series<_ChartData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (_ChartData data, int index) => data.x,
        yValueMapper: (_ChartData data, int index) => data.others,
        name: 'Others',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

/// Private class for storing the stacked area 100 series data points.
class _ChartData {
  _ChartData(this.x, this.organic, this.fairTrade, this.veg, this.others);
  final DateTime x;
  final num organic;
  final num fairTrade;
  final num veg;
  final num others;
}
