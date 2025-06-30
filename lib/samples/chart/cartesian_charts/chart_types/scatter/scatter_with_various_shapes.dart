/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Scatter Chart with various shapes sample.
class ScatterShapes extends SampleView {
  const ScatterShapes(Key key) : super(key: key);

  @override
  _ScatterShapesState createState() => _ScatterShapesState();
}

/// State class of Scatter Chart with various shapes.
class _ScatterShapesState extends SampleViewState {
  _ScatterShapesState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 1950,
        y: 0.8,
        secondSeriesYValue: 1.4,
        thirdSeriesYValue: 2,
      ),
      ChartSampleData(
        x: 1955,
        y: 1.2,
        secondSeriesYValue: 1.7,
        thirdSeriesYValue: 2.4,
      ),
      ChartSampleData(
        x: 1960,
        y: 0.9,
        secondSeriesYValue: 1.5,
        thirdSeriesYValue: 2.2,
      ),
      ChartSampleData(
        x: 1965,
        y: 1,
        secondSeriesYValue: 1.6,
        thirdSeriesYValue: 2.5,
      ),
      ChartSampleData(
        x: 1970,
        y: 0.8,
        secondSeriesYValue: 1.4,
        thirdSeriesYValue: 2.2,
      ),
      ChartSampleData(
        x: 1975,
        y: 1,
        secondSeriesYValue: 1.8,
        thirdSeriesYValue: 2.4,
      ),
      ChartSampleData(
        x: 1980,
        y: 1,
        secondSeriesYValue: 1.7,
        thirdSeriesYValue: 2,
      ),
      ChartSampleData(
        x: 1985,
        y: 1.2,
        secondSeriesYValue: 1.9,
        thirdSeriesYValue: 2.3,
      ),
      ChartSampleData(
        x: 1990,
        y: 1.1,
        secondSeriesYValue: 1.4,
        thirdSeriesYValue: 2,
      ),
      ChartSampleData(
        x: 1995,
        y: 1.2,
        secondSeriesYValue: 1.8,
        thirdSeriesYValue: 2.2,
      ),
      ChartSampleData(
        x: 2000,
        y: 1.4,
        secondSeriesYValue: 2,
        thirdSeriesYValue: 2.4,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Scatter series.
  SfCartesianChart _buildCartesianChart() {
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
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Inflation Rate(%)'),
        labelFormat: '{value}%',
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildScatterSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Scatter series.
  List<ScatterSeries<ChartSampleData, num>> _buildScatterSeries() {
    return <ScatterSeries<ChartSampleData, num>>[
      ScatterSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: 'India',
        markerSettings: const MarkerSettings(
          width: 15,
          height: 15,
          shape: DataMarkerType.diamond,
        ),
      ),
      ScatterSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: 'China',
        markerSettings: const MarkerSettings(
          width: 15,
          height: 15,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, num>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.thirdSeriesYValue,
        name: 'Japan',
        markerSettings: const MarkerSettings(
          width: 15,
          height: 15,
          shape: DataMarkerType.pentagon,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
