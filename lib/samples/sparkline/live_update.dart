///Dart imports
import 'dart:async';
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

///Local import
import '../../model/sample_view.dart';

/// Widget of the AgendaView Calendar.
class SparklineLiveUpdate extends SampleView {
  /// Creates the sparkline live update chart.
  const SparklineLiveUpdate(Key key) : super(key: key);

  @override
  _SparklineLiveUpdateState createState() => _SparklineLiveUpdateState();
}

class _SparklineLiveUpdateState extends SampleViewState {
  _SparklineLiveUpdateState();

  late double _size;
  late Timer _timer;
  late bool _isVertical;
  late String _cpuValue;
  late String _diskValue;
  late String _memoryValue;
  late String _ethernetValue;
  late List<double> _cpuData;
  late List<double> _diskData;
  late List<double> _memoryData;
  late List<double> _ethernetData;
  @override
  void initState() {
    _size = 140;
    _isVertical = false;
    _cpuData = <double>[20, 19, 39, 25, 11, 28, 34, 28];
    _diskData = <double>[
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
      55,
    ];
    _memoryData = <double>[0, 68, 47, 74, 52, 74, 42, 3, 16];
    _ethernetData = <double>[0, 12, 0, 63, 13, 25, 48, 24, 74];
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
      _size = model.isWebFullView
          ? MediaQuery.of(context).size.height / 6.5
          : MediaQuery.of(context).size.height / 6;
      return model.isWebFullView && model.isMobileResolution
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildCPUDataChart(),
                  const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                  _buildDiskDataChart(),
                  const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                  _buildMemoryDataChart(),
                  const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                  _buildEthernetDataChart(),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildCPUDataChart(),
                  const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                  _buildDiskDataChart(),
                  const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                  _buildMemoryDataChart(),
                  const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 10)),
                  _buildEthernetDataChart(),
                ],
              ),
            );
    } else {
      _size = MediaQuery.of(context).size.width / 5.5;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildCPUDataChart(),
            const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
            _buildDiskDataChart(),
            const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
            _buildMemoryDataChart(),
            const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
            _buildEthernetDataChart(),
          ],
        ),
      );
    }
  }

  Widget _buildCPUDataChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
          ),
          height: _isVertical ? _size : _size * 0.7,
          width: _isVertical ? _size * 2 : _size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: const Text(
                  'CPU',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '$_cpuValue'
                  '%'
                  ' '
                  '${int.parse(_cpuValue) / 5}'
                  ' GHz',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        model.themeData.colorScheme.brightness ==
                            Brightness.dark
                        ? const Color.fromRGBO(212, 135, 215, 1)
                        : const Color.fromRGBO(110, 43, 113, 1),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
              Expanded(
                child: SfSparkAreaChart(
                  data: _cpuData,
                  axisLineWidth: 0,
                  color: const Color.fromRGBO(184, 71, 189, 0.35),
                  borderColor: const Color.fromRGBO(184, 71, 189, 1),
                  borderWidth: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiskDataChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
          ),
          height: _isVertical ? _size : _size * 0.7,
          width: _isVertical ? _size * 2 : _size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: const Text(
                  'Disk',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '$_diskValue'
                  '%',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        model.themeData.colorScheme.brightness ==
                            Brightness.dark
                        ? const Color.fromRGBO(169, 144, 253, 1)
                        : const Color.fromRGBO(34, 15, 132, 1),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
              Expanded(
                child: SfSparkAreaChart(
                  data: _diskData,
                  axisLineWidth: 0,
                  color: const Color.fromRGBO(128, 94, 246, 0.3),
                  borderColor: const Color.fromRGBO(128, 94, 246, 1),
                  borderWidth: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryDataChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
          ),
          height: _isVertical ? _size : _size * 0.7,
          width: _isVertical ? _size * 2 : _size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: const Text(
                  'Memory',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  '${int.parse(_memoryValue) / 10}'
                  '/'
                  '15.8 GB '
                  '('
                  '${(((int.parse(_memoryValue) / 10) / 15.8) * 100).round()}'
                  '%'
                  ')',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        model.themeData.colorScheme.brightness ==
                            Brightness.dark
                        ? const Color.fromRGBO(89, 176, 227, 1)
                        : const Color.fromRGBO(23, 118, 217, 1),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
              Expanded(
                child: SfSparkAreaChart(
                  data: _memoryData,
                  axisLineWidth: 0,
                  color: const Color.fromRGBO(89, 176, 227, 0.3),
                  borderColor: const Color.fromRGBO(89, 176, 227, 1),
                  borderWidth: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEthernetDataChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
          ),
          height: _isVertical ? _size : _size * 0.7,
          width: _isVertical ? _size * 2 : _size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: const Text(
                  'Ethernet',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  'R: '
                  '${int.parse(_ethernetValue)}'
                  ' Kbps',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        model.themeData.colorScheme.brightness ==
                            Brightness.dark
                        ? const Color.fromRGBO(89, 190, 103, 1)
                        : const Color.fromRGBO(40, 144, 90, 1),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
              Expanded(
                child: SfSparkAreaChart(
                  data: _ethernetData,
                  axisLineWidth: 0,
                  color: const Color.fromRGBO(89, 190, 103, 0.3),
                  borderColor: const Color.fromRGBO(89, 190, 103, 1),
                  borderWidth: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///Get random value
  double _getRandomInt(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min).toDouble();
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
      _cpuData = List<double>.from(_getCPUData());
      _diskData = List<double>.from(_getDiskData());
      _memoryData = List<double>.from(_getMemoryData());
      _ethernetData = List<double>.from(_getEthernetData());
      _cpuValue = _cpuData[_cpuData.length - 1].round().toString();
      _diskValue = _diskData[_diskData.length - 1].round().toString();
      _memoryValue = _memoryData[_memoryData.length - 1].round().toString();
      _ethernetValue = _ethernetData[_ethernetData.length - 1]
          .round()
          .toString();
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
