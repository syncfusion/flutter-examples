/// Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the Area chart with gradient sample.
class AreaGradient extends SampleView {
  /// Creates the Area chart with gradient sample.
  const AreaGradient(Key key) : super(key: key);

  @override
  _AreaGradientState createState() => _AreaGradientState();
}

/// State class of gradient area chart.
class _AreaGradientState extends SampleViewState {
  _AreaGradientState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGradientAreaChart();
  }

  /// Returns the cartesian area chart with gradient.
  SfCartesianChart _buildGradientAreaChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Annual rainfall of Paris'),
      primaryXAxis: DateTimeAxis(
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y(),
          majorGridLines: const MajorGridLines(width: 0),
          title: AxisTitle(text: 'Year')),
      primaryYAxis: NumericAxis(
          minimum: 200,
          maximum: 600,
          interval: 100,
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}mm',
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getGradientAreaSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart series
  /// which need to render on the gradient area chart.
  List<AreaSeries<ChartSampleData, DateTime>> _getGradientAreaSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(1924), y: 400),
      ChartSampleData(x: DateTime(1925), y: 415),
      ChartSampleData(x: DateTime(1926), y: 408),
      ChartSampleData(x: DateTime(1927), y: 415),
      ChartSampleData(x: DateTime(1928), y: 350),
      ChartSampleData(x: DateTime(1929), y: 375),
      ChartSampleData(x: DateTime(1930), y: 500),
      ChartSampleData(x: DateTime(1931), y: 390),
      ChartSampleData(x: DateTime(1932), y: 450),
      ChartSampleData(x: DateTime(1933), y: 440),
      ChartSampleData(x: DateTime(1934), y: 350),
      ChartSampleData(x: DateTime(1935), y: 400),
      ChartSampleData(x: DateTime(1936), y: 365),
      ChartSampleData(x: DateTime(1937), y: 490),
      ChartSampleData(x: DateTime(1938), y: 400),
      ChartSampleData(x: DateTime(1939), y: 520),
      ChartSampleData(x: DateTime(1940), y: 510),
      ChartSampleData(x: DateTime(1941), y: 395),
      ChartSampleData(x: DateTime(1942), y: 380),
      ChartSampleData(x: DateTime(1943), y: 404),
      ChartSampleData(x: DateTime(1944), y: 400),
      ChartSampleData(x: DateTime(1945), y: 500)
    ];
    final List<Color> color = <Color>[];
    color.add(const Color(0xFF6A31D5));
    color.add(const Color(0xFFB650C8));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(1.0);

    final LinearGradient gradientColors = LinearGradient(
        colors: color,
        stops: stops,
        transform: GradientRotation(270.toDouble() * 3.14 / 180));
    return <AreaSeries<ChartSampleData, DateTime>>[
      AreaSeries<ChartSampleData, DateTime>(
        /// To apply the gradient colors here.
        gradient: gradientColors,
        dataSource: chartData,
        xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Annual Rainfall',
      )
    ];
  }
}
