/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the default bar chart samnple.
class BarDefault extends SampleView {
  /// Creates the default bar chart samnple.
  const BarDefault(Key key) : super(key: key);

  @override
  _BarDefaultState createState() => _BarDefaultState();
}

/// State class of default bar chart.
class _BarDefaultState extends SampleViewState {
  _BarDefaultState();

  @override
  Widget build(BuildContext context) {
    return _buildDefaultBarChart();
  }

  /// Returns the default cartesian bar chart.
  SfCartesianChart _buildDefaultBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Tourism - Number of arrivals'),
      legend: Legend(isVisible: !isCardView),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          numberFormat: NumberFormat.compact()),
      series: _getDefaultBarSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the barchart.
  List<BarSeries<ChartSampleData, String>> _getDefaultBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'France',
          y: 84452000,
          secondSeriesYValue: 82682000,
          thirdSeriesYValue: 86861000),
      ChartSampleData(
          x: 'Spain',
          y: 68175000,
          secondSeriesYValue: 75315000,
          thirdSeriesYValue: 81786000),
      ChartSampleData(
          x: 'US',
          y: 77774000,
          secondSeriesYValue: 76407000,
          thirdSeriesYValue: 76941000),
      ChartSampleData(
          x: 'Italy',
          y: 50732000,
          secondSeriesYValue: 52372000,
          thirdSeriesYValue: 58253000),
      ChartSampleData(
          x: 'Mexico',
          y: 32093000,
          secondSeriesYValue: 35079000,
          thirdSeriesYValue: 39291000),
      ChartSampleData(
          x: 'UK',
          y: 34436000,
          secondSeriesYValue: 35814000,
          thirdSeriesYValue: 37651000),
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: '2015'),
      BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: '2016'),
      BarSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.thirdSeriesYValue,
          name: '2017')
    ];
  }
}
