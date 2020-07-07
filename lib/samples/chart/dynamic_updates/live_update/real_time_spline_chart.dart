/// Dart imports
import 'dart:async';
import 'dart:math' as math;

/// Package imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
import '../../../../model/model.dart';
import '../../../../model/sample_view.dart';

class LiveUpdate extends SampleView {
  const LiveUpdate(Key key) : super(key: key);

  @override
  _LiveUpdateState createState() => _LiveUpdateState();
}

Timer timer;
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
int wave1;
int wave2, count = 1;
// ChartSeriesController _chartSeriesController1;
// ChartSeriesController _chartSeriesController2;

class _LiveUpdateState extends SampleViewState {
  _LiveUpdateState() {
    timer = Timer.periodic(const Duration(milliseconds: 5), updateData);
  }

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
    updateLiveData();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getLiveUpdateChart();
  }

  SfCartesianChart getLiveUpdateChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0)),
      series: getLiveUpdateSeries(),
    );
  }

  List<SplineSeries<ChartSampleData, num>> getLiveUpdateSeries() {
    return <SplineSeries<ChartSampleData, num>>[
      SplineSeries<ChartSampleData, num>(
        // onRendererCreated: (ChartSeriesController controller1) {
        //       _chartSeriesController1 = controller1;
        //     },
          dataSource:  chartData1,
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          width: 2),
      SplineSeries<ChartSampleData, num>(
        // onRendererCreated: (ChartSeriesController controller2) {
        //       _chartSeriesController2 = controller2;
        //     },
        dataSource:  chartData2,
        width: 2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      )
    ];
  }

  void updateData(Timer timer) {
    // if (isCardView != null && !isCardView) {
    //   chartData1.removeAt(0);
    //   chartData1.add(ChartSampleData(
    //     x: wave1,
    //     y: math.sin(wave1 * (math.pi / 180.0)),
    //   ));
    //   _chartSeriesController1.updateDataSource(
    //       addedDataIndexes: <int>[chartData1.length - 1],
    //       removedDataIndexes: <int>[0],
    //     );
    //     chartData2.removeAt(0);
    //   chartData2.add(ChartSampleData(
    //     x: wave1,
    //     y: math.sin(wave2 * (math.pi / 180.0)),
    //   ));
    //   _chartSeriesController2.updateDataSource(
    //       addedDataIndexes: <int>[chartData2.length - 1],
    //       removedDataIndexes: <int>[0],
    //     );
    //     wave1++;
    //   wave2++;
    // }
   
   if(mounted){
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

  void updateLiveData() {
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