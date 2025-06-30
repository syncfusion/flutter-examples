/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the spline range area chart sample.
class SplineRangeArea extends SampleView {
  /// Creates the spline area chart sample.
  const SplineRangeArea(Key key) : super(key: key);

  @override
  _SplineRangeAreaState createState() => _SplineRangeAreaState();
}

class _SplineRangeAreaState extends SampleViewState {
  _SplineRangeAreaState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Jan',
        y: 45,
        yValue: 32,
        secondSeriesYValue: 30,
        thirdSeriesYValue: 18,
      ),
      ChartSampleData(
        x: 'Feb',
        y: 48,
        yValue: 34,
        secondSeriesYValue: 24,
        thirdSeriesYValue: 12,
      ),
      ChartSampleData(
        x: 'Mar',
        y: 46,
        yValue: 32,
        secondSeriesYValue: 29,
        thirdSeriesYValue: 15,
      ),
      ChartSampleData(
        x: 'Apr',
        y: 48,
        yValue: 36,
        secondSeriesYValue: 24,
        thirdSeriesYValue: 10,
      ),
      ChartSampleData(
        x: 'May',
        y: 46,
        yValue: 32,
        secondSeriesYValue: 30,
        thirdSeriesYValue: 18,
      ),
      ChartSampleData(
        x: 'Jun',
        y: 49,
        yValue: 34,
        secondSeriesYValue: 24,
        thirdSeriesYValue: 10,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplineRangeAreaChart();
  }

  /// Returns the cartesian spline range area chart.
  SfCartesianChart _buildSplineRangeAreaChart() {
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: const ChartTitle(text: 'Product price comparison'),
      legend: const Legend(isVisible: true),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 60,
        axisLine: AxisLine(width: 0),
        labelFormat: r'${value}',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildSplineAreaSeries(
        themeData.useMaterial3,
        themeData.brightness == Brightness.light,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of cartesian spline area series.
  List<SplineRangeAreaSeries<ChartSampleData, String>> _buildSplineAreaSeries(
    bool isMaterial3,
    bool isLightMode,
  ) {
    final Color seriesColor1 = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(6, 174, 224, 1)
              : const Color.fromRGBO(255, 245, 0, 1))
        : const Color.fromRGBO(75, 135, 185, 1);
    final Color seriesColor2 = isMaterial3
        ? (isLightMode
              ? const Color.fromRGBO(99, 85, 199, 1)
              : const Color.fromRGBO(51, 182, 119, 1))
        : const Color.fromRGBO(192, 108, 132, 1);
    return <SplineRangeAreaSeries<ChartSampleData, String>>[
      SplineRangeAreaSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        highValueMapper: (ChartSampleData data, int index) => data.y,
        lowValueMapper: (ChartSampleData data, int index) => data.yValue,
        color: seriesColor1.withValues(alpha: 0.5),
        borderColor: seriesColor1,
        borderDrawMode: RangeAreaBorderMode.excludeSides,
        name: 'Product A',
      ),
      SplineRangeAreaSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        highValueMapper: (ChartSampleData data, int index) =>
            data.secondSeriesYValue,
        lowValueMapper: (ChartSampleData data, int index) =>
            data.thirdSeriesYValue,
        color: seriesColor2.withValues(alpha: 0.5),
        borderColor: seriesColor2,
        borderDrawMode: RangeAreaBorderMode.excludeSides,
        name: 'Product B',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
