/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import 'package:flutter_examples/model/model.dart';
import '../../../../model/sample_view.dart';

/// Renders the cartesian chart with default tootlip sample.
class DefaultTooltip extends SampleView {
  const DefaultTooltip(Key key) : super(key: key);

  @override
  _DefaultTooltipState createState() => _DefaultTooltipState();
}

/// State class of the cartesian chart with default tootlip.
class _DefaultTooltipState extends SampleViewState {
  _DefaultTooltipState();

  @override
  Widget build(BuildContext context) {
    return getDefaultTooltipChart();
  }

  /// Returns the cartesian chart with default tootlip.
  SfCartesianChart getDefaultTooltipChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Labour force'),
      legend: Legend(isVisible: isCardView ? false : true),
      primaryXAxis: NumericAxis(
          minimum: 2004,
          maximum: 2013,
          title: AxisTitle(text: isCardView ? '' : 'Year'),
          majorGridLines: MajorGridLines(width: 0),
          interval: 1),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}M',
          minimum: 30,
          maximum: 60,
          axisLine: AxisLine(width: 0)),
      series: getDefaultTooltipSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the list of chart series which need to render on the cartesian chart.
  List<LineSeries<ChartSampleData, num>> getDefaultTooltipSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 2004, y: 42.630000, yValue2: 34.730000),
      ChartSampleData(x: 2005, y: 43.320000, yValue2: 43.400000),
      ChartSampleData(x: 2006, y: 43.660000, yValue2: 38.090000),
      ChartSampleData(x: 2007, y: 43.540000, yValue2: 44.710000),
      ChartSampleData(x: 2008, y: 43.600000, yValue2: 45.320000),
      ChartSampleData(x: 2009, y: 43.500000, yValue2: 46.200000),
      ChartSampleData(x: 2010, y: 43.350000, yValue2: 46.990000),
      ChartSampleData(x: 2011, y: 43.620000, yValue2: 49.170000),
      ChartSampleData(x: 2012, y: 43.930000, yValue2: 50.640000),
      ChartSampleData(x: 2013, y: 44.200000, yValue2: 51.480000),
    ];
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
          /// To enable the tooltip for line series.
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2,
          name: 'Germany',
          markerSettings: MarkerSettings(isVisible: true)),
      LineSeries<ChartSampleData, num>(
        enableTooltip: true,
        dataSource: chartData,
        width: 2,
        name: 'Mexico',
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue2,
        markerSettings: MarkerSettings(isVisible: true),
      )
    ];
  }
}
