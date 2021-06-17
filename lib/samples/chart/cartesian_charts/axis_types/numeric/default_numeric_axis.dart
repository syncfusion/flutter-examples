/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the default numeric axis sample.
class NumericDefault extends SampleView {
  /// Creates the default numeric axis sample.
  const NumericDefault(Key key) : super(key: key);

  @override
  _NumericDefaultState createState() => _NumericDefaultState();
}

/// State class of the default numeric axis.
class _NumericDefaultState extends SampleViewState {
  _NumericDefaultState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true, format: 'Score: point.y', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }

  /// Returns the Cartesian chart with default numeric x and y axis.
  SfCartesianChart _buildChart() {
    return SfCartesianChart(
      title:
          ChartTitle(text: isCardView ? '' : 'Australia vs India ODI - 2019'),
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: !isCardView, position: LegendPosition.top),

      /// X axis as numeric axis placed here.
      primaryXAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Match'),
          minimum: 0,
          maximum: 6,
          interval: 1,
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          edgeLabelPlacement: EdgeLabelPlacement.hide),
      primaryYAxis: NumericAxis(
          title: AxisTitle(text: isCardView ? '' : 'Score'),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: getDefaultNumericSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Chart series
  /// which need to render on the default numeric axis.
  List<ColumnSeries<ChartSampleData, num>> getDefaultNumericSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(xValue: 1, yValue: 240, secondSeriesYValue: 236),
      ChartSampleData(xValue: 2, yValue: 250, secondSeriesYValue: 242),
      ChartSampleData(xValue: 3, yValue: 281, secondSeriesYValue: 313),
      ChartSampleData(xValue: 4, yValue: 358, secondSeriesYValue: 359),
      ChartSampleData(xValue: 5, yValue: 237, secondSeriesYValue: 272)
    ];
    return <ColumnSeries<ChartSampleData, num>>[
      ///first series named "Australia".
      ColumnSeries<ChartSampleData, num>(
          dataSource: chartData,
          color: const Color.fromRGBO(237, 221, 76, 1),
          name: 'Australia',
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue),

      ///second series named "India".
      ColumnSeries<ChartSampleData, num>(
          dataSource: chartData,
          color: const Color.fromRGBO(2, 109, 213, 1),
          xValueMapper: (ChartSampleData sales, _) => sales.xValue as num,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'India'),
    ];
  }
}
