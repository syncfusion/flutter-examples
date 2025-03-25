/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders Column Chart with rounded corners.
class ColumnRounded extends SampleView {
  const ColumnRounded(Key key) : super(key: key);

  @override
  _ColumnRoundedState createState() => _ColumnRoundedState();
}

class _ColumnRoundedState extends SampleViewState {
  _ColumnRoundedState();

  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      format: 'point.x : point.y sq.km',
      header: '',
    );
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'New York', y: 8683),
      ChartSampleData(x: 'Tokyo', y: 6993),
      ChartSampleData(x: 'Chicago', y: 5498),
      ChartSampleData(x: 'Atlanta', y: 5083),
      ChartSampleData(x: 'Boston', y: 4497),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    final bool isM3DarkMode =
        model.themeData.useMaterial3 &&
        model.themeData.brightness == Brightness.dark;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Land area of various cities (sq.km)',
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
          color: isM3DarkMode ? Colors.black : Colors.white,
        ),
        axisLine: const AxisLine(width: 0),
        labelPosition: ChartDataLabelPosition.inside,
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        minimum: 0,
        maximum: 9000,
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleData, String>> _buildColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData sales, int index) => sales.x,
        yValueMapper: (ChartSampleData sales, int index) => sales.y,

        /// If we set the border radius value for Column series,
        /// then the series will appear as rounder corner.
        borderRadius: BorderRadius.circular(10),
        width: 0.9,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _chartData!.clear();
  }
}
