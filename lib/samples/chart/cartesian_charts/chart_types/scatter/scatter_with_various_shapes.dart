/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the scatter chart with various shapes sample.
class ScatterShapes extends SampleView {
  /// Creates the scatter series with various shapes sample.
  const ScatterShapes(Key key) : super(key: key);

  @override
  _ScatterShapesState createState() => _ScatterShapesState();
}

/// State class of scatter chart with various shapes.
class _ScatterShapesState extends SampleViewState {
  _ScatterShapesState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildShapesScatterChart();
  }

  /// Returns the scatter chart with various shapes.
  SfCartesianChart _buildShapesScatterChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Inflation Analysis'),
      primaryXAxis: NumericAxis(
        minimum: 1945,
        maximum: 2005,
        title: AxisTitle(text: isCardView ? '' : 'Year'),
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      legend: Legend(isVisible: !isCardView),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Inflation Rate(%)'),
          labelFormat: '{value}%',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      tooltipBehavior: _tooltipBehavior,
      series: _getScatterShapesSeries(),
    );
  }

  /// Returns the list of chart series with various marker shapes which need to
  /// render on the scatter chart.
  List<ScatterSeries<ChartSampleData, num>> _getScatterShapesSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 1950, y: 0.8, secondSeriesYValue: 1.4, thirdSeriesYValue: 2),
      ChartSampleData(
          x: 1955, y: 1.2, secondSeriesYValue: 1.7, thirdSeriesYValue: 2.4),
      ChartSampleData(
          x: 1960, y: 0.9, secondSeriesYValue: 1.5, thirdSeriesYValue: 2.2),
      ChartSampleData(
          x: 1965, y: 1, secondSeriesYValue: 1.6, thirdSeriesYValue: 2.5),
      ChartSampleData(
          x: 1970, y: 0.8, secondSeriesYValue: 1.4, thirdSeriesYValue: 2.2),
      ChartSampleData(
          x: 1975, y: 1, secondSeriesYValue: 1.8, thirdSeriesYValue: 2.4),
      ChartSampleData(
          x: 1980, y: 1, secondSeriesYValue: 1.7, thirdSeriesYValue: 2),
      ChartSampleData(
          x: 1985, y: 1.2, secondSeriesYValue: 1.9, thirdSeriesYValue: 2.3),
      ChartSampleData(
          x: 1990, y: 1.1, secondSeriesYValue: 1.4, thirdSeriesYValue: 2),
      ChartSampleData(
          x: 1995, y: 1.2, secondSeriesYValue: 1.8, thirdSeriesYValue: 2.2),
      ChartSampleData(
          x: 2000, y: 1.4, secondSeriesYValue: 2, thirdSeriesYValue: 2.4),
    ];
    return <ScatterSeries<ChartSampleData, num>>[
      ScatterSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          markerSettings: const MarkerSettings(
              width: 15, height: 15, shape: DataMarkerType.diamond),
          name: 'India'),
      ScatterSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          markerSettings: const MarkerSettings(
              width: 15, height: 15, shape: DataMarkerType.triangle),
          name: 'China'),
      ScatterSeries<ChartSampleData, num>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          markerSettings: const MarkerSettings(
              width: 15, height: 15, shape: DataMarkerType.pentagon),
          name: 'Japan')
    ];
  }
}
