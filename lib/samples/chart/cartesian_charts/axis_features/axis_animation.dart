/// Dart imports
import 'dart:async';
import 'dart:math';

/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/sample_view.dart';

/// Renders the default axis animation chart widget
class AxisAnimationDefault extends SampleView {
  ///Creates default axis animation chart widget
  const AxisAnimationDefault(Key key) : super(key: key);

  @override
  _AxisAnimationDefaultState createState() => _AxisAnimationDefaultState();
}

/// State class of the axis animation.
/// Enable and disable the axis animation dynamically
/// using `CustomCheckBox` in the property panel.
class _AxisAnimationDefaultState extends SampleViewState {
  _AxisAnimationDefaultState() {
    _timer = Timer.periodic(const Duration(milliseconds: 2000), _getChartData);
  }
  late Timer _timer;
  double _count = 0;

  final List<_ChartData> _chartData = <_ChartData>[
    _ChartData(1, 70),
    _ChartData(2, 78),
    _ChartData(3, 65),
    _ChartData(4, 11),
    _ChartData(5, 24),
    _ChartData(6, 36),
    _ChartData(7, 38),
    _ChartData(8, 54),
    _ChartData(9, 57)
  ];

  @override
  void initState() {
    _animation = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  bool _animation = true;

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Enable axis elements\nanimation',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: model.textColor,
                fontSize: 16,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 90,
                child: CheckboxListTile(
                    activeColor: model.backgroundColor,
                    value: _animation,
                    onChanged: (bool? value) {
                      setState(() {
                        _animation = value!;
                        stateSetter(() {});
                      });
                    })),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildAxisAnimation();
  }

  /// Returns the Cartesian chart axis animation.
  SfCartesianChart _buildAxisAnimation() {
    return SfCartesianChart(
        enableAxisAnimation: _animation,
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(),
        primaryYAxis: NumericAxis(),
        series: _getSeries());
  }

  /// Returns the list of Chart series which need to render on axis animation.
  List<LineSeries<_ChartData, num>> _getSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          dataSource: _chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          sortingOrder: SortingOrder.ascending,
          sortFieldValueMapper: (_ChartData sales, _) => sales.x,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  void _getChartData(Timer _timer) {
    if (mounted) {
      setState(() {
        if (_count == 0) {
          _chartData[0] = _ChartData(2, _getRandomInt(5, 95));
          _chartData[1] = _ChartData(8, _getRandomInt(5, 95));
          _chartData[2] = _ChartData(14, _getRandomInt(5, 95));
          _chartData[3] = _ChartData(20, _getRandomInt(5, 95));
          _chartData[4] = _ChartData(24, _getRandomInt(5, 95));
          _chartData[5] = _ChartData(28, _getRandomInt(5, 95));
          _chartData[6] = _ChartData(38, _getRandomInt(5, 95));
          _chartData[7] = _ChartData(42, _getRandomInt(5, 95));
          _chartData[8] = _ChartData(52, _getRandomInt(5, 95));
        } else if (_count == 1) {
          _chartData[0] = _ChartData(22, _getRandomInt(5, 95));
          _chartData[1] = _ChartData(28, _getRandomInt(5, 95));
          _chartData[2] = _ChartData(44, _getRandomInt(5, 115));
          _chartData[3] = _ChartData(60, _getRandomInt(5, 95));
          _chartData[4] = _ChartData(68, _getRandomInt(95, 120));
          _chartData[5] = _ChartData(76, _getRandomInt(5, 95));
          _chartData[6] = _ChartData(84, _getRandomInt(5, 95));
          _chartData[7] = _ChartData(92, _getRandomInt(5, 95));
          _chartData[8] = _ChartData(102, _getRandomInt(5, 110));
        } else if (_count == 2) {
          _chartData[0] = _ChartData(12, _getRandomInt(5, 95));
          _chartData[1] = _ChartData(18, _getRandomInt(5, 95));
          _chartData[2] = _ChartData(24, _getRandomInt(5, 95));
          _chartData[3] = _ChartData(30, _getRandomInt(5, 95));
          _chartData[4] = _ChartData(34, _getRandomInt(5, 95));
          _chartData[5] = _ChartData(48, _getRandomInt(5, 95));
          _chartData[6] = _ChartData(58, _getRandomInt(5, 95));
          _chartData[7] = _ChartData(62, _getRandomInt(5, 95));
          _chartData[8] = _ChartData(92, _getRandomInt(5, 95));
        } else if (_count == 3) {
          _chartData[0] = _ChartData(32, _getRandomInt(5, 95));
          _chartData[1] = _ChartData(48, _getRandomInt(5, 95));
          _chartData[2] = _ChartData(54, _getRandomInt(5, 95));
          _chartData[3] = _ChartData(80, _getRandomInt(5, 95));
          _chartData[4] = _ChartData(98, _getRandomInt(5, 95));
          _chartData[5] = _ChartData(106, _getRandomInt(5, 95));
          _chartData[6] = _ChartData(114, _getRandomInt(5, 95));
          _chartData[7] = _ChartData(122, _getRandomInt(5, 95));
          _chartData[8] = _ChartData(132, _getRandomInt(5, 95));
        } else if (_count == 4) {
          _chartData[0] = _ChartData(42, _getRandomInt(5, 95));
          _chartData[1] = _ChartData(48, _getRandomInt(5, 115));
          _chartData[2] = _ChartData(64, _getRandomInt(5, 95));
          _chartData[3] = _ChartData(70, _getRandomInt(5, 95));
          _chartData[4] = _ChartData(94, _getRandomInt(5, 120));
          _chartData[5] = _ChartData(108, _getRandomInt(5, 95));
          _chartData[6] = _ChartData(118, _getRandomInt(90, 125));
          _chartData[7] = _ChartData(132, _getRandomInt(5, 95));
          _chartData[8] = _ChartData(142, _getRandomInt(5, 100));
        }
        _count++;
        if (_count == 5) {
          _count = 0;
        }
      });
    }
  }

  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
