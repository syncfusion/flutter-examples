/// Package imports.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the Column Chart with opposed numeric axis.
class NumericOpposed extends SampleView {
  const NumericOpposed(Key key) : super(key: key);

  @override
  _NumericOpposedState createState() => _NumericOpposedState();
}

/// State class of the Column Chart with opposed numeric axes.
class _NumericOpposedState extends SampleViewState {
  _NumericOpposedState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _lightVehicleRetailSalesData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );
    _lightVehicleRetailSalesData = <ChartSampleData>[
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
        text: isCardView ? '' : 'Light vehicle retail sales in US',
      ),
      primaryXAxis: const NumericAxis(
        minimum: 1974,
        maximum: 2022,
        majorGridLines: MajorGridLines(width: 0),
        opposedPosition: true,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: isCardView ? '' : 'Sales in thousands'),
        opposedPosition: true,
        numberFormat: NumberFormat.decimalPattern(),
        minimum: 8000,
        interval: 2000,
        maximum: 20000,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, num>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, num>>[
      ColumnSeries<ChartSampleData, num>(
        dataSource: _lightVehicleRetailSalesData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _lightVehicleRetailSalesData!.clear();
  }
}
