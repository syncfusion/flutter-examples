/// Package import
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the default pie series.
class PieGradient extends SampleView {
  /// Creates the default pie series.
  const PieGradient(Key key) : super(key: key);

  @override
  _PieGradientState createState() => _PieGradientState();
}

/// State class of pie series.
class _PieGradientState extends SampleViewState {
  _PieGradientState();
  late List<Color> colors;

  late List<double> stops;
  late String _shaderType;
  late List<String> _shader;

  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    final double screenWidth =
        model.isWebFullView ? 245 : MediaQuery.of(context).size.width;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: Text('Gradient mode',
                style: TextStyle(
                  color: model.textColor,
                )),
            trailing: Container(
              padding: EdgeInsets.only(left: 0.07 * screenWidth),
              width: 0.5 * screenWidth,
              height: 50,
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: _shaderType,
                  items: _shader.map((String value) {
                    return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'point',
                        child: Text(value,
                            style: TextStyle(color: model.textColor)));
                  }).toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      onShaderTyeChange(value);
                      stateSetter(() {});
                    });
                  }),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultPieChart();
  }

  void _initializeVariables() {
    colors = const <Color>[
      Color.fromRGBO(96, 87, 234, 1),
      Color.fromRGBO(59, 141, 236, 1),
      Color.fromRGBO(112, 198, 129, 1),
      Color.fromRGBO(237, 241, 81, 1)
    ];
    stops = <double>[0.25, 0.5, 0.75, 1];
    _shader = <String>['linear', 'sweep', 'radial'].toList();
    _shaderType = 'sweep';
  }

  /// Returns the circular  chart with pie series.
  SfCircularChart _buildDefaultPieChart() {
    return SfCircularChart(
      onCreateShader: (ChartShaderDetails chartShaderDetails) {
        if (_shaderType == 'linear') {
          return ui.Gradient.linear(chartShaderDetails.outerRect.topRight,
              chartShaderDetails.outerRect.centerLeft, colors, stops);
        } else if (_shaderType == 'radial') {
          return ui.Gradient.radial(
              chartShaderDetails.outerRect.center,
              chartShaderDetails.outerRect.right -
                  chartShaderDetails.outerRect.center.dx,
              colors,
              stops);
        } else {
          return ui.Gradient.sweep(
              chartShaderDetails.outerRect.center,
              colors,
              stops,
              TileMode.clamp,
              _degreeToRadian(0),
              _degreeToRadian(360),
              _resolveTransform(
                  chartShaderDetails.outerRect, TextDirection.ltr));
        }
      },
      title: ChartTitle(text: isCardView ? '' : 'Sales by sales person'),
      legend: Legend(isVisible: !isCardView),
      series: _getDefaultPieSeries(),
    );
  }

  /// Returns the pie series.
  List<PieSeries<ChartSampleData, String>> _getDefaultPieSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'David', y: 17, text: 'David \n 17%'),
      ChartSampleData(x: 'Steve', y: 20, text: 'Steve \n 20%'),
      ChartSampleData(x: 'Jack', y: 25, text: 'Jack \n 25%'),
      ChartSampleData(x: 'Others', y: 38, text: 'Others \n 38%')
    ];
    return <PieSeries<ChartSampleData, String>>[
      PieSeries<ChartSampleData, String>(
          dataSource: pieData,
          explodeAll: true,
          explodeOffset: '3%',
          explode: true,
          strokeColor: model.currentThemeData?.brightness == Brightness.light
              ? Colors.black.withOpacity(0.3)
              : Colors.white.withOpacity(0.3),
          strokeWidth: 1.5,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: const TextStyle(fontSize: 13, color: Colors.white),
          ),
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text),
    ];
  }

  dynamic _resolveTransform(Rect bounds, TextDirection textDirection) {
    final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
    return transform.transform(bounds, textDirection: textDirection)!.storage;
  }

  void onShaderTyeChange(String item) {
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

  // Convert degree to radian
  double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);
}
