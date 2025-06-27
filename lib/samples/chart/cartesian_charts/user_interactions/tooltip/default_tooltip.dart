/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders a line series chart with default tooltip.
class DefaultTooltip extends SampleView {
  /// Creates a line series chart with default tooltip.
  const DefaultTooltip(Key key) : super(key: key);

  @override
  _DefaultTooltipState createState() => _DefaultTooltipState();
}

/// State class for the line series chart with default tooltip.
class _DefaultTooltipState extends SampleViewState {
  _DefaultTooltipState();
  late List<ChartSampleData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 2004, y: 42.630000, secondSeriesYValue: 34.730000),
      ChartSampleData(x: 2005, y: 43.320000, secondSeriesYValue: 43.400000),
      ChartSampleData(x: 2006, y: 43.660000, secondSeriesYValue: 38.090000),
      ChartSampleData(x: 2007, y: 43.540000, secondSeriesYValue: 44.710000),
      ChartSampleData(x: 2008, y: 43.600000, secondSeriesYValue: 45.320000),
      ChartSampleData(x: 2009, y: 43.500000, secondSeriesYValue: 46.200000),
      ChartSampleData(x: 2010, y: 43.350000, secondSeriesYValue: 46.990000),
      ChartSampleData(x: 2011, y: 43.620000, secondSeriesYValue: 49.170000),
      ChartSampleData(x: 2012, y: 43.930000, secondSeriesYValue: 50.640000),
      ChartSampleData(x: 2013, y: 44.200000, secondSeriesYValue: 51.480000),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultTooltipChart();
  }

  /// Returns a cartesian line chart with default tooltip.
  SfCartesianChart _buildDefaultTooltipChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Labour force'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: NumericAxis(
        minimum: 2004,
        maximum: 2013,
        title: AxisTitle(text: isCardView ? '' : 'Year'),
        majorGridLines: const MajorGridLines(width: 0),
        interval: 1,
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}M',
        minimum: 30,
        maximum: 60,
        axisLine: AxisLine(width: 0),
      ),
      series: _buildLineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list cartesian line series.
  List<LineSeries<ChartSampleData, num>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        name: 'Germany',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        name: 'Mexico',
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}
