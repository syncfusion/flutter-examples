/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render chart series with horizontal gradient.
class HorizontalGradient extends SampleView {
  /// Creates chart series with horizontal gradient.
  const HorizontalGradient(Key key) : super(key: key);

  @override
  _HorizontalGradientState createState() => _HorizontalGradientState();
}

/// State class of horizontal gradient.
class _HorizontalGradientState extends SampleViewState {
  _HorizontalGradientState();
  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalGradientAreaChart();
  }

  /// Return the circular chart with horizontal gradient.
  SfCartesianChart _buildHorizontalGradientAreaChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Total investment (% of GDP)'),
      primaryXAxis: CategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
          interval: model.isWebFullView ? 1 : null,
          labelRotation: -45,
          majorGridLines: const MajorGridLines(width: 0)),
      tooltipBehavior: _tooltipBehavior,
      primaryYAxis: const NumericAxis(
        interval: 2,
        minimum: 14,
        maximum: 20,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _getGradientAreaSeries(),
    );
  }

  /// Returns the list of spline area series with horizontal gradient.
  List<CartesianSeries<_ChartData, String>> _getGradientAreaSeries() {
    return <CartesianSeries<_ChartData, String>>[
      SplineAreaSeries<_ChartData, String>(
        onCreateRenderer: (ChartSeries<_ChartData, String> series) {
          return _CustomSplineAreaSeriesRenderer(
              series as SplineAreaSeries<_ChartData, String>);
        },

        /// To set the gradient colors for border here.
        borderGradient: const LinearGradient(colors: <Color>[
          Color.fromRGBO(212, 126, 166, 1),
          Color.fromRGBO(222, 187, 104, 1)
        ], stops: <double>[
          0.2,
          0.9
        ]),

        /// To set the gradient colors for series.
        gradient: const LinearGradient(colors: <Color>[
          Color.fromRGBO(224, 139, 207, 0.9),
          Color.fromRGBO(255, 232, 149, 0.9)
        ], stops: <double>[
          0.2,
          0.9
        ]),
        markerSettings: const MarkerSettings(
          isVisible: true,
          borderColor: Colors.white,
        ),
        dataSource: <_ChartData>[
          _ChartData(x: '1997', y: 17.70),
          _ChartData(x: '1998', y: 18.20),
          _ChartData(x: '1999', y: 18),
          _ChartData(x: '2000', y: 19),
          _ChartData(x: '2001', y: 18.5),
          _ChartData(x: '2002', y: 18),
          _ChartData(x: '2003', y: 18.80),
          _ChartData(x: '2004', y: 17.90)
        ],
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        name: 'Investment',
      )
    ];
  }
}

class _ChartData {
  _ChartData({this.x, this.y});
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
    const Color.fromRGBO(222, 187, 97, 1)
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
    super.drawDataMarker(index, canvas, fillPaint, strokePaint, point, size,
        type, seriesRenderer);
  }
}
