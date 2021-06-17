/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the dashed spline chart.
class SplineDashed extends SampleView {
  /// Creates the dashed spline chart.
  const SplineDashed(Key key) : super(key: key);

  @override
  _SplineDashedState createState() => _SplineDashedState();
}

/// State class of the dashed spline chart.
class _SplineDashedState extends SampleViewState {
  _SplineDashedState();

  @override
  Widget build(BuildContext context) {
    return _buildDashedSplineChart();
  }

  /// Returns the dashed spline chart.
  SfCartesianChart _buildDashedSplineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Total investment (% of GDP)'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        minimum: 16,
        maximum: 28,
        interval: 4,
        labelFormat: '{value}%',
        axisLine: const AxisLine(width: 0),
      ),
      series: _getDashedSplineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series
  /// which need to render on the dashed spline chart.
  List<SplineSeries<ChartSampleData, num>> _getDashedSplineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 1997,
          y: 17.79,
          secondSeriesYValue: 20.32,
          thirdSeriesYValue: 22.44),
      ChartSampleData(
          x: 1998,
          y: 18.20,
          secondSeriesYValue: 21.46,
          thirdSeriesYValue: 25.18),
      ChartSampleData(
          x: 1999,
          y: 17.44,
          secondSeriesYValue: 21.72,
          thirdSeriesYValue: 24.15),
      ChartSampleData(
          x: 2000, y: 19, secondSeriesYValue: 22.86, thirdSeriesYValue: 25.83),
      ChartSampleData(
          x: 2001,
          y: 18.93,
          secondSeriesYValue: 22.87,
          thirdSeriesYValue: 25.69),
      ChartSampleData(
          x: 2002,
          y: 17.58,
          secondSeriesYValue: 21.87,
          thirdSeriesYValue: 24.75),
      ChartSampleData(
          x: 2003,
          y: 16.83,
          secondSeriesYValue: 21.67,
          thirdSeriesYValue: 27.38),
      ChartSampleData(
          x: 2004,
          y: 17.93,
          secondSeriesYValue: 21.65,
          thirdSeriesYValue: 25.31)
    ];
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2,
          name: 'Brazil',

          /// To apply the dashes line for spline.
          dashArray: const <double>[12, 3, 3, 3],
          markerSettings: const MarkerSettings(isVisible: true)),
      SplineSeries<ChartSampleData, num>(
          dataSource: chartData,
          width: 2,
          name: 'Sweden',
          dashArray: const <double>[12, 3, 3, 3],
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          markerSettings: const MarkerSettings(isVisible: true)),
      SplineSeries<ChartSampleData, num>(
          dataSource: chartData,
          width: 2,
          dashArray: const <double>[12, 3, 3, 3],
          name: 'Greece',
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}
