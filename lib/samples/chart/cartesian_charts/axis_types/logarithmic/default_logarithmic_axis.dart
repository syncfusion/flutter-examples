/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the line chart with default logarithmic axis sample.
class LogarithmicAxisDefault extends SampleView {
  /// Creates the line chart with default logarithmic axis sample.
  const LogarithmicAxisDefault(Key key) : super(key: key);

  @override
  _LogarithmicAxisDefaultState createState() => _LogarithmicAxisDefaultState();
}

/// State class of the line cahrt with default logarithmic axis sample.
class _LogarithmicAxisDefaultState extends SampleViewState {
  _LogarithmicAxisDefaultState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultLogarithmicAxisChart();
  }

  /// Returns the line chart with default logarithmic axis.
  SfCartesianChart _buildDefaultLogarithmicAxisChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title:
          ChartTitle(text: isCardView ? '' : 'Growth of a product [1995-2005]'),
      primaryXAxis: DateTimeAxis(),

      /// Y axis as logarithmic axis placed here.
      primaryYAxis: LogarithmicAxis(
          minorTicksPerInterval: 5,
          majorGridLines: const MajorGridLines(width: 1.5),
          minorTickLines: const MinorTickLines(size: 4),
          labelFormat: r'${value}',
          interval: 1),
      series: _getSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on the line chart.
  List<LineSeries<ChartSampleData, DateTime>> _getSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(1996, 1, 1), yValue: 200),
      ChartSampleData(x: DateTime(1997, 1, 1), yValue: 400),
      ChartSampleData(x: DateTime(1998, 1, 1), yValue: 600),
      ChartSampleData(x: DateTime(1999, 1, 1), yValue: 700),
      ChartSampleData(x: DateTime(2000, 1, 1), yValue: 1400),
      ChartSampleData(x: DateTime(2001, 1, 1), yValue: 2000),
      ChartSampleData(x: DateTime(2002, 1, 1), yValue: 4000),
      ChartSampleData(x: DateTime(2003, 1, 1), yValue: 6000),
      ChartSampleData(x: DateTime(2004, 1, 1), yValue: 8000),
      ChartSampleData(x: DateTime(2005, 1, 1), yValue: 11000)
    ];
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}
