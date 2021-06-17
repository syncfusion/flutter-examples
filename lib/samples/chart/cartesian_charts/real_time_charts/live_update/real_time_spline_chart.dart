/// Dart imports
import 'dart:async';
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../../model/sample_view.dart';

///Renders real time spline chart
class LiveUpdate extends SampleView {
  ///Creates real time spline chart
  const LiveUpdate(Key key) : super(key: key);

  @override
  _LiveUpdateState createState() => _LiveUpdateState();
}

class _LiveUpdateState extends SampleViewState {
  _LiveUpdateState() {
    timer = Timer.periodic(const Duration(milliseconds: 5), _updateData);
  }
  Timer? timer;
  List<ChartSampleData> chartData1 = <ChartSampleData>[
    ChartSampleData(x: 0, y: 0),
    ChartSampleData(x: 1, y: -2),
    ChartSampleData(x: 2, y: 2),
    ChartSampleData(x: 3, y: 0)
  ];
  List<ChartSampleData> chartData2 = <ChartSampleData>[
    ChartSampleData(x: 0, y: 0),
    ChartSampleData(x: 1, y: 2),
    ChartSampleData(x: 2, y: -2),
    ChartSampleData(x: 3, y: 0)
  ];
  bool canStopTimer = false;
  late int wave1, wave2;
  int count = 1;

  @override
  void initState() {
    chartData1 = <ChartSampleData>[
      ChartSampleData(x: 0, y: 0),
    ];
    chartData2 = <ChartSampleData>[
      ChartSampleData(x: 0, y: 0),
    ];
    super.initState();
    wave1 = 0;
    wave2 = 180;
    if (chartData1.isNotEmpty && chartData2.isNotEmpty) {
      chartData1.clear();
      chartData2.clear();
    }
    _updateLiveData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveUpdateChart();
  }

  ///Get the cartesian chart widget
  SfCartesianChart _buildLiveUpdateChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getLiveUpdateSeries(),
    );
  }

  ///Get the series which contains live updated data points
  List<SplineSeries<ChartSampleData, num>> _getLiveUpdateSeries() {
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
          dataSource: chartData1,
          xValueMapper: (ChartSampleData sales, _) => sales.x as num,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2),
      SplineSeries<ChartSampleData, num>(
        dataSource: chartData2,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x as num,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      )
    ];
  }

  void _updateData(Timer timer) {
    if (mounted) {
      setState(() {
        chartData1.removeAt(0);
        chartData1.add(ChartSampleData(
          x: wave1,
          y: math.sin(wave1 * (math.pi / 180.0)),
        ));
        chartData2.removeAt(0);
        chartData2.add(ChartSampleData(
          x: wave1,
          y: math.sin(wave2 * (math.pi / 180.0)),
        ));
        wave1++;
        wave2++;
      });
    }
  }

  void _updateLiveData() {
    for (int i = 0; i < 180; i++) {
      chartData1
          .add(ChartSampleData(x: i, y: math.sin(wave1 * (math.pi / 180.0))));
      wave1++;
    }

    for (int i = 0; i < 180; i++) {
      chartData2
          .add(ChartSampleData(x: i, y: math.sin(wave2 * (math.pi / 180.0))));
      wave2++;
    }

    wave1 = chartData1.length;
  }
}
