/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Render the default Bar Chart sample.
class BarDefault extends SampleView {
  const BarDefault(Key key) : super(key: key);

  @override
  _BarDefaultState createState() => _BarDefaultState();
}

/// State class of default Bar Chart.
class _BarDefaultState extends SampleViewState {
  _BarDefaultState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'France',
        y: 84452000,
        secondSeriesYValue: 82682000,
        thirdSeriesYValue: 86861000,
      ),
      ChartSampleData(
        x: 'Spain',
        y: 68175000,
        secondSeriesYValue: 75315000,
        thirdSeriesYValue: 81786000,
      ),
      ChartSampleData(
        x: 'US',
        y: 77774000,
        secondSeriesYValue: 76407000,
        thirdSeriesYValue: 76941000,
      ),
      ChartSampleData(
        x: 'Italy',
        y: 50732000,
        secondSeriesYValue: 52372000,
        thirdSeriesYValue: 58253000,
      ),
      ChartSampleData(
        x: 'Mexico',
        y: 32093000,
        secondSeriesYValue: 35079000,
        thirdSeriesYValue: 39291000,
      ),
      ChartSampleData(
        x: 'UK',
        y: 34436000,
        secondSeriesYValue: 35814000,
        thirdSeriesYValue: 37651000,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Bar series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Tourism - Number of arrivals'),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        numberFormat: NumberFormat.compact(),
      ),
      series: _buildBarSeries(),
      legend: Legend(isVisible: !isCardView),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Bar series.
  List<BarSeries<ChartSampleData, String>> _buildBarSeries() {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: '2015',
      ),
      BarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: '2016',
      ),
      BarSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.thirdSeriesYValue,
        name: '2017',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
