/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the default area chart sample.
class AreaDefault extends SampleView {
  /// Creates the default area chart sample.
  const AreaDefault(Key key) : super(key: key);

  @override
  _AreaDefaultState createState() => _AreaDefaultState();
}

/// State class of the default area chart.
class _AreaDefaultState extends SampleViewState {
  _AreaDefaultState();

  @override
  Widget build(BuildContext context) {
    return _buildDefaultAreaChart();
  }

  /// Returns the default cartesian area chart.
  SfCartesianChart _buildDefaultAreaChart() {
    return SfCartesianChart(
      legend: Legend(isVisible: !isCardView, opacity: 0.7),
      title: ChartTitle(text: isCardView ? '' : 'Average sales comparison'),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.y(),
          interval: 1,
          intervalType: DateTimeIntervalType.years,
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}M',
          title: AxisTitle(text: isCardView ? '' : 'Revenue in millions'),
          interval: 1,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultAreaSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of Chart series
  /// which need to render on the default area chart.
  List<AreaSeries<ChartSampleData, DateTime>> _getDefaultAreaSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2000, 1, 1), y: 4, secondSeriesYValue: 2.6),
      ChartSampleData(x: DateTime(2001, 1, 1), y: 3.0, secondSeriesYValue: 2.8),
      ChartSampleData(x: DateTime(2002, 1, 1), y: 3.8, secondSeriesYValue: 2.6),
      ChartSampleData(x: DateTime(2003, 1, 1), y: 3.4, secondSeriesYValue: 3),
      ChartSampleData(x: DateTime(2004, 1, 1), y: 3.2, secondSeriesYValue: 3.6),
      ChartSampleData(x: DateTime(2005, 1, 1), y: 3.9, secondSeriesYValue: 3),
    ];
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        opacity: 0.7,
        name: 'Product A',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
      AreaSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        opacity: 0.7,
        name: 'Product B',
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
      )
    ];
  }
}
