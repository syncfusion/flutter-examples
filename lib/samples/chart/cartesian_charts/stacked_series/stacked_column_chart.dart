/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the stacked column chart sample.
class StackedColumnChart extends SampleView {
  const StackedColumnChart(Key key) : super(key: key);

  @override
  _StackedColumnChartState createState() => _StackedColumnChartState();
}

/// State class of the stacked column chart.
class _StackedColumnChartState extends SampleViewState {
  _StackedColumnChartState();

  @override
  Widget build(BuildContext context) {
    return getStackedColumnChart();
  }

  /// Returns the cartesian Stacked column chart.
  SfCartesianChart getStackedColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView ? '' : 'Quarterly wise sales of products'),
      legend: Legend(
          isVisible: !isCardView, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          labelFormat: '{value}K',
          maximum: 300,
          majorTickLines: MajorTickLines(size: 0)),
      series: getStackedColumnSeries(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart serie which need to render on the stacked column chart.
  List<StackedColumnSeries<ChartSampleData, String>> getStackedColumnSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 'Q1', y: 50, yValue: 55, yValue2: 72, yValue3: 65),
      ChartSampleData(x: 'Q2', y: 80, yValue: 75, yValue2: 70, yValue3: 60),
      ChartSampleData(x: 'Q3', y: 35, yValue: 45, yValue2: 55, yValue3: 52),
      ChartSampleData(x: 'Q4', y: 65, yValue: 50, yValue2: 70, yValue3: 65),
    ];
    return <StackedColumnSeries<ChartSampleData, String>>[
      StackedColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Product A'),
      StackedColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Product B'),
      StackedColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          name: 'Product C'),
      StackedColumnSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
          name: 'Product D')
    ];
  }
}
