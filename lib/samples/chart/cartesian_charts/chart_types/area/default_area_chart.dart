/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default Area Chart sample.
class AreaDefault extends SampleView {
  const AreaDefault(Key key) : super(key: key);

  @override
  _AreaDefaultState createState() => _AreaDefaultState();
}

/// State class of the default Area Chart.
class _AreaDefaultState extends SampleViewState {
  _AreaDefaultState();

  List<ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2000), y: 4, secondSeriesYValue: 2.6),
      ChartSampleData(x: DateTime(2001), y: 3.0, secondSeriesYValue: 2.8),
      ChartSampleData(x: DateTime(2002), y: 3.8, secondSeriesYValue: 2.6),
      ChartSampleData(x: DateTime(2003), y: 3.4, secondSeriesYValue: 3),
      ChartSampleData(x: DateTime(2004), y: 3.2, secondSeriesYValue: 3.6),
      ChartSampleData(x: DateTime(2005), y: 3.9, secondSeriesYValue: 3),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Area series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Average sales comparison'),
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.y(),
        interval: 1,
        intervalType: DateTimeIntervalType.years,
        majorGridLines: const MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}M',
        title: AxisTitle(text: isCardView ? '' : 'Revenue in millions'),
        interval: 1,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildAreaSeries(),
      legend: Legend(isVisible: !isCardView, opacity: 0.7),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Area series.
  List<AreaSeries<ChartSampleData, DateTime>> _buildAreaSeries() {
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
        opacity: 0.7,
        name: 'Product A',
      ),
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        opacity: 0.7,
        name: 'Product B',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
