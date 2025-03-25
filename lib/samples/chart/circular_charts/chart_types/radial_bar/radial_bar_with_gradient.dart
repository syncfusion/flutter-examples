/// Dart import.
import 'dart:ui' as ui;

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Render the default radial bar series chart filled with a gradient.
class RadialBarGradient extends SampleView {
  /// Creates the default radial bar series chart filled with a gradient.
  const RadialBarGradient(Key key) : super(key: key);

  @override
  _RadialBarGradientState createState() => _RadialBarGradientState();
}

/// State class for the radial bar series chart filled with a gradient.
class _RadialBarGradientState extends SampleViewState {
  _RadialBarGradientState();
  TooltipBehavior? _tooltipBehavior;
  List<Color>? _gradientColors;
  List<double>? _gradientStops;
  List<_ChartShaderData>? _chartData;

  @override
  void initState() {
    _gradientColors = const <Color>[Colors.red, Colors.yellow, Colors.green];
    _gradientStops = <double>[0.3, 0.6, 0.9];
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.ym',
    );
    _chartData = <_ChartShaderData>[
      _ChartShaderData('John', 10, '100%'),
      _ChartShaderData('Almaida', 11, '100%'),
      _ChartShaderData('Don', 12, '100%'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultRadialBarChart();
  }

  /// Returns a circular bar chart filled with a gradient.
  SfCircularChart _buildDefaultRadialBarChart() {
    return SfCircularChart(
      onCreateShader: (ChartShaderDetails chartShaderDetails) {
        return ui.Gradient.sweep(
          chartShaderDetails.outerRect.center,
          _gradientColors!,
          _gradientStops,
          TileMode.clamp,
          _degreeToRadian(0),
          _degreeToRadian(360),
          _resolveTransform(chartShaderDetails.outerRect, TextDirection.ltr),
        );
      },
      legend: Legend(
        isVisible: !isCardView,
        iconHeight: 20,
        iconWidth: 20,
        textStyle: const TextStyle(fontSize: 15),
      ),
      title: ChartTitle(text: isCardView ? '' : 'Shot put distance'),
      series: _buildRadialBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns circular radial bar series.
  List<RadialBarSeries<_ChartShaderData, String>> _buildRadialBarSeries() {
    return <RadialBarSeries<_ChartShaderData, String>>[
      RadialBarSeries<_ChartShaderData, String>(
        dataSource: _chartData,
        xValueMapper: (_ChartShaderData data, int index) => data.x,
        yValueMapper: (_ChartShaderData data, int index) => data.y,
        pointRadiusMapper: (_ChartShaderData data, int index) => data.text,
        dataLabelMapper: (_ChartShaderData data, int index) => data.x,
        maximumValue: 15,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 10.0),
        ),
        cornerStyle: CornerStyle.bothCurve,
        gap: '10%',
        radius: '90%',
      ),
    ];
  }

  dynamic _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  // Convert degree to radian.
  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);

  @override
  void dispose() {
    _chartData!.clear();
    _gradientStops!.clear();
    super.dispose();
  }
}

class _ChartShaderData {
  _ChartShaderData(this.x, this.y, this.text);

  final String x;

  final num y;

  final String text;
}
