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
  Timer? _timer;
  late double _count;
  List<_ChartData>? _chartData;

  @override
  void initState() {
    _count = 0;
    _animation = true;

    _chartData = <_ChartData>[
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
    _chartData!.clear();
  }

  late bool _animation;

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
            child: SizedBox(
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
          dataSource: _chartData!,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          sortingOrder: SortingOrder.ascending,
          sortFieldValueMapper: (_ChartData sales, _) => sales.x,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  void _getChartData(Timer timer) {
    if (mounted) {
      setState(() {
        _chartData = <_ChartData>[];

        if (_count == 0) {
          _getData(1);
        } else if (_count == 1) {
          _getData(2);
        } else if (_count == 2) {
          _getData(3);
        } else if (_count == 3) {
          _getData(4);
        } else if (_count == 4) {
          _getData(5);
        }
        _count++;
        if (_count == 5) {
          _count = 0;
        }
      });
    }
  }

  void _getData(int count) {
    for (int i = 1; i <= 7; i++) {
      _chartData!.add(_ChartData(2 * (i + count), _getRandomInt(10, 95)));
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
