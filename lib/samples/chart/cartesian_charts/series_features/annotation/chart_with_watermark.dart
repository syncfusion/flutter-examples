/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the line series chart with watermark sample.
class AnnotationDefault extends SampleView {
  /// Creates the line series chart with watermark sample.
  const AnnotationDefault(Key key) : super(key: key);

  @override
  _AnnotationDefaultState createState() => _AnnotationDefaultState();
}

/// State class for the column series chart with watermark.
class _AnnotationDefaultState extends SampleViewState {
  _AnnotationDefaultState();

  TrackballBehavior? _trackballBehavior;
  List<ChartSampleData>? _chartData;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'),
    );
    _chartData = _buildChartData();
    super.initState();
  }

  List<ChartSampleData> _buildChartData() {
    return [
      ChartSampleData(x: DateTime(2015), y: 1.13),
      ChartSampleData(x: DateTime(2015, 2), y: 1.12),
      ChartSampleData(x: DateTime(2015, 3), y: 1.08),
      ChartSampleData(x: DateTime(2015, 4), y: 1.12),
      ChartSampleData(x: DateTime(2015, 5), y: 1.1),
      ChartSampleData(x: DateTime(2015, 6), y: 1.12),
      ChartSampleData(x: DateTime(2015, 7), y: 1.1),
      ChartSampleData(x: DateTime(2015, 8), y: 1.12),
      ChartSampleData(x: DateTime(2015, 9), y: 1.12),
      ChartSampleData(x: DateTime(2015, 10), y: 1.1),
      ChartSampleData(x: DateTime(2015, 11), y: 1.06),
      ChartSampleData(x: DateTime(2015, 12), y: 1.09),
      ChartSampleData(x: DateTime(2016), y: 1.09),
      ChartSampleData(x: DateTime(2016, 2), y: 1.09),
      ChartSampleData(x: DateTime(2016, 3), y: 1.14),
      ChartSampleData(x: DateTime(2016, 4), y: 1.14),
      ChartSampleData(x: DateTime(2016, 5), y: 1.12),
      ChartSampleData(x: DateTime(2016, 6), y: 1.11),
      ChartSampleData(x: DateTime(2016, 7), y: 1.11),
      ChartSampleData(x: DateTime(2016, 8), y: 1.11),
      ChartSampleData(x: DateTime(2016, 9), y: 1.12),
      ChartSampleData(x: DateTime(2016, 10), y: 1.1),
      ChartSampleData(x: DateTime(2016, 11), y: 1.08),
      ChartSampleData(x: DateTime(2016, 12), y: 1.05),
      ChartSampleData(x: DateTime(2017), y: 1.08),
      ChartSampleData(x: DateTime(2017, 2), y: 1.06),
      ChartSampleData(x: DateTime(2017, 3), y: 1.07),
      ChartSampleData(x: DateTime(2017, 4), y: 1.09),
      ChartSampleData(x: DateTime(2017, 5), y: 1.12),
      ChartSampleData(x: DateTime(2017, 6), y: 1.14),
      ChartSampleData(x: DateTime(2017, 7), y: 1.17),
      ChartSampleData(x: DateTime(2017, 8), y: 1.18),
      ChartSampleData(x: DateTime(2017, 9), y: 1.18),
      ChartSampleData(x: DateTime(2017, 10), y: 1.16),
      ChartSampleData(x: DateTime(2017, 11), y: 1.18),
      ChartSampleData(x: DateTime(2017, 12), y: 1.2),
      ChartSampleData(x: DateTime(2018), y: 1.25),
      ChartSampleData(x: DateTime(2018, 2), y: 1.22),
      ChartSampleData(x: DateTime(2018, 3), y: 1.23),
      ChartSampleData(x: DateTime(2018, 4), y: 1.21),
      ChartSampleData(x: DateTime(2018, 5), y: 1.17),
      ChartSampleData(x: DateTime(2018, 6), y: 1.17),
      ChartSampleData(x: DateTime(2018, 7), y: 1.17),
      ChartSampleData(x: DateTime(2018, 8), y: 1.17),
      ChartSampleData(x: DateTime(2018, 9), y: 1.16),
      ChartSampleData(x: DateTime(2018, 10), y: 1.13),
      ChartSampleData(x: DateTime(2018, 11), y: 1.14),
      ChartSampleData(x: DateTime(2018, 12), y: 1.15),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultAnnotationChart();
  }

  /// Returns s cartesian line series chart with watermark.
  SfCartesianChart _buildDefaultAnnotationChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: isCardView
            ? ''
            : 'Euro to USD monthly exchange rate - 2015 to 2018',
      ),
      primaryXAxis: const DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        axisLine: AxisLine(width: 0),
        labelFormat: r'${value}',
        minimum: 0.95,
        maximum: 1.3,
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildLineSeries(),
      trackballBehavior: _trackballBehavior,

      /// Adds a watermark annotation to the chart
      /// showing currency symbols (€ - $).
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: const Text(
            r'€ - $ ',
            style: TextStyle(
              color: Color.fromRGBO(216, 225, 227, 0.6),
              fontWeight: FontWeight.bold,
              fontSize: 80,
            ),
          ),
          coordinateUnit: CoordinateUnit.point,
          x: DateTime(2016, 11),
          y: 1.12,
        ),
      ],
    );
  }

  /// Returns the list of cartesian series.
  List<LineSeries<ChartSampleData, DateTime>> _buildLineSeries() {
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        color: const Color.fromRGBO(242, 117, 7, 1),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}
