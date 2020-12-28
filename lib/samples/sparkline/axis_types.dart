/// Package import
import 'package:flutter/material.dart';

/// Chart import

/// Local import
import '../../model/sample_view.dart';

import 'package:syncfusion_flutter_charts/sparkcharts.dart';

///Renders default line series chart
class SparklineAxesTypes extends SampleView {
  ///Creates default line series chart
  const SparklineAxesTypes(Key key) : super(key: key);

  @override
  _SparklineAxesTypesState createState() => _SparklineAxesTypesState();
}

class _SparklineAxesTypesState extends SampleViewState {
  _SparklineAxesTypesState();
  double _size = 150;
  bool _isVertical = false;
  final List<SalesData> _dateTimeChartData = [
    SalesData(xval: DateTime(2018, 0, 1), yval: 4),
    SalesData(xval: DateTime(2018, 0, 2), yval: 4.5),
    SalesData(xval: DateTime(2018, 0, 3), yval: 8),
    SalesData(xval: DateTime(2018, 0, 4), yval: 7),
    SalesData(xval: DateTime(2018, 0, 5), yval: 6),
    SalesData(xval: DateTime(2018, 0, 8), yval: 8),
    SalesData(xval: DateTime(2018, 0, 9), yval: 8),
    SalesData(xval: DateTime(2018, 0, 10), yval: 6.5),
    SalesData(xval: DateTime(2018, 0, 11), yval: 4),
    SalesData(xval: DateTime(2018, 0, 12), yval: 5.5),
    SalesData(xval: DateTime(2018, 0, 15), yval: 8),
    SalesData(xval: DateTime(2018, 0, 16), yval: 6),
    SalesData(xval: DateTime(2018, 0, 17), yval: 6.5),
    SalesData(xval: DateTime(2018, 0, 18), yval: 7.5),
    SalesData(xval: DateTime(2018, 0, 19), yval: 7.5),
    SalesData(xval: DateTime(2018, 0, 22), yval: 4),
    SalesData(xval: DateTime(2018, 0, 23), yval: 8),
    SalesData(xval: DateTime(2018, 0, 24), yval: 6),
    SalesData(xval: DateTime(2018, 0, 25), yval: 7.5),
    SalesData(xval: DateTime(2018, 0, 26), yval: 4.5),
    SalesData(xval: DateTime(2018, 0, 29), yval: 6),
    SalesData(xval: DateTime(2018, 0, 30), yval: 5),
    SalesData(xval: DateTime(2018, 0, 31), yval: 7),
  ];

  final List<SalesData> _numericdata = [
    SalesData(xval: 1, yval: 190),
    SalesData(xval: 2, yval: 165),
    SalesData(xval: 3, yval: 158),
    SalesData(xval: 4, yval: 175),
    SalesData(xval: 5, yval: 200),
    SalesData(xval: 6, yval: 180),
    SalesData(xval: 7, yval: 210),
  ];

  final List<SalesData> _categorydata = [
    SalesData(xval: 'Robert', yval: 60),
    SalesData(xval: 'Andrew', yval: 65),
    SalesData(xval: 'Suyama', yval: 70),
    SalesData(xval: 'Michael', yval: 80),
    SalesData(xval: 'Janet', yval: 55),
    SalesData(xval: 'Davolio', yval: 90),
    SalesData(xval: 'Fuller', yval: 75),
    SalesData(xval: 'Nancy', yval: 85),
    SalesData(xval: 'Margaret', yval: 77),
    SalesData(xval: 'Steven', yval: 68),
    SalesData(xval: 'Laura', yval: 96),
    SalesData(xval: 'Elizabeth', yval: 57)
  ];
  @override
  Widget build(BuildContext context) {
    _isVertical =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    if (_isVertical) {
      _size = model.isWeb
          ? MediaQuery.of(context).size.height / 5
          : MediaQuery.of(context).size.height / 4.5;
      return model.isWeb && model.isMobileResolution
          ? Container(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _getSparkNumericChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _getSparkCategoryChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _getSparkDatetimeChart(),
                ])))
          : Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _getSparkNumericChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _getSparkCategoryChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _getSparkDatetimeChart(),
                ]));
    } else {
      _size = MediaQuery.of(context).size.width / 4.5;
      return Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            _getSparkNumericChart(),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            ),
            _getSparkCategoryChart(),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            ),
            _getSparkDatetimeChart(),
          ]));
    }
  }

  // Get the cartesian chart with default line series
  Widget _getSparkDatetimeChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: _isVertical ? _size : _size * 0.7,
              width: _isVertical ? _size * 1.7 : _size,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              child: Column(children: [
                Text('Average working hours for a month',
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Expanded(
                    child: SfSparkBarChart.custom(
                        axisLineWidth: 0,
                        dataCount: 23,
                        xValueMapper: (num index) =>
                            _dateTimeChartData[index].xval,
                        yValueMapper: (num index) =>
                            _dateTimeChartData[index].yval,
                        trackball: SparkChartTrackball(
                            activationMode: SparkChartActivationMode.tap))),
                Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                Text('DateTime Axis',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ])),
        ]);
  }

// Get the cartesian chart with default line series
  Widget _getSparkCategoryChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: _isVertical ? _size : _size * 0.7,
              width: _isVertical ? _size * 1.7 : _size,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              child: Column(children: [
                Text('Percentage of the students in a class',
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Expanded(
                    child: SfSparkBarChart.custom(
                        axisLineWidth: 0,
                        dataCount: 12,
                        xValueMapper: (num index) => _categorydata[index].xval,
                        yValueMapper: (num index) => _categorydata[index].yval,
                        trackball: SparkChartTrackball(
                            tooltipFormatter:
                                (TooltipFormatterDetails details) {
                              String _labelText =
                                  '${details.x} : ${details.y}%';
                              return _labelText;
                            },
                            activationMode: SparkChartActivationMode.tap))),
                Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                Text('Category Axis',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ])),
        ]);
  }

// Get the cartesian chart with default line series
  Widget _getSparkNumericChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: _isVertical ? _size : _size * 0.7,
              width: _isVertical ? _size * 1.7 : _size,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              child: Column(children: [
                Text('Expenditure details of various trips',
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Expanded(
                    child: SfSparkBarChart.custom(
                        axisLineWidth: 0,
                        dataCount: 7,
                        xValueMapper: (num index) => _numericdata[index].xval,
                        yValueMapper: (num index) => _numericdata[index].yval,
                        trackball: SparkChartTrackball(
                            tooltipFormatter:
                                (TooltipFormatterDetails details) {
                              String _labelText =
                                  '${details.x} : \$${details.y}';
                              return _labelText;
                            },
                            activationMode: SparkChartActivationMode.tap))),
                Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                Text('Numeric Axis',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ])),
        ]);
  }
}

class SalesData {
  SalesData({this.xval, this.yval});
  final dynamic xval;
  final double yval;
}
