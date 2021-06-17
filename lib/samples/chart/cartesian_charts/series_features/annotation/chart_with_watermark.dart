/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Renders the chart with watermark sample.
class AnnotationDefault extends SampleView {
  /// Creates the chart with watermark sample.
  const AnnotationDefault(Key key) : super(key: key);

  @override
  _AnnotationDefaultState createState() => _AnnotationDefaultState();
}

/// State class of the chart with watermark.
class _AnnotationDefaultState extends SampleViewState {
  _AnnotationDefaultState();
  late TrackballBehavior _trackballBehavior;
  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultAnnotationChart();
  }

  /// Returns the cartesian chart with watermark.
  SfCartesianChart _buildDefaultAnnotationChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: isCardView
              ? ''
              : 'Euro to USD monthly exchange rate - 2015 to 2018'),
      primaryXAxis:
          DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        labelFormat: r'${value}',
        minimum: 0.95,
        maximum: 1.3,
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: _getAnnotationLineSeries(),
      trackballBehavior: _trackballBehavior,

      /// Using various styles in annotation we can achieve
      /// the water marker on chart.
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: Container(
            child: const Text(
              r'€ - $ ',
              style: TextStyle(
                  color: Color.fromRGBO(216, 225, 227, 0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 80),
            ),
          ),
          coordinateUnit: CoordinateUnit.point,
          region: AnnotationRegion.chart,
          x: DateTime(2016, 11, 1),
          y: 1.12,
        )
      ],
    );
  }

  /// Returns the list of chart series which need to
  /// render on the chart with watermark.
  List<LineSeries<ChartSampleData, DateTime>> _getAnnotationLineSeries() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2015, 1, 1), y: 1.13),
      ChartSampleData(x: DateTime(2015, 2, 1), y: 1.12),
      ChartSampleData(x: DateTime(2015, 3, 1), y: 1.08),
      ChartSampleData(x: DateTime(2015, 4, 1), y: 1.12),
      ChartSampleData(x: DateTime(2015, 5, 1), y: 1.1),
      ChartSampleData(x: DateTime(2015, 6, 1), y: 1.12),
      ChartSampleData(x: DateTime(2015, 7, 1), y: 1.1),
      ChartSampleData(x: DateTime(2015, 8, 1), y: 1.12),
      ChartSampleData(x: DateTime(2015, 9, 1), y: 1.12),
      ChartSampleData(x: DateTime(2015, 10, 1), y: 1.1),
      ChartSampleData(x: DateTime(2015, 11, 1), y: 1.06),
      ChartSampleData(x: DateTime(2015, 12, 1), y: 1.09),
      ChartSampleData(x: DateTime(2016, 1, 1), y: 1.09),
      ChartSampleData(x: DateTime(2016, 2, 1), y: 1.09),
      ChartSampleData(x: DateTime(2016, 3, 1), y: 1.14),
      ChartSampleData(x: DateTime(2016, 4, 1), y: 1.14),
      ChartSampleData(x: DateTime(2016, 5, 1), y: 1.12),
      ChartSampleData(x: DateTime(2016, 6, 1), y: 1.11),
      ChartSampleData(x: DateTime(2016, 7, 1), y: 1.11),
      ChartSampleData(x: DateTime(2016, 8, 1), y: 1.11),
      ChartSampleData(x: DateTime(2016, 9, 1), y: 1.12),
      ChartSampleData(x: DateTime(2016, 10, 1), y: 1.1),
      ChartSampleData(x: DateTime(2016, 11, 1), y: 1.08),
      ChartSampleData(x: DateTime(2016, 12, 1), y: 1.05),
      ChartSampleData(x: DateTime(2017, 1, 1), y: 1.08),
      ChartSampleData(x: DateTime(2017, 2, 1), y: 1.06),
      ChartSampleData(x: DateTime(2017, 3, 1), y: 1.07),
      ChartSampleData(x: DateTime(2017, 4, 1), y: 1.09),
      ChartSampleData(x: DateTime(2017, 5, 1), y: 1.12),
      ChartSampleData(x: DateTime(2017, 6, 1), y: 1.14),
      ChartSampleData(x: DateTime(2017, 7, 1), y: 1.17),
      ChartSampleData(x: DateTime(2017, 8, 1), y: 1.18),
      ChartSampleData(x: DateTime(2017, 9, 1), y: 1.18),
      ChartSampleData(x: DateTime(2017, 10, 1), y: 1.16),
      ChartSampleData(x: DateTime(2017, 11, 1), y: 1.18),
      ChartSampleData(x: DateTime(2017, 12, 1), y: 1.2),
      ChartSampleData(x: DateTime(2018, 1, 1), y: 1.25),
      ChartSampleData(x: DateTime(2018, 2, 1), y: 1.22),
      ChartSampleData(x: DateTime(2018, 3, 1), y: 1.23),
      ChartSampleData(x: DateTime(2018, 4, 1), y: 1.21),
      ChartSampleData(x: DateTime(2018, 5, 1), y: 1.17),
      ChartSampleData(x: DateTime(2018, 6, 1), y: 1.17),
      ChartSampleData(x: DateTime(2018, 7, 1), y: 1.17),
      ChartSampleData(x: DateTime(2018, 8, 1), y: 1.17),
      ChartSampleData(x: DateTime(2018, 9, 1), y: 1.16),
      ChartSampleData(x: DateTime(2018, 10, 1), y: 1.13),
      ChartSampleData(x: DateTime(2018, 11, 1), y: 1.14),
      ChartSampleData(x: DateTime(2018, 12, 1), y: 1.15)
    ];
    return <LineSeries<ChartSampleData, DateTime>>[
      LineSeries<ChartSampleData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x as DateTime,
        yValueMapper: (ChartSampleData data, _) => data.y,
        color: const Color.fromRGBO(242, 117, 7, 1),
      )
    ];
  }
}
