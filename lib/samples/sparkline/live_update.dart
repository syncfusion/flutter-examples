///Dart imports
import 'dart:async';
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';

///Local import
import '../../model/sample_view.dart';

import 'package:syncfusion_flutter_charts/sparkcharts.dart';

/// Widget of the AgendaView Calendar.
class SparklineLiveUpdate extends SampleView {
  const SparklineLiveUpdate(Key key) : super(key: key);

  @override
  _SparklineLiveUpdateState createState() => _SparklineLiveUpdateState();
}

class _SparklineLiveUpdateState extends SampleViewState {
  _SparklineLiveUpdateState();

  double _size = 140;
  Timer _timer;
  bool _isVertical = false;
  String _cpuValue = '';
  String _diskValue = '';
  String _memoryValue = '';
  String _ethernetValue = '';
  List<double> _cpuData = <double>[20, 19, 39, 25, 11, 28, 34, 28];
  List<double> _diskData = <double>[
    60,
    59,
    55,
    60,
    64,
    56,
    55,
    65,
    55,
    60,
    59,
    55,
    60,
    64,
    56,
    55,
    65,
    55
  ];
  List<double> _memoryData = <double>[0, 68, 47, 74, 52, 74, 42, 3, 16];
  List<double> _ethernetData = <double>[0, 12, 0, 63, 13, 25, 48, 24, 74];
  @override
  void initState() {
    _cpuValue = _cpuData[_cpuData.length - 1].round().toString();
    _diskValue = _diskData[_diskData.length - 1].round().toString();
    _memoryValue = _memoryData[_memoryData.length - 1].round().toString();
    _ethernetValue = _ethernetData[_ethernetData.length - 1].round().toString();
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), _updateData);
  }

  @override
  void dispose() {
    _cpuData = <double>[];
    _diskData = <double>[];
    _memoryData = <double>[];
    _ethernetData = <double>[];
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isVertical =
        MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    if (_isVertical) {
      _size = model.isWeb
          ? MediaQuery.of(context).size.height / 6.5
          : MediaQuery.of(context).size.height / 6;
      return model.isWeb && model.isMobileResolution
          ? Container(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _getCPUDataChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _getDiskDataChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _getMemoryDataChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _getEthernetDataChart(),
                ],
              )),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _getCPUDataChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _getDiskDataChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _getMemoryDataChart(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  ),
                  _getEthernetDataChart(),
                ],
              ),
            );
    } else {
      _size = MediaQuery.of(context).size.width / 5.5;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getCPUDataChart(),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            ),
            _getDiskDataChart(),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            ),
            _getMemoryDataChart(),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            ),
            _getEthernetDataChart(),
          ],
        ),
      );
    }
  }

  Widget _getCPUDataChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            height: _isVertical ? _size : _size * 0.7,
            width: _isVertical ? _size * 2 : _size,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text('CPU',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(
                          '${_cpuValue}' +
                              '%' +
                              ' ' +
                              '${int.parse(_cpuValue) / 5}' +
                              ' GHz',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              color:
                                  model.themeData.brightness == Brightness.dark
                                      ? Color.fromRGBO(232, 242, 252, 1)
                                      : Color.fromRGBO(3, 88, 160, 1)))),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                  Expanded(
                      child: SfSparkAreaChart(
                    data: _cpuData,
                    axisLineWidth: 0,
                    color: Color.fromRGBO(232, 242, 252, 1),
                    borderColor: Color.fromRGBO(3, 88, 160, 1),
                    borderWidth: 1,
                  ))
                ]),
          ),
        ]);
  }

  Widget _getDiskDataChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            height: _isVertical ? _size : _size * 0.7,
            width: _isVertical ? _size * 2 : _size,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text('Disk',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text('${_diskValue}' + '%',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: model.themeData.brightness == Brightness.dark
                                ? Color.fromRGBO(245, 232, 252, 1)
                                : Color.fromRGBO(178, 71, 198, 1),
                          ))),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                  Expanded(
                      child: SfSparkAreaChart(
                    data: _diskData,
                    axisCrossesAt: 0,
                    axisLineWidth: 0,
                    color: Color.fromRGBO(245, 232, 252, 1),
                    borderColor: Color.fromRGBO(178, 71, 198, 1),
                    borderWidth: 1,
                  ))
                ]),
          ),
        ]);
  }

  Widget _getMemoryDataChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              height: _isVertical ? _size : _size * 0.7,
              width: _isVertical ? _size * 2 : _size,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text('Memory',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                            '${int.parse(_memoryValue) / 10}' +
                                '/' +
                                '15.8 GB ' +
                                '(' +
                                '${(((int.parse(_memoryValue) / 10) / 15.8) * 100).round()}' +
                                '%' +
                                ')',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  model.themeData.brightness == Brightness.dark
                                      ? Color.fromRGBO(224, 249, 209, 1)
                                      : Color.fromRGBO(39, 173, 102, 1),
                            ))),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    Expanded(
                        child: SfSparkAreaChart(
                            data: _memoryData,
                            axisCrossesAt: 0,
                            axisLineWidth: 0,
                            color: Color.fromRGBO(224, 249, 209, 1),
                            borderColor: Color.fromRGBO(39, 173, 102, 1),
                            borderWidth: 1))
                  ])),
        ]);
  }

  Widget _getEthernetDataChart() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              height: _isVertical ? _size : _size * 0.7,
              width: _isVertical ? _size * 2 : _size,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text('Ethernet',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                            'R: ' + '${int.parse(_ethernetValue)}' + ' Kbps',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  model.themeData.brightness == Brightness.dark
                                      ? Color.fromRGBO(242, 216, 199, 1)
                                      : Color.fromRGBO(170, 144, 122, 1),
                            ))),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    Expanded(
                        child: SfSparkAreaChart(
                      data: _ethernetData,
                      axisCrossesAt: 0,
                      axisLineWidth: 0,
                      color: Color.fromRGBO(242, 216, 199, 1),
                      borderColor: Color.fromRGBO(170, 144, 122, 1),
                      borderWidth: 1,
                    ))
                  ])),
        ]);
  }

  ///Get random value
  num _getRandomInt(num _min, num _max) {
    final Random _random = Random();
    return _min + _random.nextInt(_max - _min).toDouble();
  }

  void _updateData(Timer timer) {
    if (_cpuData.length > 10) {
      _cpuData.removeAt(0);
    }
    if (_diskData.length > 10) {
      _diskData.removeAt(1);
      _diskData[0] = 0;
    }
    if (_memoryData.length > 10) {
      _memoryData.removeAt(0);
    }
    if (_ethernetData.length > 10) {
      _ethernetData.removeAt(0);
    }
    setState(() {
      _cpuData = List.from(_getCPUData());
      _diskData = List.from(_getDiskData());
      _memoryData = List.from(_getMemoryData());
      _ethernetData = List.from(_getEthernetData());
      _cpuValue = _cpuData[_cpuData.length - 1].round().toString();
      _diskValue = _diskData[_diskData.length - 1].round().toString();
      _memoryValue = _memoryData[_memoryData.length - 1].round().toString();
      _ethernetValue =
          _ethernetData[_ethernetData.length - 1].round().toString();
    });
  }

  //ignore: unused_element
  List<double> _getCPUData() {
    _cpuData.add(_getRandomInt(0, 40));
    return _cpuData;
  }

  //ignore: unused_element
  List<double> _getDiskData() {
    _diskData.add(_getRandomInt(55, 65));
    return _diskData;
  }

  //ignore: unused_element
  List<double> _getMemoryData() {
    _memoryData.add(_getRandomInt(0, 80));
    return _memoryData;
  }

  //ignore: unused_element
  List<double> _getEthernetData() {
    _ethernetData.add(_getRandomInt(0, 70));
    return _ethernetData;
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final num x;
  final num y;
}
