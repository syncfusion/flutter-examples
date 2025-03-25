/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the Line Chart with default logarithmic axis sample.
class LogarithmicAxisDefault extends SampleView {
  const LogarithmicAxisDefault(Key key) : super(key: key);

  @override
  _LogarithmicAxisDefaultState createState() => _LogarithmicAxisDefaultState();
}

/// State class of the Line Chart with default logarithmic axis sample.
class _LogarithmicAxisDefaultState extends SampleViewState {
  _LogarithmicAxisDefaultState();

  List<ChartSampleData>? _productGrowthDataFrom1995To2005;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _productGrowthDataFrom1995To2005 = <ChartSampleData>[
      ChartSampleData(x: DateTime(1996), yValue: 200),
      ChartSampleData(x: DateTime(1997), yValue: 400),
      ChartSampleData(x: DateTime(1998), yValue: 600),
      ChartSampleData(x: DateTime(1999), yValue: 700),
      ChartSampleData(x: DateTime(2000), yValue: 1400),
      ChartSampleData(x: DateTime(2001), yValue: 2000),
      ChartSampleData(x: DateTime(2002), yValue: 4000),
      ChartSampleData(x: DateTime(2003), yValue: 6000),
      ChartSampleData(x: DateTime(2004), yValue: 8000),
      ChartSampleData(x: DateTime(2005), yValue: 11000),
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

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 1,
      title: ChartTitle(
        text: isCardView ? '' : 'Growth of a product [1995-2005]',
      ),
      primaryXAxis: const DateTimeAxis(),
      primaryYAxis: const LogarithmicAxis(
        minorTicksPerInterval: 5,
        majorGridLines: MajorGridLines(width: 1.5),
        minorTickLines: MinorTickLines(size: 4),
        labelFormat: r'${value}',
        interval: 1,
      ),
      series: _buildLineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<ChartSampleData, DateTime>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _productGrowthDataFrom1995To2005,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _productGrowthDataFrom1995To2005!.clear();
    super.dispose();
  }
}
