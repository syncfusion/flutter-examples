import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// ignore: must_be_immutable
class RangeSelectorZoomingPage extends StatefulWidget {
  RangeSelectorZoomingPage({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeSelectorZoomingPageState createState() =>
      _RangeSelectorZoomingPageState(sample);
}

class _RangeSelectorZoomingPageState extends State<RangeSelectorZoomingPage>
    with SingleTickerProviderStateMixin {
  _RangeSelectorZoomingPageState(this.sample);

  final SubItem sample;
  final DateTime min = DateTime(2017, 01, 01), max = DateTime(2018, 01, 01);
  final List<Data> chartData = <Data>[];
  RangeController rangeController;
  SfCartesianChart columnChart, splineChart;
  List<Data> columnData, splineSeriesData;

  @override
  void initState() {
    super.initState();
    rangeController = RangeController(
      start: DateTime.fromMillisecondsSinceEpoch(1498608000000),
      end: DateTime.fromMillisecondsSinceEpoch(1508112000000),
    );
    for (int i = 0; i < 366; i++) {
      chartData.add(Data(
          x: DateTime(2000, 01, 01).add(Duration(days: i)),
          y: Random().nextInt(190) + 50));
    }
    columnData = <Data>[
      Data(x: DateTime(2000, 01, 01, 0), y: 100),
      Data(x: DateTime(2000, 01, 15), y: 10),
      Data(x: DateTime(2000, 02, 01), y: 40),
      Data(x: DateTime(2000, 02, 15), y: 34),
      Data(x: DateTime(2000, 03, 01), y: 80),
      Data(x: DateTime(2000, 03, 15), y: 49),
      Data(x: DateTime(2000, 04, 01), y: 56),
      Data(x: DateTime(2000, 04, 15), y: 26),
      Data(x: DateTime(2000, 05, 01), y: 8),
      Data(x: DateTime(2000, 05, 15), y: 80),
      Data(x: DateTime(2000, 06, 01), y: 42),
      Data(x: DateTime(2000, 06, 15), y: 12),
      Data(x: DateTime(2000, 07, 01), y: 28),
      Data(x: DateTime(2000, 07, 15), y: 68),
      Data(x: DateTime(2000, 08, 01), y: 94),
      Data(x: DateTime(2000, 08, 15), y: 24),
      Data(x: DateTime(2000, 09, 01), y: 72),
      Data(x: DateTime(2000, 09, 15), y: 32),
      Data(x: DateTime(2000, 10, 01), y: 48),
      Data(x: DateTime(2000, 10, 15), y: 4),
      Data(x: DateTime(2000, 11, 01), y: 64),
      Data(x: DateTime(2000, 11, 15), y: 10),
      Data(x: DateTime(2000, 12, 01), y: 85),
      Data(x: DateTime(2000, 12, 15), y: 96),
    ];
    splineSeriesData = <Data>[
      Data(x: DateTime.fromMillisecondsSinceEpoch(1483315200000), y: 0.9557),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1483401600000), y: 0.963),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1483488000000), y: 0.9582),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1483574400000), y: 0.9524),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1483660800000), y: 0.9445),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1483920000000), y: 0.951),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484006400000), y: 0.9464),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484092800000), y: 0.9522),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484179200000), y: 0.9365),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484265600000), y: 0.9381),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484524800000), y: 0.944),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484611200000), y: 0.9361),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484697600000), y: 0.9378),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484784000000), y: 0.9375),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1484870400000), y: 0.9407),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485129600000), y: 0.9334),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485216000000), y: 0.9305),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485302400000), y: 0.9309),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485388800000), y: 0.9347),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485475200000), y: 0.9363),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485734400000), y: 0.9408),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485820800000), y: 0.9299),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485907200000), y: 0.9269),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1485993600000), y: 0.9253),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1486080000000), y: 0.9311),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1486339200000), y: 0.9336),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1486425600000), y: 0.9369),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1486512000000), y: 0.9377),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1486598400000), y: 0.9354),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1486684800000), y: 0.9409),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1486944000000), y: 0.9409),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487030400000), y: 0.9415),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487116800000), y: 0.9475),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487203200000), y: 0.9389),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487289600000), y: 0.9391),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487548800000), y: 0.9421),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487635200000), y: 0.9491),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487721600000), y: 0.9513),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487808000000), y: 0.9459),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1487894400000), y: 0.9427),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1488153600000), y: 0.9447),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1488240000000), y: 0.9438),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1488326400000), y: 0.9495),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1488412800000), y: 0.9512),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1488499200000), y: 0.9466),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1488758400000), y: 0.9442),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1488844800000), y: 0.9456),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1488931200000), y: 0.9474),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1489017600000), y: 0.9479),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1489104000000), y: 0.943),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1489363200000), y: 0.9379),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1489449600000), y: 0.9407),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1489536000000), y: 0.9415),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1489622400000), y: 0.9324),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1489708800000), y: 0.9315),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1489968000000), y: 0.9302),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490054400000), y: 0.9259),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490140800000), y: 0.9254),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490227200000), y: 0.9272),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490313600000), y: 0.9256),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490572800000), y: 0.9185),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490659200000), y: 0.921),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490745600000), y: 0.9305),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490832000000), y: 0.9315),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1490918400000), y: 0.9355),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1491177600000), y: 0.9381),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1491264000000), y: 0.939),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1491350400000), y: 0.9366),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1491436800000), y: 0.9377),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1491523200000), y: 0.9408),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1491782400000), y: 0.9455),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1491868800000), y: 0.9421),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1491955200000), y: 0.9431),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1492041600000), y: 0.9408),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1492473600000), y: 0.9363),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1492560000000), y: 0.9325),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1492646400000), y: 0.9308),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1492732800000), y: 0.9349),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1492992000000), y: 0.9219),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1493078400000), y: 0.9183),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1493164800000), y: 0.9181),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1493251200000), y: 0.9191),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1493337600000), y: 0.915),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1493683200000), y: 0.9163),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1493769600000), y: 0.9159),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1493856000000), y: 0.9153),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1493942400000), y: 0.9124),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1494201600000), y: 0.9143),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1494288000000), y: 0.9185),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1494374400000), y: 0.919),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1494460800000), y: 0.9209),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1494547200000), y: 0.9196),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1494806400000), y: 0.9115),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1494892800000), y: 0.9043),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1494979200000), y: 0.8996),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1495065600000), y: 0.8987),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1495152000000), y: 0.8946),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1495411200000), y: 0.8895),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1495497600000), y: 0.8918),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1495584000000), y: 0.8935),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1495670400000), y: 0.8918),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1495756800000), y: 0.8933),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496016000000), y: 0.8939),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496102400000), y: 0.8951),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496188800000), y: 0.8913),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496275200000), y: 0.8914),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496361600000), y: 0.8916),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496620800000), y: 0.8891),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496707200000), y: 0.8884),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496793600000), y: 0.8916),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496880000000), y: 0.8907),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1496966400000), y: 0.8949),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1497225600000), y: 0.8913),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1497312000000), y: 0.8916),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1497398400000), y: 0.8927),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1497484800000), y: 0.8957),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1497571200000), y: 0.8956),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1497830400000), y: 0.893),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1497916800000), y: 0.8965),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1498003200000), y: 0.8972),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1498089600000), y: 0.8954),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1498176000000), y: 0.8951),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1498435200000), y: 0.894),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1498521600000), y: 0.8868),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1498608000000), y: 0.8792),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1498694400000), y: 0.8763),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1498780800000), y: 0.8764),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499040000000), y: 0.8797),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499126400000), y: 0.8809),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499212800000), y: 0.8828),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499299200000), y: 0.8784),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499385600000), y: 0.8764),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499644800000), y: 0.8783),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499731200000), y: 0.8769),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499817600000), y: 0.8735),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499904000000), y: 0.876),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1499990400000), y: 0.8761),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1500249600000), y: 0.8725),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1500336000000), y: 0.8655),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1500422400000), y: 0.8672),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1500508800000), y: 0.8708),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1500595200000), y: 0.8591),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1500854400000), y: 0.8586),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1500940800000), y: 0.8552),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1501027200000), y: 0.8589),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1501113600000), y: 0.8552),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1501200000000), y: 0.8527),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1501459200000), y: 0.8528),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1501545600000), y: 0.8467),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1501632000000), y: 0.8455),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1501718400000), y: 0.8433),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1501804800000), y: 0.8427),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502064000000), y: 0.8478),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502150400000), y: 0.8466),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502236800000), y: 0.8525),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502323200000), y: 0.8525),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502409600000), y: 0.8501),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502668800000), y: 0.8478),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502755200000), y: 0.8516),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502841600000), y: 0.8541),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1502928000000), y: 0.855),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1503014400000), y: 0.8519),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1503273600000), y: 0.8504),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1503360000000), y: 0.8496),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1503446400000), y: 0.8476),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1503532800000), y: 0.8471),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1503619200000), y: 0.847),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1503878400000), y: 0.8387),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1503964800000), y: 0.8301),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1504051200000), y: 0.8393),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1504137600000), y: 0.8458),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1504224000000), y: 0.839),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1504483200000), y: 0.8401),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1504569600000), y: 0.8411),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1504656000000), y: 0.8383),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1504742400000), y: 0.8355),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1504828800000), y: 0.8293),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505088000000), y: 0.8336),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505174400000), y: 0.8381),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505260800000), y: 0.8349),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505347200000), y: 0.8415),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505433600000), y: 0.836),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505692800000), y: 0.8371),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505779200000), y: 0.8354),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505865600000), y: 0.8329),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1505952000000), y: 0.8401),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1506038400000), y: 0.8362),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1506297600000), y: 0.8428),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1506384000000), y: 0.8485),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1506470400000), y: 0.8518),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1506556800000), y: 0.8491),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1506643200000), y: 0.8471),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1506902400000), y: 0.8516),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1506988800000), y: 0.8509),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1507075200000), y: 0.8485),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1507161600000), y: 0.8517),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1507248000000), y: 0.8543),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1507507200000), y: 0.8515),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1507593600000), y: 0.8478),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1507680000000), y: 0.8454),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1507766400000), y: 0.8436),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1507852800000), y: 0.8468),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508112000000), y: 0.8473),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508198400000), y: 0.8505),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508284800000), y: 0.8512),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508371200000), y: 0.8451),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508457600000), y: 0.8463),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508716800000), y: 0.8519),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508803200000), y: 0.8504),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508889600000), y: 0.8486),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1508976000000), y: 0.8509),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1509062400000), y: 0.8618),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1509321600000), y: 0.8613),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1509408000000), y: 0.8594),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1509494400000), y: 0.8613),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1509580800000), y: 0.8588),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1509667200000), y: 0.858),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1509926400000), y: 0.8629),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510012800000), y: 0.865),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510099200000), y: 0.8629),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510185600000), y: 0.8599),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510272000000), y: 0.8582),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510531200000), y: 0.858),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510617600000), y: 0.8515),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510704000000), y: 0.8447),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510790400000), y: 0.8496),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1510876800000), y: 0.8479),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1511136000000), y: 0.8489),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1511222400000), y: 0.8535),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1511308800000), y: 0.8512),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1511395200000), y: 0.8441),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1511481600000), y: 0.8421),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1511740800000), y: 0.8368),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1511827200000), y: 0.8413),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1511913600000), y: 0.8456),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1512000000000), y: 0.8441),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1512086400000), y: 0.8415),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1512345600000), y: 0.8429),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1512432000000), y: 0.8442),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1512518400000), y: 0.8463),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1512604800000), y: 0.8486),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1512691200000), y: 0.8517),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1512950400000), y: 0.8478),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513036800000), y: 0.85),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513123200000), y: 0.8522),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513209600000), y: 0.8443),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513296000000), y: 0.8471),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513555200000), y: 0.8479),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513641600000), y: 0.8459),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513728000000), y: 0.8443),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513814400000), y: 0.8433),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1513900800000), y: 0.8438),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1514332800000), y: 0.8408),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1514419200000), y: 0.838),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1514505600000), y: 0.8339),
      Data(x: DateTime.fromMillisecondsSinceEpoch(1514678400000), y: 0.8324)
    ];
    columnChart = SfCartesianChart(
      margin: const EdgeInsets.all(0),
      primaryXAxis:
          DateTimeAxis(isVisible: false, maximum: DateTime(2018, 1, 1)),
      primaryYAxis: NumericAxis(isVisible: false),
      plotAreaBorderWidth: 0,
      series: <SplineAreaSeries<Data, DateTime>>[
        SplineAreaSeries<Data, DateTime>(
          dataSource: splineSeriesData,
          borderColor: const Color.fromRGBO(0, 193, 187, 1),
          color: const Color.fromRGBO(163, 226, 224, 1),
          borderDrawMode: BorderDrawMode.excludeBottom,
          borderWidth: 1,
          xValueMapper: (Data sales, _) => sales.x,
          yValueMapper: (Data sales, _) => sales.y,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    splineChart = SfCartesianChart(
      title: ChartTitle(text: 'EUR exchange rate from USD'),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(
          animationDuration: 0, shadowColor: Colors.transparent, enable: true),
      primaryXAxis: DateTimeAxis(
          labelStyle: ChartTextStyle(),
          isVisible: false,
          minimum: DateTime.fromMillisecondsSinceEpoch(1498608000000),
          maximum: DateTime.fromMillisecondsSinceEpoch(1508112000000),
          rangeController: rangeController),
      primaryYAxis: NumericAxis(
        labelPosition: ChartDataLabelPosition.inside,
        labelAlignment: LabelAlignment.far,
        majorTickLines: MajorTickLines(size: 0),
        axisLine: AxisLine(color: Colors.transparent),
      ),
      series: <SplineSeries<Data, DateTime>>[
        SplineSeries<Data, DateTime>(
          name: 'EUR',
          dataSource: splineSeriesData,
          color: const Color.fromRGBO(0, 193, 187, 1),
          animationDuration: 0,
          xValueMapper: (Data sales, _) => sales.x,
          yValueMapper: (Data sales, _) => sales.y,
        )
      ],
    );
    final Widget page = Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    width: mediaQueryData.orientation == Orientation.landscape
                        ? kIsWeb
                            ? mediaQueryData.size.width * 0.7
                            : mediaQueryData.size.width
                        : mediaQueryData.size.width,
                    padding: const EdgeInsets.fromLTRB(5, 20, 15, 25),
                    child: splineChart),
              ),
              SfRangeSelectorTheme(
                  data: SfRangeSliderThemeData(
                      brightness: themeData.brightness,
                      labelOffset: const Offset(kIsWeb ? -5 : 0, 0),
                      activeLabelStyle: TextStyle(
                          fontSize: 10,
                          color: themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white),
                      inactiveLabelStyle: TextStyle(
                          fontSize: 10,
                          color: themeData.brightness == Brightness.light
                              ? Colors.black
                              : const Color.fromRGBO(170, 170, 170, 1)),
                      activeTrackColor: const Color.fromRGBO(255, 125, 30, 1),
                      thumbColor: Colors.white,
                      overlayRadius: 1,
                      overlayColor: Colors.transparent),
                  child: Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 15, 15),
                        child: SfRangeSelector(
                          min: min,
                          max: max,
                          interval: 1,
                          thumbShape: _ThumbShape(),
                          labelPlacement: LabelPlacement.betweenTicks,
                          dateIntervalType: DateIntervalType.months,
                          controller: rangeController,
                          showTicks: true,
                          showLabels: true,
                          lockRange: true,
                          labelFormatterCallback: (dynamic actualLabel, String formattedText){
                            String label = DateFormat.MMM().format(actualLabel);
                            label = (kIsWeb && mediaQueryData.size.width <= 1000) ? label[0]: label;
                            return label;
                          },
                          onChanged: (SfRangeValues values) {},
                          child: Container(
                            child: columnChart,
                            height: 75,
                            padding: const EdgeInsets.all(0),
                            margin: const EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    ),
                    width: mediaQueryData.orientation == Orientation.landscape
                        ? kIsWeb
                            ? mediaQueryData.size.width * 0.7
                            : mediaQueryData.size.width
                        : mediaQueryData.size.width,
                  )),
            ],
          ),
        ));
    return Scaffold(
        body: mediaQueryData.orientation == Orientation.landscape && !kIsWeb
            ? SingleChildScrollView(
                child: Container(height: 400, child: page),
              )
            : page);
  }
}

class _ThumbShape extends SfThumbShape {
  @override
  void paint(PaintingContext context, Offset center,
      {bool isEnabled,
      RenderProxyBox parentBox,
      SfRangeSliderThemeData themeData,
      Animation<double> animation,
      TextDirection textDirection,
      SfThumb thumb}) {
    super.paint(context, center,
        isEnabled: isEnabled,
        parentBox: parentBox,
        themeData: themeData,
        animation: animation,
        textDirection: textDirection,
        thumb: thumb);

    context.canvas.drawCircle(
        center,
        getPreferredSize(themeData, isEnabled).width / 2,
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..color = const Color.fromRGBO(255, 125, 30, 1));
  }
}

class Data {
  Data({this.x, this.y});
  final DateTime x;
  final num y;
}
