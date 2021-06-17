/// Package import
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// Chart import

/// Local import
import '../../model/sample_view.dart';

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
  final List<_SalesData> _dateTimeChartData = <_SalesData>[
    _SalesData(xval: DateTime(2018, 0, 1), yval: 4),
    _SalesData(xval: DateTime(2018, 0, 2), yval: 4.5),
    _SalesData(xval: DateTime(2018, 0, 3), yval: 8),
    _SalesData(xval: DateTime(2018, 0, 4), yval: 7),
    _SalesData(xval: DateTime(2018, 0, 5), yval: 6),
    _SalesData(xval: DateTime(2018, 0, 8), yval: 8),
    _SalesData(xval: DateTime(2018, 0, 9), yval: 8),
    _SalesData(xval: DateTime(2018, 0, 10), yval: 6.5),
    _SalesData(xval: DateTime(2018, 0, 11), yval: 4),
    _SalesData(xval: DateTime(2018, 0, 12), yval: 5.5),
    _SalesData(xval: DateTime(2018, 0, 15), yval: 8),
    _SalesData(xval: DateTime(2018, 0, 16), yval: 6),
    _SalesData(xval: DateTime(2018, 0, 17), yval: 6.5),
    _SalesData(xval: DateTime(2018, 0, 18), yval: 7.5),
    _SalesData(xval: DateTime(2018, 0, 19), yval: 7.5),
    _SalesData(xval: DateTime(2018, 0, 22), yval: 4),
    _SalesData(xval: DateTime(2018, 0, 23), yval: 8),
    _SalesData(xval: DateTime(2018, 0, 24), yval: 6),
    _SalesData(xval: DateTime(2018, 0, 25), yval: 7.5),
    _SalesData(xval: DateTime(2018, 0, 26), yval: 4.5),
    _SalesData(xval: DateTime(2018, 0, 29), yval: 6),
    _SalesData(xval: DateTime(2018, 0, 30), yval: 5),
    _SalesData(xval: DateTime(2018, 0, 31), yval: 7),
  ];

  final List<_SalesData> _numericdata = <_SalesData>[
    _SalesData(xval: 1, yval: 190),
    _SalesData(xval: 2, yval: 165),
    _SalesData(xval: 3, yval: 158),
    _SalesData(xval: 4, yval: 175),
    _SalesData(xval: 5, yval: 200),
    _SalesData(xval: 6, yval: 180),
    _SalesData(xval: 7, yval: 210),
  ];

  final List<_SalesData> _categorydata = <_SalesData>[
    _SalesData(xval: 'Robert', yval: 60),
    _SalesData(xval: 'Andrew', yval: 65),
    _SalesData(xval: 'Suyama', yval: 70),
    _SalesData(xval: 'Michael', yval: 80),
    _SalesData(xval: 'Janet', yval: 55),
    _SalesData(xval: 'Davolio', yval: 90),
    _SalesData(xval: 'Fuller', yval: 75),
    _SalesData(xval: 'Nancy', yval: 85),
    _SalesData(xval: 'Margaret', yval: 77),
    _SalesData(xval: 'Steven', yval: 68),
    _SalesData(xval: 'Laura', yval: 96),
    _SalesData(xval: 'Elizabeth', yval: 57)
  ];
  @override
  Widget build(BuildContext context) {
    _isVertical =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    if (_isVertical) {
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 5
          : MediaQuery.of(context).size.height / 4.5;
      return model.isWebFullView && model.isMobileResolution
          ? Container(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _buildSparkNumericChart(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _buildSparkCategoryChart(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _buildSparkDatetimeChart(),
                ])))
          : Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _buildSparkNumericChart(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _buildSparkCategoryChart(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  ),
                  _buildSparkDatetimeChart(),
                ]));
    } else {
      _size = MediaQuery.of(context).size.width / 4.5;
      return Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            _buildSparkNumericChart(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            ),
            _buildSparkCategoryChart(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            ),
            _buildSparkDatetimeChart(),
          ]));
    }
  }

  // Get the cartesian chart with default line series
  Widget _buildSparkDatetimeChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              height: _isVertical ? _size : _size * 0.7,
              width: _isVertical ? _size * 1.7 : _size,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              child: Column(children: <Widget>[
                const Text('Average working hours for a month',
                    textAlign: TextAlign.center),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Expanded(
                    child: SfSparkBarChart.custom(
                        axisLineWidth: 0,
                        dataCount: 23,
                        xValueMapper: (int index) =>
                            _dateTimeChartData[index].xval,
                        yValueMapper: (int index) =>
                            _dateTimeChartData[index].yval!,
                        trackball: const SparkChartTrackball(
                            activationMode: SparkChartActivationMode.tap))),
                const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                const Text('DateTime Axis',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ])),
        ]);
  }

// Get the cartesian chart with default line series
  Widget _buildSparkCategoryChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              height: _isVertical ? _size : _size * 0.7,
              width: _isVertical ? _size * 1.7 : _size,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              child: Column(children: <Widget>[
                const Text('Percentage of the students in a class',
                    textAlign: TextAlign.center),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Expanded(
                    child: SfSparkBarChart.custom(
                        axisLineWidth: 0,
                        dataCount: 12,
                        xValueMapper: (int index) => _categorydata[index].xval,
                        yValueMapper: (int index) => _categorydata[index].yval!,
                        trackball: SparkChartTrackball(
                            tooltipFormatter:
                                (TooltipFormatterDetails details) {
                              final String _labelText =
                                  '${details.x} : ${details.y}%';
                              return _labelText;
                            },
                            activationMode: SparkChartActivationMode.tap))),
                const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                const Text('Category Axis',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ])),
        ]);
  }

// Get the cartesian chart with default line series
  Widget _buildSparkNumericChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              height: _isVertical ? _size : _size * 0.7,
              width: _isVertical ? _size * 1.7 : _size,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              child: Column(children: <Widget>[
                const Text('Expenditure details of various trips',
                    textAlign: TextAlign.center),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                ),
                Expanded(
                    child: SfSparkBarChart.custom(
                        axisLineWidth: 0,
                        dataCount: 7,
                        xValueMapper: (int index) => _numericdata[index].xval,
                        yValueMapper: (int index) => _numericdata[index].yval!,
                        trackball: SparkChartTrackball(
                            tooltipFormatter:
                                (TooltipFormatterDetails details) {
                              final String _labelText =
                                  '${details.x} : \$${details.y}';
                              return _labelText;
                            },
                            activationMode: SparkChartActivationMode.tap))),
                const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0)),
                const Text('Numeric Axis',
                    style: TextStyle(fontStyle: FontStyle.italic)),
              ])),
        ]);
  }
}

class _SalesData {
  _SalesData({this.xval, this.yval});
  final dynamic xval;
  final double? yval;
}
