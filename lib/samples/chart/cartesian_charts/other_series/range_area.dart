/// Dart import
import 'dart:math';

/// Package imports
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the Range area chart sample.
class RangeArea extends SampleView {
  const RangeArea(Key key) : super(key: key);

  @override
  _RangeAreaState createState() => _RangeAreaState();
}

/// State class of the Range area chart.
class _RangeAreaState extends SampleViewState {
  _RangeAreaState();

  @override
  Widget build(BuildContext context) {
    return getRangeAreaChart();
  }

  /// Returns the Cartesian Range area chart.
  SfCartesianChart getRangeAreaChart() {
    return SfCartesianChart(
      title:
          ChartTitle(text: isCardView ? '' : 'Average temperature variation'),
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.y(),
          interval: 1,
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}°C',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getRangeAreaSeries(),
      tooltipBehavior: TooltipBehavior(enable: true, decimalPlaces: 1),
    );
  }

  /// Gets the random data for the Rnage area chart series.
  dynamic getData() {
    List<_RangeAreaData> _chartData;
    _chartData = <_RangeAreaData>[];
    double _value = 30;
    for (int i = 0; i < 100; i++) {
      final Random _yValue = Random();
      if (_yValue.nextDouble() > .5) {
        _value += Random().nextDouble();
      } else {
        _value -= Random().nextDouble();
      }
      _chartData
          .add(_RangeAreaData(DateTime(2000, i + 2, i), _value, _value + 10));
    }
    return _chartData;
  }

  /// Returns the list of Chart series which need to render on the Range area chart.
  List<ChartSeries<_RangeAreaData, DateTime>> _getRangeAreaSeries() {
    final List<_RangeAreaData> chartData = getData();
    return <ChartSeries<_RangeAreaData, DateTime>>[
      RangeAreaSeries<_RangeAreaData, DateTime>(
        dataSource: chartData,
        name: 'London',
        borderWidth: 2,
        opacity: 0.5,
        borderColor: const Color.fromRGBO(50, 198, 255, 1),
        color: const Color.fromRGBO(50, 198, 255, 1),
        borderDrawMode: RangeAreaBorderMode.excludeSides,
        xValueMapper: (_RangeAreaData sales, _) => sales.month,
        highValueMapper: (_RangeAreaData sales, _) => sales.high,
        lowValueMapper: (_RangeAreaData sales, _) => sales.low,
      )
    ];
  }
}

/// Private class for storing the Range area chart data points.
class _RangeAreaData {
  _RangeAreaData(this.month, this.high, this.low);
  final DateTime month;
  final double high;
  final double low;
}
