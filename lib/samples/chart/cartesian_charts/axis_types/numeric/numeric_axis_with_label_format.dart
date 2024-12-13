/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the numeric with axis label format.
class NumericLabel extends SampleView {
  const NumericLabel(Key key) : super(key: key);

  @override
  _NumericLabelState createState() => _NumericLabelState();
}

/// State class of numeric axis label format.
class _NumericLabelState extends SampleViewState {
  _NumericLabelState();

  List<ChartSampleData>? _fahrenheitToCelsiusConversionData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _fahrenheitToCelsiusConversionData = <ChartSampleData>[
      ChartSampleData(xValue: 1, yValue: 240, secondSeriesYValue: 236),
      ChartSampleData(xValue: 2, yValue: 250, secondSeriesYValue: 242),
      ChartSampleData(xValue: 3, yValue: 281, secondSeriesYValue: 313),
      ChartSampleData(xValue: 4, yValue: 358, secondSeriesYValue: 359),
      ChartSampleData(xValue: 5, yValue: 237, secondSeriesYValue: 272),
    ];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      format: 'point.x / point.y',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  Widget _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView ? '' : 'Fahrenheit - Celsius conversion',
      ),
      primaryXAxis: const NumericAxis(
        labelFormat: '{value}°C',
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}°F',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildLineSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<ChartSampleData, num>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, num>>[
      LineSeries<ChartSampleData, num>(
        dataSource: _fahrenheitToCelsiusConversionData,
        xValueMapper: (ChartSampleData sales, int index) => sales.xValue,
        yValueMapper: (ChartSampleData sales, int index) => sales.yValue,
        markerSettings: const MarkerSettings(
          height: 10,
          width: 10,
          isVisible: true,
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _fahrenheitToCelsiusConversionData!.clear();
    _tooltipBehavior = null;
    super.dispose();
  }
}
