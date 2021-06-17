/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the column chart with opposed numeric axis.
class NumericOpposed extends SampleView {
  /// Creates the column chart with opposed numeric axis.
  const NumericOpposed(Key key) : super(key: key);

  @override
  _NumericOpposedState createState() => _NumericOpposedState();
}

/// State class of the column chart with opposed numeric axes.
class _NumericOpposedState extends SampleViewState {
  _NumericOpposedState();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildOpposedNumericAxisChart();
  }

  /// Returns the column chart with opposed numeric axes.
  SfCartesianChart _buildOpposedNumericAxisChart() {
    return SfCartesianChart(
      title: ChartTitle(
          text: isCardView ? '' : 'Light vehicle retail sales in US'),
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
          minimum: 1974,
          maximum: 2022,
          majorGridLines: const MajorGridLines(width: 0),
          opposedPosition: true,
          edgeLabelPlacement: EdgeLabelPlacement.shift),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Sales in thousands'),
          opposedPosition: true,
          numberFormat: NumberFormat.decimalPattern(),
          minimum: 8000,
          interval: 2000,
          maximum: 20000,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getOpposedNumericAxisSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, num>> _getOpposedNumericAxisSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: 1978, y: 14981),
      ChartSampleData(x: 1983, y: 12107.1),
      ChartSampleData(x: 1988, y: 15443.2),
      ChartSampleData(x: 1993, y: 13882.7),
      ChartSampleData(x: 1998, y: 15543),
      ChartSampleData(x: 2003, y: 16639.1),
      ChartSampleData(x: 2008, y: 13198.8),
      ChartSampleData(x: 2013, y: 15530.1),
      ChartSampleData(x: 2018, y: 17213.5),
    ];
    return <ColumnSeries<ChartSampleData, num>>[
      ColumnSeries<ChartSampleData, num>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as num,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      )
    ];
  }
}
