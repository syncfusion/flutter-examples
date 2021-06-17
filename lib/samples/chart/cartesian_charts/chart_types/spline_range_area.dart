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

  @override
  Widget build(BuildContext context) {
    return _buildSplineRangeAreaChart();
  }

  ///Get chart with spline range area chart
  SfCartesianChart _buildSplineRangeAreaChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Product price comparison'),
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelPlacement: LabelPlacement.onTicks),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 60,
          axisLine: const AxisLine(width: 0),
          labelFormat: r'${value}',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getSplineAreaSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the spline range area chart.
  List<SplineRangeAreaSeries<ChartSampleData, String>> _getSplineAreaSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Jan',
          y: 45,
          yValue: 32,
          secondSeriesYValue: 30,
          thirdSeriesYValue: 18),
      ChartSampleData(
          x: 'Feb',
          y: 48,
          yValue: 34,
          secondSeriesYValue: 24,
          thirdSeriesYValue: 12),
      ChartSampleData(
          x: 'Mar',
          y: 46,
          yValue: 32,
          secondSeriesYValue: 29,
          thirdSeriesYValue: 15),
      ChartSampleData(
          x: 'Apr',
          y: 48,
          yValue: 36,
          secondSeriesYValue: 24,
          thirdSeriesYValue: 10),
      ChartSampleData(
          x: 'May',
          y: 46,
          yValue: 32,
          secondSeriesYValue: 30,
          thirdSeriesYValue: 18),
      ChartSampleData(
          x: 'Jun',
          y: 49,
          yValue: 34,
          secondSeriesYValue: 24,
          thirdSeriesYValue: 10)
    ];
    return <SplineRangeAreaSeries<ChartSampleData, String>>[
      SplineRangeAreaSeries<ChartSampleData, String>(
        dataSource: chartData,
        color: const Color.fromRGBO(75, 135, 185, 0.5),
        borderColor: const Color.fromRGBO(75, 135, 185, 1),
        borderWidth: 3,
        borderDrawMode: RangeAreaBorderMode.excludeSides,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        highValueMapper: (ChartSampleData sales, _) => sales.y,
        lowValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Product A',
      ),
      SplineRangeAreaSeries<ChartSampleData, String>(
        dataSource: chartData,
        borderColor: const Color.fromRGBO(192, 108, 132, 1),
        color: const Color.fromRGBO(192, 108, 132, 0.5),
        borderWidth: 3,
        borderDrawMode: RangeAreaBorderMode.excludeSides,
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        highValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
        lowValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
        name: 'Product B',
      )
    ];
  }
}
