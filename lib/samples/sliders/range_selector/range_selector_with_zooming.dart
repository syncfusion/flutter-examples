///Dart import
// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

///Chart import
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;

///Core import
import 'package:syncfusion_flutter_core/core.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

///Local import
import '../../../model/sample_view.dart';

/// Renders the range selector with line chart zooming option
class RangeSelectorZoomingPage extends SampleView {
  /// Renders the range selector with line chart zooming option
  const RangeSelectorZoomingPage(Key key) : super(key: key);

  @override
  _RangeSelectorZoomingPageState createState() =>
      _RangeSelectorZoomingPageState();
}

class _RangeSelectorZoomingPageState extends SampleViewState
    with SingleTickerProviderStateMixin {
  _RangeSelectorZoomingPageState();

  final DateTime min = DateTime(2017), max = DateTime(2018);
  final List<ChartSampleData> chartData = <ChartSampleData>[];
  late RangeController rangeController;
  late SfCartesianChart columnChart, splineChart;
  late List<ChartSampleData> columnData, splineSeriesData;
  bool enableDeferredUpdate = true;

  @override
  void initState() {
    super.initState();
    rangeController = RangeController(
      start: DateTime.fromMillisecondsSinceEpoch(1498608000000),
      end: DateTime.fromMillisecondsSinceEpoch(1508112000000),
    );
    for (int i = 0; i < 366; i++) {
      chartData.add(
        ChartSampleData(
          x: DateTime(2000).add(Duration(days: i)),
          y: Random.secure().nextInt(190) + 50,
        ),
      );
    }
    columnData = <ChartSampleData>[
      ChartSampleData(x: DateTime(2000), y: 100),
      ChartSampleData(x: DateTime(2000, 01, 15), y: 10),
      ChartSampleData(x: DateTime(2000, 02), y: 40),
      ChartSampleData(x: DateTime(2000, 02, 15), y: 34),
      ChartSampleData(x: DateTime(2000, 03), y: 80),
      ChartSampleData(x: DateTime(2000, 03, 15), y: 49),
      ChartSampleData(x: DateTime(2000, 04), y: 56),
      ChartSampleData(x: DateTime(2000, 04, 15), y: 26),
      ChartSampleData(x: DateTime(2000, 05), y: 8),
      ChartSampleData(x: DateTime(2000, 05, 15), y: 80),
      ChartSampleData(x: DateTime(2000, 06), y: 42),
      ChartSampleData(x: DateTime(2000, 06, 15), y: 12),
      ChartSampleData(x: DateTime(2000, 07), y: 28),
      ChartSampleData(x: DateTime(2000, 07, 15), y: 68),
      ChartSampleData(x: DateTime(2000, 08), y: 94),
      ChartSampleData(x: DateTime(2000, 08, 15), y: 24),
      ChartSampleData(x: DateTime(2000, 09), y: 72),
      ChartSampleData(x: DateTime(2000, 09, 15), y: 32),
      ChartSampleData(x: DateTime(2000, 10), y: 48),
      ChartSampleData(x: DateTime(2000, 10, 15), y: 4),
      ChartSampleData(x: DateTime(2000, 11), y: 64),
      ChartSampleData(x: DateTime(2000, 11, 15), y: 10),
      ChartSampleData(x: DateTime(2000, 12), y: 85),
      ChartSampleData(x: DateTime(2000, 12, 15), y: 96),
    ];
    splineSeriesData = <ChartSampleData>[
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1483315200000),
        y: 0.9557,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1483401600000),
        y: 0.963,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1483488000000),
        y: 0.9582,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1483574400000),
        y: 0.9524,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1483660800000),
        y: 0.9445,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1483920000000),
        y: 0.951,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484006400000),
        y: 0.9464,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484092800000),
        y: 0.9522,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484179200000),
        y: 0.9365,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484265600000),
        y: 0.9381,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484524800000),
        y: 0.944,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484611200000),
        y: 0.9361,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484697600000),
        y: 0.9378,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484784000000),
        y: 0.9375,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1484870400000),
        y: 0.9407,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485129600000),
        y: 0.9334,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485216000000),
        y: 0.9305,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485302400000),
        y: 0.9309,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485388800000),
        y: 0.9347,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485475200000),
        y: 0.9363,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485734400000),
        y: 0.9408,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485820800000),
        y: 0.9299,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485907200000),
        y: 0.9269,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1485993600000),
        y: 0.9253,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1486080000000),
        y: 0.9311,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1486339200000),
        y: 0.9336,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1486425600000),
        y: 0.9369,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1486512000000),
        y: 0.9377,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1486598400000),
        y: 0.9354,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1486684800000),
        y: 0.9409,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1486944000000),
        y: 0.9409,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487030400000),
        y: 0.9415,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487116800000),
        y: 0.9475,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487203200000),
        y: 0.9389,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487289600000),
        y: 0.9391,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487548800000),
        y: 0.9421,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487635200000),
        y: 0.9491,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487721600000),
        y: 0.9513,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487808000000),
        y: 0.9459,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1487894400000),
        y: 0.9427,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1488153600000),
        y: 0.9447,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1488240000000),
        y: 0.9438,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1488326400000),
        y: 0.9495,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1488412800000),
        y: 0.9512,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1488499200000),
        y: 0.9466,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1488758400000),
        y: 0.9442,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1488844800000),
        y: 0.9456,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1488931200000),
        y: 0.9474,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1489017600000),
        y: 0.9479,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1489104000000),
        y: 0.943,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1489363200000),
        y: 0.9379,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1489449600000),
        y: 0.9407,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1489536000000),
        y: 0.9415,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1489622400000),
        y: 0.9324,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1489708800000),
        y: 0.9315,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1489968000000),
        y: 0.9302,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490054400000),
        y: 0.9259,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490140800000),
        y: 0.9254,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490227200000),
        y: 0.9272,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490313600000),
        y: 0.9256,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490572800000),
        y: 0.9185,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490659200000),
        y: 0.921,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490745600000),
        y: 0.9305,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490832000000),
        y: 0.9315,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1490918400000),
        y: 0.9355,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1491177600000),
        y: 0.9381,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1491264000000),
        y: 0.939,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1491350400000),
        y: 0.9366,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1491436800000),
        y: 0.9377,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1491523200000),
        y: 0.9408,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1491782400000),
        y: 0.9455,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1491868800000),
        y: 0.9421,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1491955200000),
        y: 0.9431,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1492041600000),
        y: 0.9408,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1492473600000),
        y: 0.9363,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1492560000000),
        y: 0.9325,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1492646400000),
        y: 0.9308,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1492732800000),
        y: 0.9349,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1492992000000),
        y: 0.9219,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1493078400000),
        y: 0.9183,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1493164800000),
        y: 0.9181,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1493251200000),
        y: 0.9191,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1493337600000),
        y: 0.915,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1493683200000),
        y: 0.9163,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1493769600000),
        y: 0.9159,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1493856000000),
        y: 0.9153,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1493942400000),
        y: 0.9124,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1494201600000),
        y: 0.9143,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1494288000000),
        y: 0.9185,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1494374400000),
        y: 0.919,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1494460800000),
        y: 0.9209,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1494547200000),
        y: 0.9196,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1494806400000),
        y: 0.9115,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1494892800000),
        y: 0.9043,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1494979200000),
        y: 0.8996,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1495065600000),
        y: 0.8987,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1495152000000),
        y: 0.8946,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1495411200000),
        y: 0.8895,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1495497600000),
        y: 0.8918,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1495584000000),
        y: 0.8935,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1495670400000),
        y: 0.8918,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1495756800000),
        y: 0.8933,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496016000000),
        y: 0.8939,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496102400000),
        y: 0.8951,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496188800000),
        y: 0.8913,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496275200000),
        y: 0.8914,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496361600000),
        y: 0.8916,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496620800000),
        y: 0.8891,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496707200000),
        y: 0.8884,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496793600000),
        y: 0.8916,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496880000000),
        y: 0.8907,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1496966400000),
        y: 0.8949,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1497225600000),
        y: 0.8913,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1497312000000),
        y: 0.8916,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1497398400000),
        y: 0.8927,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1497484800000),
        y: 0.8957,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1497571200000),
        y: 0.8956,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1497830400000),
        y: 0.893,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1497916800000),
        y: 0.8965,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1498003200000),
        y: 0.8972,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1498089600000),
        y: 0.8954,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1498176000000),
        y: 0.8951,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1498435200000),
        y: 0.894,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1498521600000),
        y: 0.8868,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1498608000000),
        y: 0.8792,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1498694400000),
        y: 0.8763,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1498780800000),
        y: 0.8764,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499040000000),
        y: 0.8797,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499126400000),
        y: 0.8809,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499212800000),
        y: 0.8828,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499299200000),
        y: 0.8784,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499385600000),
        y: 0.8764,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499644800000),
        y: 0.8783,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499731200000),
        y: 0.8769,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499817600000),
        y: 0.8735,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499904000000),
        y: 0.876,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1499990400000),
        y: 0.8761,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1500249600000),
        y: 0.8725,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1500336000000),
        y: 0.8655,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1500422400000),
        y: 0.8672,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1500508800000),
        y: 0.8708,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1500595200000),
        y: 0.8591,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1500854400000),
        y: 0.8586,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1500940800000),
        y: 0.8552,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1501027200000),
        y: 0.8589,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1501113600000),
        y: 0.8552,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1501200000000),
        y: 0.8527,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1501459200000),
        y: 0.8528,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1501545600000),
        y: 0.8467,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1501632000000),
        y: 0.8455,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1501718400000),
        y: 0.8433,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1501804800000),
        y: 0.8427,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502064000000),
        y: 0.8478,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502150400000),
        y: 0.8466,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502236800000),
        y: 0.8525,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502323200000),
        y: 0.8525,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502409600000),
        y: 0.8501,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502668800000),
        y: 0.8478,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502755200000),
        y: 0.8516,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502841600000),
        y: 0.8541,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1502928000000),
        y: 0.855,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1503014400000),
        y: 0.8519,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1503273600000),
        y: 0.8504,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1503360000000),
        y: 0.8496,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1503446400000),
        y: 0.8476,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1503532800000),
        y: 0.8471,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1503619200000),
        y: 0.847,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1503878400000),
        y: 0.8387,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1503964800000),
        y: 0.8301,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1504051200000),
        y: 0.8393,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1504137600000),
        y: 0.8458,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1504224000000),
        y: 0.839,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1504483200000),
        y: 0.8401,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1504569600000),
        y: 0.8411,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1504656000000),
        y: 0.8383,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1504742400000),
        y: 0.8355,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1504828800000),
        y: 0.8293,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505088000000),
        y: 0.8336,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505174400000),
        y: 0.8381,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505260800000),
        y: 0.8349,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505347200000),
        y: 0.8415,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505433600000),
        y: 0.836,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505692800000),
        y: 0.8371,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505779200000),
        y: 0.8354,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505865600000),
        y: 0.8329,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1505952000000),
        y: 0.8401,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1506038400000),
        y: 0.8362,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1506297600000),
        y: 0.8428,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1506384000000),
        y: 0.8485,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1506470400000),
        y: 0.8518,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1506556800000),
        y: 0.8491,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1506643200000),
        y: 0.8471,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1506902400000),
        y: 0.8516,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1506988800000),
        y: 0.8509,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1507075200000),
        y: 0.8485,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1507161600000),
        y: 0.8517,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1507248000000),
        y: 0.8543,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1507507200000),
        y: 0.8515,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1507593600000),
        y: 0.8478,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1507680000000),
        y: 0.8454,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1507766400000),
        y: 0.8436,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1507852800000),
        y: 0.8468,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508112000000),
        y: 0.8473,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508198400000),
        y: 0.8505,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508284800000),
        y: 0.8512,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508371200000),
        y: 0.8451,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508457600000),
        y: 0.8463,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508716800000),
        y: 0.8519,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508803200000),
        y: 0.8504,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508889600000),
        y: 0.8486,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1508976000000),
        y: 0.8509,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1509062400000),
        y: 0.8618,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1509321600000),
        y: 0.8613,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1509408000000),
        y: 0.8594,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1509494400000),
        y: 0.8613,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1509580800000),
        y: 0.8588,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1509667200000),
        y: 0.858,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1509926400000),
        y: 0.8629,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510012800000),
        y: 0.865,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510099200000),
        y: 0.8629,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510185600000),
        y: 0.8599,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510272000000),
        y: 0.8582,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510531200000),
        y: 0.858,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510617600000),
        y: 0.8515,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510704000000),
        y: 0.8447,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510790400000),
        y: 0.8496,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1510876800000),
        y: 0.8479,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1511136000000),
        y: 0.8489,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1511222400000),
        y: 0.8535,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1511308800000),
        y: 0.8512,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1511395200000),
        y: 0.8441,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1511481600000),
        y: 0.8421,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1511740800000),
        y: 0.8368,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1511827200000),
        y: 0.8413,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1511913600000),
        y: 0.8456,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1512000000000),
        y: 0.8441,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1512086400000),
        y: 0.8415,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1512345600000),
        y: 0.8429,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1512432000000),
        y: 0.8442,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1512518400000),
        y: 0.8463,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1512604800000),
        y: 0.8486,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1512691200000),
        y: 0.8517,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1512950400000),
        y: 0.8478,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513036800000),
        y: 0.85,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513123200000),
        y: 0.8522,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513209600000),
        y: 0.8443,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513296000000),
        y: 0.8471,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513555200000),
        y: 0.8479,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513641600000),
        y: 0.8459,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513728000000),
        y: 0.8443,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513814400000),
        y: 0.8433,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1513900800000),
        y: 0.8438,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1514332800000),
        y: 0.8408,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1514419200000),
        y: 0.838,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1514505600000),
        y: 0.8339,
      ),
      ChartSampleData(
        x: DateTime.fromMillisecondsSinceEpoch(1514678400000),
        y: 0.8324,
      ),
    ];
    columnChart = SfCartesianChart(
      margin: EdgeInsets.zero,
      primaryXAxis: DateTimeAxis(isVisible: false, maximum: DateTime(2018)),
      primaryYAxis: const NumericAxis(isVisible: false),
      plotAreaBorderWidth: 0,
      series: <SplineAreaSeries<ChartSampleData, DateTime>>[
        SplineAreaSeries<ChartSampleData, DateTime>(
          dataSource: splineSeriesData,
          borderColor: const Color.fromRGBO(0, 193, 187, 1),
          color: const Color.fromRGBO(163, 226, 224, 1),
          borderDrawMode: BorderDrawMode.excludeBottom,
          borderWidth: 1,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
        ),
      ],
    );
  }

  @override
  void dispose() {
    chartData.clear();
    rangeController.dispose();
    columnData.clear();
    splineSeriesData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme =
        themeData.colorScheme.brightness == Brightness.light;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    splineChart = SfCartesianChart(
      title: const ChartTitle(text: 'EUR Exchange Rate From USD 2017'),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(
        animationDuration: 0,
        shadowColor: Colors.transparent,
        enable: true,
      ),
      primaryXAxis: DateTimeAxis(
        labelStyle: const TextStyle(),
        isVisible: false,
        minimum: DateTime.fromMillisecondsSinceEpoch(1483315200000),
        maximum: DateTime.fromMillisecondsSinceEpoch(1514678400000),
        initialVisibleMinimum: rangeController.start,
        initialVisibleMaximum: rangeController.end,
        rangeController: rangeController,
      ),
      primaryYAxis: const NumericAxis(
        labelPosition: ChartDataLabelPosition.inside,
        labelAlignment: LabelAlignment.end,
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(color: Colors.transparent),
        anchorRangeToVisiblePoints: false,
      ),
      series: <SplineSeries<ChartSampleData, DateTime>>[
        SplineSeries<ChartSampleData, DateTime>(
          name: 'EUR',
          dataSource: splineSeriesData,
          color: const Color.fromRGBO(0, 193, 187, 1),
          animationDuration: 0,
          xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
        ),
      ],
    );
    final Widget page = Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      color: model.isWebFullView
          ? model.sampleOutputCardColor
          : model.sampleOutputCardColor,
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: mediaQueryData.orientation == Orientation.landscape
                    ? model.isWebFullView
                          ? mediaQueryData.size.width * 0.7
                          : mediaQueryData.size.width
                    : mediaQueryData.size.width,
                padding: const EdgeInsets.fromLTRB(5, 20, 15, 25),
                child: splineChart,
              ),
            ),
            SfRangeSelectorTheme(
              data: SfRangeSelectorThemeData(
                activeLabelStyle: TextStyle(
                  fontSize: 10,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
                inactiveLabelStyle: TextStyle(
                  fontSize: 10,
                  color: isLightTheme
                      ? Colors.black
                      : const Color.fromRGBO(170, 170, 170, 1),
                ),
                activeTrackColor: const Color.fromRGBO(255, 125, 30, 1),
                inactiveRegionColor: model.sampleOutputCardColor.withValues(
                  alpha: 0.75,
                ),
                thumbColor: Colors.white,
                thumbStrokeColor: const Color.fromRGBO(255, 125, 30, 1),
                thumbStrokeWidth: 2.0,
                overlayRadius: 1,
                overlayColor: Colors.transparent,
              ),
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                width: mediaQueryData.orientation == Orientation.landscape
                    ? model.isWebFullView
                          ? mediaQueryData.size.width * 0.7
                          : mediaQueryData.size.width
                    : mediaQueryData.size.width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 15, 15),
                    child: SfRangeSelector(
                      min: min,
                      max: max,
                      interval: 1,
                      enableDeferredUpdate: enableDeferredUpdate,
                      deferredUpdateDelay: 1000,
                      labelPlacement: LabelPlacement.betweenTicks,
                      dateIntervalType: DateIntervalType.months,
                      controller: rangeController,
                      showTicks: true,
                      showLabels: true,
                      dragMode: SliderDragMode.both,
                      labelFormatterCallback:
                          (dynamic actualLabel, String formattedText) {
                            String label = DateFormat.MMM().format(actualLabel);
                            label =
                                (model.isWebFullView &&
                                    mediaQueryData.size.width <= 1000)
                                ? label[0]
                                : label;
                            return label;
                          },
                      onChanged: (SfRangeValues values) {},
                      child: Container(
                        height: 75,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        child: columnChart,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      body:
          mediaQueryData.orientation == Orientation.landscape &&
              !model.isWebFullView
          ? Center(
              child: SingleChildScrollView(
                child: SizedBox(height: 400, child: page),
              ),
            )
          : page,
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return CheckboxListTile(
          value: enableDeferredUpdate,
          title: const Text('Enable deferred update', softWrap: false),
          activeColor: model.primaryColor,
          contentPadding: EdgeInsets.zero,
          onChanged: (bool? value) {
            setState(() {
              enableDeferredUpdate = value!;
              stateSetter(() {});
            });
          },
        );
      },
    );
  }
}
