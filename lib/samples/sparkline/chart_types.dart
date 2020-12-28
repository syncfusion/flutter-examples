/// Package import
import 'package:flutter/material.dart';

/// Chart import

/// Local import
import '../../model/sample_view.dart';

import 'package:syncfusion_flutter_charts/sparkcharts.dart';

///Renders default line series chart
class SparklineSeriesTypes extends SampleView {
  ///Creates default line series chart
  const SparklineSeriesTypes(Key key) : super(key: key);

  @override
  _SparklineSeriesTypesState createState() => _SparklineSeriesTypesState();
}

class _SparklineSeriesTypesState extends SampleViewState {
  _SparklineSeriesTypesState();

  double _size = 150;
  bool _isVertical = false;

  @override
  Widget build(BuildContext context) {
    _isVertical =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    if (_isVertical) {
      _size = model.isWeb
          ? MediaQuery.of(context).size.height / 6
          : MediaQuery.of(context).size.height / 6;
      return model.isWeb && model.isMobileResolution
          ? Container(
              child: SingleChildScrollView(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.all(5)),
                _getSparkLineChart(),
                Padding(padding: EdgeInsets.all(5)),
                _getSparkAreaChart(),
                Padding(padding: EdgeInsets.all(5)),
                _getSparkBarChart(),
                Padding(padding: EdgeInsets.all(5)),
                _getSparkWinlossChart(),
              ],
            )))
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(5)),
                Expanded(child: _getSparkLineChart()),
                Padding(padding: EdgeInsets.all(5)),
                Expanded(child: _getSparkAreaChart()),
                Padding(padding: EdgeInsets.all(5)),
                Expanded(child: _getSparkBarChart()),
                Padding(padding: EdgeInsets.all(5)),
                Expanded(child: _getSparkWinlossChart()),
              ],
            ));
    } else {
      _size = MediaQuery.of(context).size.width / 5.5;
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(5)),
          _getSparkLineChart(),
          Padding(padding: EdgeInsets.all(5)),
          _getSparkAreaChart(),
          Padding(padding: EdgeInsets.all(5)),
          _getSparkBarChart(),
          Padding(padding: EdgeInsets.all(5)),
          _getSparkWinlossChart(),
        ],
      ));
    }
  }

  Widget _getSparkLineChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Container(
                  height: _isVertical ? _size : _size * 0.7,
                  width: _isVertical ? _size * 2 : _size,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.4))),
                  child: Column(children: [
                    Expanded(
                        child: SfSparkLineChart(
                      trackball: SparkChartTrackball(
                          activationMode: SparkChartActivationMode.tap),
                      marker: SparkChartMarker(
                          borderWidth: 3,
                          size: 5,
                          shape: SparkChartMarkerShape.circle,
                          displayMode: SparkChartMarkerDisplayMode.all,
                          color: Colors.blue),
                      axisLineWidth: 0,
                      data: <double>[
                        5,
                        6,
                        5,
                        7,
                        4,
                        3,
                        9,
                        5,
                        6,
                        5,
                        7,
                        8,
                        4,
                        5,
                        3,
                        4,
                        11,
                        10,
                        2,
                        12,
                        4,
                        7,
                        6,
                        8
                      ],
                    )),
                    Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                    Text('Spark Line Chart',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ]))),
        ]);
  }

  Widget _getSparkAreaChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Container(
                  height: _isVertical ? _size : _size * 0.7,
                  width: _isVertical ? _size * 2 : _size,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.4))),
                  child: Column(children: [
                    Expanded(
                        child: SfSparkAreaChart(
                            trackball: SparkChartTrackball(
                                activationMode: SparkChartActivationMode.tap),
                            data: <double>[
                              34,
                              36,
                              32,
                              35,
                              40,
                              38,
                              33,
                              37,
                              34,
                              31,
                              30,
                              29
                            ],
                            color: Color.fromRGBO(178, 207, 255, 1),
                            axisLineWidth: 0,
                            borderWidth: 2,
                            borderColor: Color.fromRGBO(60, 120, 239, 1))),
                    Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                    Text('Spark Area Chart',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ]))),
        ]);
  }

  /// Get the cartesian chart with default line series
  Widget _getSparkBarChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Container(
                  height: _isVertical ? _size : _size * 0.7,
                  width: _isVertical ? _size * 2 : _size,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.4))),
                  child: Column(children: [
                    Expanded(
                        child: SfSparkBarChart(
                            axisLineWidth: 0,
                            highPointColor: Color.fromRGBO(20, 170, 33, 1),
                            data: <double>[
                              10,
                              6,
                              8,
                              -5,
                              11,
                              5,
                              -2,
                              7,
                              -3,
                              6,
                              8,
                              10
                            ],
                            trackball: SparkChartTrackball(
                                activationMode: SparkChartActivationMode.tap))),
                    Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                    Text('Spark Bar Chart',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ]))),
        ]);
  }

  /// Get the cartesian chart with default line series
  Widget _getSparkWinlossChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Container(
                  height: _isVertical ? _size : _size * 0.7,
                  width: _isVertical ? _size * 2 : _size,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.4))),
                  child: Column(children: [
                    Expanded(
                        child: SfSparkWinLossChart(
                            data: <double>[
                          12,
                          15,
                          -10,
                          13,
                          15,
                          6,
                          -12,
                          17,
                          13,
                          0,
                          8,
                          -10
                        ],
                            trackball: SparkChartTrackball(
                                activationMode: SparkChartActivationMode.tap))),
                    Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                    Text('Spark Win Loss Chart',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                  ]))),
        ]);
  }
}
