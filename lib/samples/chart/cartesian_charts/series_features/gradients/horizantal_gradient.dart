/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render chart series with horizontal gradient.
class HorizantalGradient extends SampleView {
  /// Creates chart series with horizontal gradient.
  const HorizantalGradient(Key key) : super(key: key);

  @override
  _HorizantalGradientState createState() => _HorizantalGradientState();
}

/// State class of horizontal gradient.
class _HorizantalGradientState extends SampleViewState {
  _HorizantalGradientState();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHorizantalGradientAreaChart();
  }

  /// Return the circular chart with horizontal gradient.
  SfCartesianChart _buildHorizantalGradientAreaChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: isCardView ? '' : 'Total investment (% of GDP)'),
      primaryXAxis: CategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
          interval: model.isWebFullView ? 1 : null,
          labelRotation: -45,
          majorGridLines: const MajorGridLines(width: 0)),
      tooltipBehavior: _tooltipBehavior,
      primaryYAxis: NumericAxis(
          interval: 2,
          minimum: 14,
          maximum: 20,
          labelFormat: '{value}%',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getGradientAreaSeries(),
      onMarkerRender: (MarkerRenderArgs args) {
        if (args.pointIndex == 0) {
          args.color = const Color.fromRGBO(207, 124, 168, 1);
        } else if (args.pointIndex == 1) {
          args.color = const Color.fromRGBO(210, 133, 167, 1);
        } else if (args.pointIndex == 2) {
          args.color = const Color.fromRGBO(219, 128, 161, 1);
        } else if (args.pointIndex == 3) {
          args.color = const Color.fromRGBO(213, 143, 151, 1);
        } else if (args.pointIndex == 4) {
          args.color = const Color.fromRGBO(226, 157, 126, 1);
        } else if (args.pointIndex == 5) {
          args.color = const Color.fromRGBO(220, 169, 122, 1);
        } else if (args.pointIndex == 6) {
          args.color = const Color.fromRGBO(221, 176, 108, 1);
        } else if (args.pointIndex == 7) {
          args.color = const Color.fromRGBO(222, 187, 97, 1);
        }
      },
    );
  }

  /// Returns the list of spline area series with horizontal gradient.
  List<ChartSeries<_ChartData, String>> _getGradientAreaSeries() {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData(x: '1997', y: 17.70),
      _ChartData(x: '1998', y: 18.20),
      _ChartData(x: '1999', y: 18),
      _ChartData(x: '2000', y: 19),
      _ChartData(x: '2001', y: 18.5),
      _ChartData(x: '2002', y: 18),
      _ChartData(x: '2003', y: 18.80),
      _ChartData(x: '2004', y: 17.90)
    ];
    final List<Color> color = <Color>[];
    color.add(Colors.blue[200]!);
    color.add(Colors.orange[200]!);

    final List<double> stops = <double>[];
    stops.add(0.2);
    stops.add(0.7);

    return <ChartSeries<_ChartData, String>>[
      SplineAreaSeries<_ChartData, String>(
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
        borderWidth: 2,
        markerSettings: const MarkerSettings(
            isVisible: true,
            height: 8,
            width: 8,
            borderColor: Colors.white,
            borderWidth: 2),
        borderDrawMode: BorderDrawMode.top,
        dataSource: chartData,
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
