/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the spline area series chart with horizontal gradient.
class HorizontalGradient extends SampleView {
  /// Creates the spline area series chart with horizontal gradient.
  const HorizontalGradient(Key key) : super(key: key);

  @override
  _HorizontalGradientState createState() => _HorizontalGradientState();
}

/// State class for the spline area series
/// chart with horizontal gradient.
class _HorizontalGradientState extends SampleViewState {
  _HorizontalGradientState();
  List<_ChartSampleData>? _chartData;

  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    _chartData = <_ChartSampleData>[
      _ChartSampleData(x: '1997', y: 17.70),
      _ChartSampleData(x: '1998', y: 18.20),
      _ChartSampleData(x: '1999', y: 18),
      _ChartSampleData(x: '2000', y: 19),
      _ChartSampleData(x: '2001', y: 18.5),
      _ChartSampleData(x: '2002', y: 18),
      _ChartSampleData(x: '2003', y: 18.80),
      _ChartSampleData(x: '2004', y: 17.90),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalGradientAreaChart();
  }

  /// Returns a circular spline area chart with horizontal gradient.
  SfCartesianChart _buildHorizontalGradientAreaChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Total investment (% of GDP)'),
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.onTicks,
        interval: model.isWebFullView ? 1 : null,
        labelRotation: -45,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      tooltipBehavior: _tooltipBehavior,
      primaryYAxis: const NumericAxis(
        interval: 2,
        minimum: 14,
        maximum: 20,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildAreaSeries(),
    );
  }

  /// Returns the list of spline area series.
  List<CartesianSeries<_ChartSampleData, String>> _buildAreaSeries() {
    return <CartesianSeries<_ChartSampleData, String>>[
      SplineAreaSeries<_ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartSampleData data, int index) => data.x,
        yValueMapper: (_ChartSampleData data, int index) => data.y,

        /// To set the gradient colors for border here.
        borderGradient: const LinearGradient(
          colors: <Color>[
            Color.fromRGBO(212, 126, 166, 1),
            Color.fromRGBO(222, 187, 104, 1),
          ],
          stops: <double>[0.2, 0.9],
        ),

        /// To set the gradient colors for series.
        gradient: const LinearGradient(
          colors: <Color>[
            Color.fromRGBO(224, 139, 207, 0.9),
            Color.fromRGBO(255, 232, 149, 0.9),
          ],
          stops: <double>[0.2, 0.9],
        ),
        markerSettings: const MarkerSettings(
          isVisible: true,
          borderColor: Colors.white,
        ),
        name: 'Investment',
        onCreateRenderer: (ChartSeries<_ChartSampleData, String> series) {
          return _CustomSplineAreaSeriesRenderer(
            series as SplineAreaSeries<_ChartSampleData, String>,
          );
        },
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
  _ChartSampleData({this.x, this.y});
  final String? x;
  final double? y;
}

class _CustomSplineAreaSeriesRenderer<T, D>
    extends SplineAreaSeriesRenderer<T, D> {
  _CustomSplineAreaSeriesRenderer(this.series);

  final SplineAreaSeries<dynamic, dynamic> series;

  List<Color> markerColorList = <Color>[
    const Color.fromRGBO(207, 124, 168, 1),
    const Color.fromRGBO(210, 133, 167, 1),
    const Color.fromRGBO(219, 128, 161, 1),
    const Color.fromRGBO(213, 143, 151, 1),
    const Color.fromRGBO(226, 157, 126, 1),
    const Color.fromRGBO(220, 169, 122, 1),
    const Color.fromRGBO(221, 176, 108, 1),
    const Color.fromRGBO(222, 187, 97, 1),
  ];

  @override
  void drawDataMarker(
    int index,
    Canvas canvas,
    Paint fillPaint,
    Paint strokePaint,
    Offset point,
    Size size,
    DataMarkerType type, [
    CartesianSeriesRenderer<T, D>? seriesRenderer,
  ]) {
    strokePaint.color = Colors.white;
    fillPaint.color = markerColorList[index];
    super.drawDataMarker(
      index,
      canvas,
      fillPaint,
      strokePaint,
      point,
      size,
      type,
      seriesRenderer,
    );
  }
}
