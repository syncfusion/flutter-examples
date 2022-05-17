/// Dart import
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the Range area chart sample.
class RangeArea extends SampleView {
  /// Creates the Range area chart sample.
  const RangeArea(Key key) : super(key: key);

  @override
  _RangeAreaState createState() => _RangeAreaState();
}

/// State class of the Range area chart.
class _RangeAreaState extends SampleViewState {
  _RangeAreaState();

  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, decimalPlaces: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRangeAreaChart();
  }

  /// Returns the Cartesian Range area chart.
  SfCartesianChart _buildRangeAreaChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Average temperature variation'),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.y(),
          interval: 1,
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}°C',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getRangeAreaSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Gets the random data for the Rnage area chart series.
  List<ChartSampleData> _getData() {
    List<ChartSampleData> chartData;
    chartData = <ChartSampleData>[];
    double value = 30;
    for (int i = 0; i < 100; i++) {
      final Random yValue = Random();
      (yValue.nextDouble() > .5)
          ? value += Random().nextDouble()
          : value -= Random().nextDouble();

      chartData.add(ChartSampleData(
          x: DateTime(2000, i + 2, i), high: value, low: value + 10));
    }
    return chartData;
  }

  /// Returns the list of Chart series
  /// which need to render on the Range area chart.
  List<ChartSeries<ChartSampleData, DateTime>> _getRangeAreaSeries() {
    return <ChartSeries<ChartSampleData, DateTime>>[
      RangeAreaSeries<ChartSampleData, DateTime>(
        dataSource: _getData(),
        name: 'London',
        borderWidth: 2,
        opacity: 0.5,
        borderColor: const Color.fromRGBO(50, 198, 255, 1),
        color: const Color.fromRGBO(50, 198, 255, 1),
        borderDrawMode: RangeAreaBorderMode.excludeSides,
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        highValueMapper: (ChartSampleData sales, _) => sales.high,
        lowValueMapper: (ChartSampleData sales, _) => sales.low,
      )
    ];
  }
}
