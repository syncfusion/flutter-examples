/// Dart import.
import 'dart:ui' as ui;

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../../model/sample_view.dart';

/// Renders the default pie series chart filled with a gradient.
class PieGradient extends SampleView {
  /// Creates the default pie series chart filled with a gradient.
  const PieGradient(Key key) : super(key: key);

  @override
  _PieGradientState createState() => _PieGradientState();
}

/// State class for the default pie series chart filled with a gradient.
class _PieGradientState extends SampleViewState {
  _PieGradientState();
  late String _shaderType;
  late List<ChartSampleData> _chartData;

  List<Color>? _gradientColors;
  List<double>? _gradientStops;
  List<String>? _shaderTypes;

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
    _gradientStops = <double>[0.25, 0.5, 0.75, 1];
    _shaderTypes = <String>['linear', 'sweep', 'radial'].toList();
    _shaderType = 'sweep';
    _chartData = <ChartSampleData>[
      ChartSampleData(x: 'David', y: 17, text: 'David \n 17%'),
      ChartSampleData(x: 'Steve', y: 20, text: 'Steve \n 20%'),
      ChartSampleData(x: 'Jack', y: 25, text: 'Jack \n 25%'),
      ChartSampleData(x: 'Others', y: 38, text: 'Others \n 38%'),
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
            _buildGradientModeDropdown(screenWidth, stateSetter),
          ],
        );
      },
    );
  }

  /// Builds a row containing the gradient mode label and dropdown.
  Widget _buildGradientModeDropdown(
    double screenWidth,
    StateSetter stateSetter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          model.isWebFullView ? 'Gradient \nmode' : 'Gradient mode',
          softWrap: false,
          style: TextStyle(fontSize: 16, color: model.textColor),
        ),
        Container(
          width: 0.5 * screenWidth,
          alignment: Alignment.bottomLeft,
          child: DropdownButton<String>(
            dropdownColor: model.drawerBackgroundColor,
            focusColor: Colors.transparent,
            underline: Container(color: const Color(0xFFBDBDBD), height: 1),
            value: _shaderType,
            items: _shaderTypes!.map((String value) {
              return DropdownMenuItem<String>(
                value: (value != null) ? value : 'point',
                child: Text(value, style: TextStyle(color: model.textColor)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultPieChart();
  }

  /// Returns a circular pie chart filled with a gradient.
  SfCircularChart _buildDefaultPieChart() {
    return SfCircularChart(
      onCreateShader: (ChartShaderDetails chartShaderDetails) {
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
            _gradientStops,
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
      series: _buildDefaultPieSeries(),
    );
  }

  /// Returns a circular pie series.
  List<PieSeries<ChartSampleData, String>> _buildDefaultPieSeries() {
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        animationDuration: 0,
        explodeAll: true,
        explodeOffset: '3%',
        explode: true,
        strokeColor: model.themeData.brightness == Brightness.light
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.3),
        strokeWidth: 1.5,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 13, color: Colors.white),
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

  /// Convert degree to radian.
  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);

  @override
  void dispose() {
    _chartData.clear();
    _gradientStops!.clear();
    _shaderTypes!.clear();
    super.dispose();
  }
}
