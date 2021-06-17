/// Package import
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

/// Render the default pie series.
class DoughnutGradient extends SampleView {
  /// Creates the default pie series.
  const DoughnutGradient(Key key) : super(key: key);

  @override
  _DoughnutGradientState createState() => _DoughnutGradientState();
}

/// State class of pie series.
class _DoughnutGradientState extends SampleViewState {
  _DoughnutGradientState();
  late List<Color> colors;

  late List<double> stops;
  late String _shaderType;
  late List<String> _shader;
  late List<double> customStops;

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
    return _buildGradientDoughnutChart();
  }

  void _initializeVariables() {
    colors = const <Color>[
      Color.fromRGBO(96, 87, 234, 1),
      Color.fromRGBO(59, 141, 236, 1),
      Color.fromRGBO(112, 198, 129, 1),
      Color.fromRGBO(237, 241, 81, 1)
    ];
    _shaderType = 'sweep';
    _shader = <String>['linear', 'sweep', 'radial'].toList();
    stops = <double>[0.25, 0.5, 0.75, 1];
  }

  /// Returns the circular  chart with pie series.
  SfCircularChart _buildGradientDoughnutChart() {
    return SfCircularChart(
      onCreateShader: (ChartShaderDetails chartShaderDetails) {
        if (chartShaderDetails.renderType == 'series') {
          customStops = _calculateDoughnut(colors, stops,
              chartShaderDetails.outerRect, chartShaderDetails.innerRect!);
        }
        if (_shaderType == 'linear') {
          return ui.Gradient.linear(chartShaderDetails.outerRect.topRight,
              chartShaderDetails.outerRect.centerLeft, colors, stops);
        } else if (_shaderType == 'radial') {
          return ui.Gradient.radial(
              chartShaderDetails.outerRect.center,
              chartShaderDetails.outerRect.right -
                  chartShaderDetails.outerRect.center.dx,
              colors,
              customStops);
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
      series: _getGradientDoughnutSeries(),
    );
  }

  /// Returns the pie series.
  List<DoughnutSeries<ChartSampleData, String>> _getGradientDoughnutSeries() {
    final List<ChartSampleData> pieData = <ChartSampleData>[
      ChartSampleData(x: 'David', y: 14, text: '14%'),
      ChartSampleData(x: 'Steve', y: 15, text: '15%'),
      ChartSampleData(x: 'Jack', y: 30, text: '30%'),
      ChartSampleData(x: 'Others', y: 41, text: '41%')
    ];
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          dataSource: pieData,
          explodeAll: true,
          radius: isCardView ? '85%' : '63%',
          explodeOffset: '3%',
          explode: true,
          strokeColor: model.currentThemeData?.brightness == Brightness.light
              ? Colors.black.withOpacity(0.3)
              : Colors.white.withOpacity(0.3),
          strokeWidth: 1.5,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings: ConnectorLineSettings(
              color: model.currentThemeData?.brightness == Brightness.light
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white,
              width: 1.5,
              length: isCardView ? '7%' : '10%',
              type: ConnectorType.curve,
            ),
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

  List<double> _calculateDoughnut(
      List<Color> colors, List<double> stops, Rect outerRect, Rect innerRect) {
    final List<double> stopOffsets = <double>[];
    final num _chartStart = innerRect.right;
    final Offset _chartCenter = outerRect.center;
    final num _chartend = outerRect.right;
    num diffCenterEnd;
    num diffStartEnd;
    num diffCenterStart;
    num centerStops;
    diffCenterEnd = _chartend - _chartCenter.dx;
    diffStartEnd = _chartend - _chartStart;
    diffCenterStart = _chartStart - _chartCenter.dx;
    centerStops = diffCenterStart / diffCenterEnd;
    for (int i = 0; i < colors.length; i++) {
      if (i == 0) {
        stopOffsets.add(centerStops += diffStartEnd * stops[i] / diffCenterEnd);
      } else {
        stopOffsets.add(centerStops +=
            (diffStartEnd * (stops[i] - stops[i - 1])) / diffCenterEnd);
      }
    }
    return stopOffsets;
  }
}
