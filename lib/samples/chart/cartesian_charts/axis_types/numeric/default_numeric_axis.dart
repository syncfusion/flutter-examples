/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default numeric axis sample.
class NumericDefault extends SampleView {
  const NumericDefault(Key key) : super(key: key);

  @override
  _NumericDefaultState createState() => _NumericDefaultState();
}

/// State class of the default numeric axis.
class _NumericDefaultState extends SampleViewState {
  _NumericDefaultState();

  List<ChartSampleData>? _dataOfAustraliaVSIndiaODI2019;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _dataOfAustraliaVSIndiaODI2019 = <ChartSampleData>[
      ChartSampleData(xValue: 1, yValue: 240, secondSeriesYValue: 236),
      ChartSampleData(xValue: 2, yValue: 250, secondSeriesYValue: 242),
      ChartSampleData(xValue: 3, yValue: 281, secondSeriesYValue: 313),
      ChartSampleData(xValue: 4, yValue: 358, secondSeriesYValue: 359),
      ChartSampleData(xValue: 5, yValue: 237, secondSeriesYValue: 272),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'Score: point.y',
      canShowMarker: false,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Australia vs India ODI - 2019',
      ),
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Match'),
        minimum: 0,
        maximum: 6,
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        edgeLabelPlacement: EdgeLabelPlacement.hide,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Score'),
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      legend: Legend(isVisible: !isCardView, position: LegendPosition.top),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, num>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, num>>[
      ColumnSeries<ChartSampleData, num>(
        dataSource: _dataOfAustraliaVSIndiaODI2019,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) =>
            sales.secondSeriesYValue,
        color: const Color.fromRGBO(237, 221, 76, 1),
        name: 'Australia',
      ),
      ColumnSeries<ChartSampleData, num>(
        dataSource: _dataOfAustraliaVSIndiaODI2019,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        color: const Color.fromRGBO(2, 109, 213, 1),
        name: 'India',
      ),
    ];
  }

  @override
  void dispose() {
    _dataOfAustraliaVSIndiaODI2019!.clear();
    super.dispose();
  }
}
