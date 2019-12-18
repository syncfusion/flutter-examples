import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class RadialEaseInCircExample extends StatefulWidget {
  RadialEaseInCircExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialEaseInCircExampleState createState() =>
      _RadialEaseInCircExampleState(sample);
}

class _RadialEaseInCircExampleState extends State<RadialEaseInCircExample> {
  _RadialEaseInCircExampleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialEaseInCircExample(false), sample);
  }
}

SfRadialGauge getRadialEaseInCircExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          showAxisLine: false,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          interval: 10,
          axisLabelStyle: GaugeTextStyle(fontSize: 12),
          majorTickStyle: MajorTickStyle(
            length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          minorTicksPerInterval: 4,
          minorTickStyle: MinorTickStyle(
            length: 0.04,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          pointers: <GaugePointer>[
            RangePointer(
                width: 15,
                pointerOffset: 10,
                value: 45,
                animationDuration: 1000,
                gradient: const SweepGradient(
                    colors: <Color>[Color(0xFF3B3FF3), Color(0xFF46D0ED)],
                    stops: <double>[0.25, 0.75]),
                animationType: AnimationType.easeInCirc,
                enableAnimation: true,
                color: const Color(0xFFF8B195))
          ])
    ],
  );
}
