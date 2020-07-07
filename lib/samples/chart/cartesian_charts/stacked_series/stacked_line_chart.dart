/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the stacked line chart sample.
class StackedLineChart extends SampleView {
  const StackedLineChart(Key key) : super(key: key);

  @override
  _StackedLineChartState createState() => _StackedLineChartState();
}

/// State class of the stacked line chart.
class _StackedLineChartState extends SampleViewState {
  _StackedLineChartState();

  @override
  Widget build(BuildContext context) {
    return getStackedLineChart();
  }

  /// Returns the cartesian stacked line chart.
  SfCartesianChart getStackedLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Monthly expense of a family'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelRotation: isCardView ? 0 : -45,
      ),
      primaryYAxis: NumericAxis(
          maximum: 200,
          axisLine: AxisLine(width: 0),
          labelFormat: '\${value}',
          majorTickLines: MajorTickLines(size: 0)),
      series: getStackedLineSeries(),
      trackballBehavior: TrackballBehavior(
          enable: true, activationMode: ActivationMode.singleTap),
      tooltipBehavior:
          TooltipBehavior(enable: false, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart seris which need to render on the stacked line chart.
  List<StackedLineSeries<ChartSampleData, String>> getStackedLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Food', y: 55, yValue: 40, yValue2: 45, yValue3: 48),
      ChartSampleData(
          x: 'Transport', y: 33, yValue: 45, yValue2: 54, yValue3: 28),
      ChartSampleData(
          x: 'Medical', y: 43, yValue: 23, yValue2: 20, yValue3: 34),
      ChartSampleData(
          x: 'Clothes', y: 32, yValue: 54, yValue2: 23, yValue3: 54),
      ChartSampleData(x: 'Books', y: 56, yValue: 18, yValue2: 43, yValue3: 55),
      ChartSampleData(x: 'Others', y: 23, yValue: 54, yValue2: 33, yValue3: 56),
    ];
    return <StackedLineSeries<ChartSampleData, String>>[
      StackedLineSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Father',
          markerSettings: MarkerSettings(isVisible: true)),
      StackedLineSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Mother',
          markerSettings: MarkerSettings(isVisible: true)),
      StackedLineSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          name: 'Son',
          markerSettings: MarkerSettings(isVisible: true)),
      StackedLineSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
          name: 'Daughter',
          markerSettings: MarkerSettings(isVisible: true))
    ];
  }
}
