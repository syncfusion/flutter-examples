/// Dart imports.
import 'dart:async';
import 'dart:math';

/// Package import.
import 'package:flutter/material.dart';

/// Chart import.
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local import.
import '../../../../model/sample_view.dart';

/// Renders the default axis animation Chart widget.
class AxisAnimationDefault extends SampleView {
  const AxisAnimationDefault(Key key) : super(key: key);

  @override
  _AxisAnimationDefaultState createState() => _AxisAnimationDefaultState();
}

/// State class of the axis animation.
/// Enable and disable the axis animation dynamically using `CustomCheckBox` in
/// the property panel.
class _AxisAnimationDefaultState extends SampleViewState {
  _AxisAnimationDefaultState() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 2000),
      _buildChartData,
    );
  }

  Timer? _timer;
  late double _count;
  late bool _animation;
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
      _ChartData(9, 57),
    ];
    super.initState();
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Enable axis elements\nanimation',
              textAlign: TextAlign.start,
              style: TextStyle(color: model.textColor, fontSize: 16),
            ),
            SizedBox(
              width: 90,
              child: CheckboxListTile(
                activeColor: model.primaryColor,
                value: _animation,
                onChanged: (bool? value) {
                  setState(() {
                    _animation = value!;
                    stateSetter(() {});
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      enableAxisAnimation: _animation,
      plotAreaBorderWidth: 0,
      series: _buildLineSeries(),
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<_ChartData, num>> _buildLineSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
        sortingOrder: SortingOrder.ascending,
        sortFieldValueMapper: (_ChartData sales, _) => sales.x,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  void _buildChartData(Timer timer) {
    if (mounted) {
      setState(() {
        _chartData = <_ChartData>[];
        if (_count == 0) {
          _buildData(1);
        } else if (_count == 1) {
          _buildData(2);
        } else if (_count == 2) {
          _buildData(3);
        } else if (_count == 3) {
          _buildData(4);
        } else if (_count == 4) {
          _buildData(5);
        }
        _count++;
        if (_count == 5) {
          _count = 0;
        }
      });
    }
  }

  void _buildData(int count) {
    for (int i = 1; i <= 7; i++) {
      _chartData!.add(
        _ChartData(2 * (i + count), _createRandomIntData(10, 95)),
      );
    }
  }

  int _createRandomIntData(int min, int max) {
    final Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
    _chartData!.clear();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
