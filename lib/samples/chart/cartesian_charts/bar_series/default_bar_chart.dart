/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

/// render the default bar chart samnple.
class BarDefault extends SampleView {
  const BarDefault(Key key) : super(key: key);

  @override
  _BarDefaultState createState() => _BarDefaultState();
}

/// State class of default bar chart.
class _BarDefaultState extends SampleViewState {
  _BarDefaultState();

  @override
  Widget build(BuildContext context) {
    return getDefaultBarChart();
  }

  /// Returns the default cartesian bar chart.
  SfCartesianChart getDefaultBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Tourism - Number of arrivals'),
      legend: Legend(isVisible: isCardView ? false : true),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          numberFormat: NumberFormat.compact()),
      series: getDefaultBarSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the barchart.
  List<BarSeries<ChartSampleData, String>> getDefaultBarSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'France', y: 84452000, yValue2: 82682000, yValue3: 86861000),
      ChartSampleData(
          x: 'Spain', y: 68175000, yValue2: 75315000, yValue3: 81786000),
      ChartSampleData(
          x: 'US', y: 77774000, yValue2: 76407000, yValue3: 76941000),
      ChartSampleData(
          x: 'Italy', y: 50732000, yValue2: 52372000, yValue3: 58253000),
      ChartSampleData(
          x: 'Mexico', y: 32093000, yValue2: 35079000, yValue3: 39291000),
      ChartSampleData(
          x: 'UK', y: 34436000, yValue2: 35814000, yValue3: 37651000),
    ];
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: '2015'),
      BarSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
          name: '2016'),
      BarSeries<ChartSampleData, String>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue3,
          name: '2017')
    ];
  }
}