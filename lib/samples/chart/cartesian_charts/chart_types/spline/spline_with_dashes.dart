/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the dashed Spline Chart.
class SplineDashed extends SampleView {
  const SplineDashed(Key key) : super(key: key);

  @override
  _SplineDashedState createState() => _SplineDashedState();
}

/// State class of the dashed Spline Chart.
class _SplineDashedState extends SampleViewState {
  _SplineDashedState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 1997,
        y: 17.79,
        secondSeriesYValue: 20.32,
        thirdSeriesYValue: 22.44,
      ),
      ChartSampleData(
        x: 1998,
        y: 18.20,
        secondSeriesYValue: 21.46,
        thirdSeriesYValue: 25.18,
      ),
      ChartSampleData(
        x: 1999,
        y: 17.44,
        secondSeriesYValue: 21.72,
        thirdSeriesYValue: 24.15,
      ),
      ChartSampleData(
        x: 2000,
        y: 19,
        secondSeriesYValue: 22.86,
        thirdSeriesYValue: 25.83,
      ),
      ChartSampleData(
        x: 2001,
        y: 18.93,
        secondSeriesYValue: 22.87,
        thirdSeriesYValue: 25.69,
      ),
      ChartSampleData(
        x: 2002,
        y: 17.58,
        secondSeriesYValue: 21.87,
        thirdSeriesYValue: 24.75,
      ),
      ChartSampleData(
        x: 2003,
        y: 16.83,
        secondSeriesYValue: 21.67,
        thirdSeriesYValue: 27.38,
      ),
      ChartSampleData(
        x: 2004,
        y: 17.93,
        secondSeriesYValue: 21.65,
        thirdSeriesYValue: 25.31,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Spline series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Total investment (% of GDP)'),
      primaryXAxis: const NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        interval: 1,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 16,
        maximum: 28,
        interval: 4,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
      ),
      series: _buildSplineSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<SplineSeries<ChartSampleData, num>> _buildSplineSeries() {
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,

        /// To apply the dashes line for spline.
        dashArray: const <double>[12, 3, 3, 3],
        name: 'Brazil',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      SplineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        dashArray: const <double>[12, 3, 3, 3],
        name: 'Sweden',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      SplineSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.thirdSeriesYValue,
        dashArray: const <double>[12, 3, 3, 3],
        name: 'Greece',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
