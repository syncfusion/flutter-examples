import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class RadialEaseExample extends StatefulWidget {
  RadialEaseExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialEaseExampleState createState() => _RadialEaseExampleState(sample);
}

class _RadialEaseExampleState extends State<RadialEaseExample> {
  _RadialEaseExampleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialEaseExample(false), sample);
  }
}

SfRadialGauge getRadialEaseExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          startAngle: 0,
          endAngle: 360,
          showLabels: false,
          showTicks: false,
          radiusFactor: 0.9,
          axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: isTileView ? 0.07 : 0.1)),
      RadialAxis(
          startAngle: 170,
          endAngle: 170,
          showTicks: false,
          labelFormat: '{value}M',
          showAxisLine: false,
          radiusFactor: 0.9,
          minimum: 0,
          maximum: 15,
          showLastLabel: false,
          axisLabelStyle: GaugeTextStyle(
              fontSize: isTileView ? 10 : 12, fontWeight: FontWeight.w500),
          labelOffset: 25,
          interval: isTileView ? 1 : _interval,
          needsRotateLabels: true,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                positionFactor: 1,
                axisValue: 0,
                widget: Container(
                    height: isTileView ? 30 : 45,
                    width: isTileView ? 30 : 45,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('images/shotput.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ))),
            GaugeAnnotation(
                widget: Container(
              child: const Text('Distance', style: TextStyle(fontSize: 20)),
            ))
          ],
          pointers: <GaugePointer>[
            RangePointer(
              value: 11.5,
              width: 0.1,
              color: const Color(0xFFF67280),
              enableAnimation: true,
              sizeUnit: GaugeSizeUnit.factor,
              animationType: AnimationType.ease,
              gradient: const SweepGradient(
                  colors: <Color>[Color(0xFFFFB397), Color(0xFFF46AA0)],
                  stops: <double>[0.25, 0.75]),
            ),
            MarkerPointer(
                value: 11.5,
                markerType: MarkerType.image,
                enableAnimation: true,
                animationType: AnimationType.ease,
                imageUrl: 'images/ball.png',
                markerHeight: isTileView ? 30 : 40,
                markerOffset: 4,
                markerWidth: isTileView ? 30 : 40),
          ])
    ],
  );
}

double _interval = 1;
