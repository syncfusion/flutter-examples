/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Render the back to back Column Chart sample.
class ColumnBack extends SampleView {
  const ColumnBack(Key key) : super(key: key);

  @override
  _ColumnBackState createState() => _ColumnBackState();
}

class _ColumnBackState extends SampleViewState {
  _ColumnBackState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(
        x: 'France',
        y: 63621381,
        yValue: 65027507,
        secondSeriesYValue: 66316092,
      ),
      ChartSampleData(
        x: 'United Kingdom',
        y: 60846820,
        yValue: 62766365,
        secondSeriesYValue: 64613160,
      ),
      ChartSampleData(
        x: 'Italy',
        y: 58143979,
        yValue: 59277417,
        secondSeriesYValue: 60789140,
      ),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      enableSideBySideSeriesPlacement: false,
      title: ChartTitle(
        text: isCardView ? '' : 'Population of various countries',
      ),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorTickLines: const MajorTickLines(size: 0),
        numberFormat: NumberFormat.compact(),
        majorGridLines: const MajorGridLines(width: 0),
        rangePadding: ChartRangePadding.additional,
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        name: '2014',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        width: 0.5,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        name: '2010',
      ),
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        width: 0.3,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        name: '2006',
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _chartData!.clear();
  }
}
