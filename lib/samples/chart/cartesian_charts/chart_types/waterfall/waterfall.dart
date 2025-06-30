/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the waterfall series chart sample.
class WaterFall extends SampleView {
  /// Creates the waterfall series chart.
  const WaterFall(Key key) : super(key: key);

  @override
  _WaterFallState createState() => _WaterFallState();
}

class _WaterFallState extends SampleViewState {
  _WaterFallState();
  List<_ChartSampleData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = <_ChartSampleData>[
      _ChartSampleData(
        x: 'Income',
        y: 4700,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Sales',
        y: -1100,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Development',
        y: -700,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Revenue',
        y: 1200,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Balance',
        intermediateSumPredicate: true,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Expense',
        y: -400,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Tax',
        y: -800,
        intermediateSumPredicate: false,
        totalSumPredicate: false,
      ),
      _ChartSampleData(
        x: 'Net Profit',
        intermediateSumPredicate: false,
        totalSumPredicate: true,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultWaterfallChart();
  }

  /// Returns the cartesian waterfall chart.
  SfCartesianChart _buildDefaultWaterfallChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Company revenue and profit'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelIntersectAction: isCardView
            ? AxisLabelIntersectAction.wrap
            : AxisLabelIntersectAction.rotate45,
      ),
      primaryYAxis: NumericAxis(
        name: 'Expenditure',
        minimum: 0,
        maximum: 5000,
        interval: 1000,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel((details.value ~/ 1000).toString() + 'B', null);
        },
      ),
      series: _buildWaterFallSeries(),
      tooltipBehavior: _tooltipBehavior,
      onTooltipRender: (TooltipArgs args) {
        args.text =
            args.dataPoints![args.pointIndex!.toInt()].x.toString() +
            ' : ' +
            (args.dataPoints![args.pointIndex!.toInt()].y / 1000).toString() +
            'B';
      },
      onDataLabelRender: (DataLabelRenderArgs dataLabelArgs) {
        if (dataLabelArgs.pointIndex == 0) {
          dataLabelArgs.text = '4.7B';
        } else if (dataLabelArgs.pointIndex == 1) {
          dataLabelArgs.text = '-1.1B';
        } else if (dataLabelArgs.pointIndex == 2) {
          dataLabelArgs.text = '-0.7B';
        } else if (dataLabelArgs.pointIndex == 3) {
          dataLabelArgs.text = '1.2B';
        } else if (dataLabelArgs.pointIndex == 4) {
          dataLabelArgs.text = '4.1B';
        } else if (dataLabelArgs.pointIndex == 5) {
          dataLabelArgs.text = '-0.4B';
        } else if (dataLabelArgs.pointIndex == 6) {
          dataLabelArgs.text = '-0.8B';
        } else if (dataLabelArgs.pointIndex == 7) {
          dataLabelArgs.text = '2.9B';
        }
      },
    );
  }

  /// Returns the list of cartesian water fall series.
  List<WaterfallSeries<_ChartSampleData, dynamic>> _buildWaterFallSeries() {
    return <WaterfallSeries<_ChartSampleData, dynamic>>[
      WaterfallSeries<_ChartSampleData, dynamic>(
        dataSource: _chartData,
        xValueMapper: (_ChartSampleData data, int index) => data.x,
        yValueMapper: (_ChartSampleData data, int index) => data.y,
        color: const Color.fromRGBO(0, 189, 174, 1),
        negativePointsColor: const Color.fromRGBO(229, 101, 144, 1),
        intermediateSumColor: const Color.fromRGBO(79, 129, 188, 1),
        totalSumColor: const Color.fromRGBO(79, 129, 188, 1),
        intermediateSumPredicate: (_ChartSampleData data, int index) =>
            data.intermediateSumPredicate,
        totalSumPredicate: (_ChartSampleData data, int index) =>
            data.totalSumPredicate,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.middle,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartSampleData {
  _ChartSampleData({
    this.x,
    this.y,
    this.intermediateSumPredicate,
    this.totalSumPredicate,
  });

  final String? x;
  final num? y;
  final bool? intermediateSumPredicate;
  final bool? totalSumPredicate;
}
