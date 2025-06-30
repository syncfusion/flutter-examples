/// Dart import.
import 'dart:ui' as ui;

/// Package import.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default doughnut series chart filled with a gradient.
class DoughnutGradient extends SampleView {
  /// Creates the default doughnut series chart filled with a gradient.
  const DoughnutGradient(Key key) : super(key: key);

  @override
  _DoughnutGradientState createState() => _DoughnutGradientState();
}

/// State class for the default doughnut series chart filled with a gradient.
class _DoughnutGradientState extends SampleViewState {
  _DoughnutGradientState();
  late String _shaderType;
  late List<ChartSampleData> _chartData;

  List<Color>? _gradientColors;
  List<double>? _gradientStops;
  List<String>? _shaderTypes;
  List<double>? _customStops;

  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  void _initializeVariables() {
    _gradientColors = const <Color>[
      Color.fromRGBO(96, 87, 234, 1),
      Color.fromRGBO(59, 141, 236, 1),
      Color.fromRGBO(112, 198, 129, 1),
      Color.fromRGBO(237, 241, 81, 1),
    ];
    _shaderType = 'sweep';
    _shaderTypes = <String>['linear', 'sweep', 'radial'].toList();
    _gradientStops = <double>[0.25, 0.5, 0.75, 1];
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'David', y: 14, text: '14%'),
      ChartSampleData(x: 'Steve', y: 15, text: '15%'),
      ChartSampleData(x: 'Jack', y: 30, text: '30%'),
      ChartSampleData(x: 'Others', y: 41, text: '41%'),
    ];
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth = model.isWebFullView
        ? 245
        : MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  model.isWebFullView ? 'Gradient \nmode' : 'Gradient mode',
                  softWrap: false,
                  style: TextStyle(fontSize: 16, color: model.textColor),
                ),
                Container(
                  padding: EdgeInsets.only(left: 0.07 * screenWidth),
                  width: 0.5 * screenWidth,
                  alignment: Alignment.bottomLeft,
                  child: DropdownButton<String>(
                    dropdownColor: model.drawerBackgroundColor,
                    focusColor: Colors.transparent,
                    underline: Container(
                      color: const Color(0xFFBDBDBD),
                      height: 1,
                    ),
                    value: _shaderType,
                    items: _shaderTypes!.map((String value) {
                      return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'point',
                        child: Text(
                          value,
                          style: TextStyle(color: model.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (dynamic value) {
                      setState(() {
                        _onShaderTyeChange(value);
                        stateSetter(() {});
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGradientDoughnutChart();
  }

  /// Returns a circular doughnut chart filled with gradient.
  SfCircularChart _buildGradientDoughnutChart() {
    return SfCircularChart(
      onCreateShader: (ChartShaderDetails chartShaderDetails) {
        if (chartShaderDetails.renderType == 'series') {
          _customStops = _computeDoughnutStopOffsets(
            _gradientColors!,
            _gradientStops!,
            chartShaderDetails.outerRect,
            chartShaderDetails.innerRect!,
          );
        }
        if (_shaderType == 'linear') {
          return ui.Gradient.linear(
            chartShaderDetails.outerRect.topRight,
            chartShaderDetails.outerRect.centerLeft,
            _gradientColors!,
            _gradientStops,
          );
        } else if (_shaderType == 'radial') {
          return ui.Gradient.radial(
            chartShaderDetails.outerRect.center,
            chartShaderDetails.outerRect.right -
                chartShaderDetails.outerRect.center.dx,
            _gradientColors!,
            _customStops,
          );
        } else {
          return ui.Gradient.sweep(
            chartShaderDetails.outerRect.center,
            _gradientColors!,
            _gradientStops,
            TileMode.clamp,
            _degreeToRadian(0),
            _degreeToRadian(360),
            _resolveTransform(chartShaderDetails.outerRect, TextDirection.ltr),
          );
        }
      },
      title: ChartTitle(text: isCardView ? '' : 'Sales by sales person'),
      legend: Legend(isVisible: !isCardView),
      series: _buildDoughnutSeries(),
    );
  }

  /// Returns the circular doughnut series.
  List<DoughnutSeries<ChartSampleData, String>> _buildDoughnutSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        animationDuration: 0,
        explodeAll: true,
        radius: isCardView ? '85%' : '63%',
        explodeOffset: '3%',
        explode: true,
        strokeColor: model.themeData.brightness == Brightness.light
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.3),
        strokeWidth: 1.5,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
          connectorLineSettings: ConnectorLineSettings(
            color: model.themeData.brightness == Brightness.light
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.white,
            width: 1.5,
            length: isCardView ? '7%' : '10%',
            type: ConnectorType.curve,
          ),
        ),
      ),
    ];
  }

  dynamic _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  void _onShaderTyeChange(String item) {
    _shaderType = item;
    setState(() {
      if (_shaderType == 'linear') {
        _shaderType = 'linear';
      }

      if (_shaderType == 'radial') {
        _shaderType = 'radial';
      }
      if (_shaderType == 'sweep') {
        _shaderType = 'sweep';
      }
    });
  }

  /// Converts degree to radian.
  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);

  List<double> _computeDoughnutStopOffsets(
    List<Color> colors,
    List<double> stops,
    Rect outerRect,
    Rect innerRect,
  ) {
    final List<double> defaultStopOffsets = <double>[0.625, 0.75, 0.875, 1.0];
    final num chartStart = innerRect.right;
    final Offset chartCenter = outerRect.center;
    final num chartEnd = outerRect.right;

    List<double> stopOffsets = <double>[];

    num diffCenterEnd;
    num diffStartEnd;
    num diffCenterStart;
    num centerStops;

    diffCenterEnd = chartEnd - chartCenter.dx;
    diffStartEnd = chartEnd - chartStart;
    diffCenterStart = chartStart - chartCenter.dx;
    centerStops = diffCenterStart / diffCenterEnd;

    for (int i = 0; i < colors.length; i++) {
      if (i == 0) {
        stopOffsets.add(centerStops += diffStartEnd * stops[i] / diffCenterEnd);
      } else {
        stopOffsets.add(
          centerStops +=
              (diffStartEnd * (stops[i] - stops[i - 1])) / diffCenterEnd,
        );
      }
    }
    stopOffsets = listEquals(stopOffsets, defaultStopOffsets)
        ? stopOffsets
        : defaultStopOffsets;
    return stopOffsets;
  }

  @override
  void dispose() {
    _gradientStops!.clear();
    _shaderTypes!.clear();
    _chartData.clear();
    _customStops!.clear();
    super.dispose();
  }
}
