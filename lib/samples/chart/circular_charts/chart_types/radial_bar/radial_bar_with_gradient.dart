/// Package import
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the default radial bar.
class RadialBarGradient extends SampleView {
  /// Creates the default radial bar.
  const RadialBarGradient(Key key) : super(key: key);

  @override
  _RadialBarGradientState createState() => _RadialBarGradientState();
}

/// State class of radial bar.
class _RadialBarGradientState extends SampleViewState {
  _RadialBarGradientState();
  late TooltipBehavior _tooltipBehavior;

  late List<Color> colors;

  late List<double> stops;

  @override
  void initState() {
    colors = const <Color>[
      Colors.red,
      Colors.yellow,
      Colors.green,
    ];
    stops = <double>[0.3, 0.6, 0.9];
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.ym');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultRadialBarChart();
  }

  /// Returns the circular chart with radial series.
  SfCircularChart _buildDefaultRadialBarChart() {
    return SfCircularChart(
        key: GlobalKey(),
        onCreateShader: (ChartShaderDetails chartShaderDetails) {
          return ui.Gradient.sweep(
              chartShaderDetails.outerRect.center,
              colors,
              stops,
              TileMode.clamp,
              _degreeToRadian(0),
              _degreeToRadian(360),
              _resolveTransform(
                  chartShaderDetails.outerRect, TextDirection.ltr));
        },
        legend: Legend(
            isVisible: !isCardView,
            iconHeight: 20,
            iconWidth: 20,
            textStyle: const TextStyle(fontSize: 15)),
        title: ChartTitle(text: isCardView ? '' : 'Shot put distance'),
        series: _getRadialBarGradientSeries(),
        tooltipBehavior: _tooltipBehavior);
  }

  /// Returns default radial series.
  List<RadialBarSeries<_ChartShaderData, String>>
      _getRadialBarGradientSeries() {
    final List<_ChartShaderData> chartData = <_ChartShaderData>[
      _ChartShaderData('John', 10, '100%'),
      _ChartShaderData('Almaida', 11, '100%'),
      _ChartShaderData('Don', 12, '100%'),
    ];
    return <RadialBarSeries<_ChartShaderData, String>>[
      RadialBarSeries<_ChartShaderData, String>(
          maximumValue: 15,
          dataLabelSettings: DataLabelSettings(
              isVisible: true, textStyle: const TextStyle(fontSize: 10.0)),
          dataSource: chartData,
          cornerStyle: CornerStyle.bothCurve,
          gap: '10%',
          radius: '90%',
          xValueMapper: (_ChartShaderData data, _) => data.x,
          yValueMapper: (_ChartShaderData data, _) => data.y,
          pointRadiusMapper: (_ChartShaderData data, _) => data.text,
          dataLabelMapper: (_ChartShaderData data, _) => data.x)
    ];
  }

  dynamic _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  // Convert degree to radian
  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);
}

class _ChartShaderData {
  _ChartShaderData(this.x, this.y, this.text);

  final String x;

  final num y;

  final String text;
}
