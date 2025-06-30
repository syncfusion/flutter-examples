/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default Spline Chart sample.
class SplineDefault extends SampleView {
  const SplineDefault(Key key) : super(key: key);

  @override
  _SplineDefaultState createState() => _SplineDefaultState();
}

/// State class of the default Spline Chart.
class _SplineDefaultState extends SampleViewState {
  _SplineDefaultState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'Jan',
        y: 43,
        secondSeriesYValue: 37,
        thirdSeriesYValue: 41,
      ),
      ChartSampleData(
        x: 'Feb',
        y: 45,
        secondSeriesYValue: 37,
        thirdSeriesYValue: 45,
      ),
      ChartSampleData(
        x: 'Mar',
        y: 50,
        secondSeriesYValue: 39,
        thirdSeriesYValue: 48,
      ),
      ChartSampleData(
        x: 'Apr',
        y: 55,
        secondSeriesYValue: 43,
        thirdSeriesYValue: 52,
      ),
      ChartSampleData(
        x: 'May',
        y: 63,
        secondSeriesYValue: 48,
        thirdSeriesYValue: 57,
      ),
      ChartSampleData(
        x: 'Jun',
        y: 68,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 61,
      ),
      ChartSampleData(
        x: 'Jul',
        y: 72,
        secondSeriesYValue: 57,
        thirdSeriesYValue: 66,
      ),
      ChartSampleData(
        x: 'Aug',
        y: 70,
        secondSeriesYValue: 57,
        thirdSeriesYValue: 66,
      ),
      ChartSampleData(
        x: 'Sep',
        y: 66,
        secondSeriesYValue: 54,
        thirdSeriesYValue: 63,
      ),
      ChartSampleData(
        x: 'Oct',
        y: 57,
        secondSeriesYValue: 48,
        thirdSeriesYValue: 55,
      ),
      ChartSampleData(
        x: 'Nov',
        y: 50,
        secondSeriesYValue: 43,
        thirdSeriesYValue: 50,
      ),
      ChartSampleData(
        x: 'Dec',
        y: 45,
        secondSeriesYValue: 37,
        thirdSeriesYValue: 45,
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
      title: ChartTitle(
        text: isCardView ? '' : 'Average high/low temperature of London',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 30,
        maximum: 80,
        axisLine: AxisLine(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelFormat: '{value}°F',
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildSplineSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Spline series.
  List<SplineSeries<ChartSampleData, String>> _buildSplineSeries() {
    return <SplineSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'High',
      ),
      SplineSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Low',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
