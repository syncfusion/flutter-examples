/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the spline area series chart
/// with vertical gradient.
class VerticalGradient extends SampleView {
  /// Creates the spline area series chart
  /// with vertical gradient.
  const VerticalGradient(Key key) : super(key: key);

  @override
  _VerticalGradientState createState() => _VerticalGradientState();
}

/// State class for the spline area series chart
/// with vertical gradient.
class _VerticalGradientState extends SampleViewState {
  _VerticalGradientState();
  List<_ChartSampleData>? _chartData1;
  List<_ChartSampleData>? _chartData2;

  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
    _chartData1 = <_ChartSampleData>[
      _ChartSampleData(x: '1997', y: 22.44),
      _ChartSampleData(x: '1998', y: 25.18),
      _ChartSampleData(x: '1999', y: 24.15),
      _ChartSampleData(x: '2000', y: 25.83),
      _ChartSampleData(x: '2001', y: 25.69),
      _ChartSampleData(x: '2002', y: 24.75),
      _ChartSampleData(x: '2003', y: 27.38),
      _ChartSampleData(x: '2004', y: 25.31),
    ];
    _chartData2 = <_ChartSampleData>[
      _ChartSampleData(x: '1997', y: 17.5),
      _ChartSampleData(x: '1998', y: 21.5),
      _ChartSampleData(x: '1999', y: 19.5),
      _ChartSampleData(x: '2000', y: 22.5),
      _ChartSampleData(x: '2001', y: 21.5),
      _ChartSampleData(x: '2002', y: 20.5),
      _ChartSampleData(x: '2003', y: 23.5),
      _ChartSampleData(x: '2004', y: 19.5),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildVerticalGradientAreaChart();
  }

  /// Returns the cartesian spline area chart with vertical gradient.
  SfCartesianChart _buildVerticalGradientAreaChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.onTicks,
        interval: model.isWebFullView ? 1 : null,
        labelRotation: -45,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 16,
        maximum: 28,
        interval: 4,
        labelFormat: '{value}%',
        axisLine: AxisLine(width: 0),
      ),
      trackballBehavior: _trackballBehavior,
      series: _buildAreaSeries(),
    );
  }

  /// Returns the list of cartesian spline area series.
  List<CartesianSeries<_ChartSampleData, String>> _buildAreaSeries() {
    return <CartesianSeries<_ChartSampleData, String>>[
      SplineAreaSeries<_ChartSampleData, String>(
        dataSource: _chartData1,
        xValueMapper: (_ChartSampleData data, int index) => data.x,
        yValueMapper: (_ChartSampleData data, int index) => data.y,

        borderColor: const Color.fromRGBO(0, 156, 144, 1),

        /// To set the gradient colors for series.
        gradient: const LinearGradient(
          colors: <Color>[
            Color.fromRGBO(269, 210, 255, 1),
            Color.fromRGBO(143, 236, 154, 1),
          ],
          stops: <double>[0.2, 0.6],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        name: 'Country 1',
      ),
      SplineAreaSeries<_ChartSampleData, String>(
        dataSource: _chartData2,
        xValueMapper: (_ChartSampleData data, int index) => data.x,
        yValueMapper: (_ChartSampleData data, int index) => data.y,
        borderColor: const Color.fromRGBO(0, 63, 136, 1),
        gradient: const LinearGradient(
          colors: <Color>[
            Color.fromRGBO(140, 108, 245, 1),
            Color.fromRGBO(125, 185, 253, 1),
          ],
          stops: <double>[0.3, 0.7],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        name: 'Country 2',
      ),
    ];
  }

  @override
  void dispose() {
    _chartData1!.clear();
    _chartData2!.clear();
    super.dispose();
  }
}

class _ChartSampleData {
  _ChartSampleData({this.x, this.y});
  final String? x;
  final double? y;
}
