/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import
import '../../../../model/sample_view.dart';

/// Renders the steparea chart sample.
class StepArea extends SampleView {
  /// Creates the steparea chart sample.
  const StepArea(Key key) : super(key: key);

  @override
  _StepAreaState createState() => _StepAreaState();
}

/// State clas of the step area chart.
class _StepAreaState extends SampleViewState {
  _StepAreaState();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            bottom: model.isWebFullView || !isCardView ? 0 : 60),
        child: _buildStepAreaChart());
  }

  /// Returns the cartesian step area chart.
  SfCartesianChart _buildStepAreaChart() {
    final ThemeData themeData = model.themeData;
    return SfCartesianChart(
      legend: const Legend(isVisible: true),
      title: const ChartTitle(text: 'Temperature variation of Paris'),
      plotAreaBorderWidth: 0,
      primaryXAxis: const DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: const NumericAxis(
          labelFormat: '{value}°C',
          interval: 2,
          maximum: 16,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: _getStepAreaSeries(
          themeData.useMaterial3, themeData.brightness == Brightness.light),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<_StepAreaData>? chartData;

  @override
  void initState() {
    chartData = <_StepAreaData>[
      _StepAreaData(DateTime(2019, 3), 12, 9),
      _StepAreaData(DateTime(2019, 3, 2), 13, 7),
      _StepAreaData(DateTime(2019, 3, 3), 14, 10),
      _StepAreaData(DateTime(2019, 3, 4), 12, 5),
      _StepAreaData(DateTime(2019, 3, 5), 12, 4),
      _StepAreaData(DateTime(2019, 3, 6), 12, 8),
      _StepAreaData(DateTime(2019, 3, 7), 13, 6),
      _StepAreaData(DateTime(2019, 3, 8), 12, 4),
      _StepAreaData(DateTime(2019, 3, 9), 15, 8),
      _StepAreaData(DateTime(2019, 3, 10), 14, 7),
      _StepAreaData(DateTime(2019, 3, 11), 10, 3),
      _StepAreaData(DateTime(2019, 3, 12), 13, 4),
      _StepAreaData(DateTime(2019, 3, 13), 12, 4),
      _StepAreaData(DateTime(2019, 3, 14), 11, 6),
      _StepAreaData(DateTime(2019, 3, 15), 14, 10),
      _StepAreaData(DateTime(2019, 3, 16), 14, 9),
      _StepAreaData(DateTime(2019, 3, 17), 11, 4),
      _StepAreaData(DateTime(2019, 3, 18), 11, 2),
    ];
    super.initState();
  }

  /// Returns the list of chart series
  /// which need to render on teh step area chart.
  List<CartesianSeries<_StepAreaData, DateTime>> _getStepAreaSeries(
      bool isMaterial3, bool isLightMode) {
    final Color seriesColor1 = isMaterial3
        ? (isLightMode
            ? const Color.fromRGBO(6, 174, 224, 1)
            : const Color.fromRGBO(255, 245, 0, 1))
        : const Color.fromRGBO(75, 135, 185, 1);
    final Color seriesColor2 = isMaterial3
        ? (isLightMode
            ? const Color.fromRGBO(99, 85, 199, 1)
            : const Color.fromRGBO(51, 182, 119, 1))
        : const Color.fromRGBO(192, 108, 132, 1);
    return <CartesianSeries<_StepAreaData, DateTime>>[
      StepAreaSeries<_StepAreaData, DateTime>(
        dataSource: chartData,
        color: seriesColor1.withOpacity(0.6),
        borderColor: seriesColor1,
        name: 'High',
        xValueMapper: (_StepAreaData sales, _) => sales.x,
        yValueMapper: (_StepAreaData sales, _) => sales.high,
      ),
      StepAreaSeries<_StepAreaData, DateTime>(
        dataSource: chartData,
        borderColor: seriesColor2,
        color: seriesColor2.withOpacity(0.6),
        name: 'Low',
        xValueMapper: (_StepAreaData sales, _) => sales.x,
        yValueMapper: (_StepAreaData sales, _) => sales.low,
      )
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}

/// Private class for storing the step area chart data point.
class _StepAreaData {
  _StepAreaData(this.x, this.high, this.low);
  final DateTime x;
  final double high;
  final double low;
}
