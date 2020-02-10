import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class RadialElasticOutAnimation extends StatefulWidget {
  RadialElasticOutAnimation({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialElasticOutAnimationState createState() =>
      _RadialElasticOutAnimationState(sample);
}

class _RadialElasticOutAnimationState extends State<RadialElasticOutAnimation> {
  _RadialElasticOutAnimationState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialElasticOutAnimation(false), sample);
  }
}

SfRadialGauge getRadialElasticOutAnimation(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          startAngle: 180,
          endAngle: 360,
          showAxisLine: true,
          centerY: 0.65,
          interval: 10,
          showLabels: false,
          radiusFactor: 0.9,
          majorTickStyle: MajorTickStyle(
              length: 0.1, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
          minorTicksPerInterval: 4,
          pointers: <GaugePointer>[
            RangePointer(
                gradient: const SweepGradient(
                    colors: <Color>[Color(0xFFD481FF), Color(0xFF06F0E0)],
                    stops: <double>[0.25, 0.75]),
                value: 70,
                width: 5,
                animationDuration: 2000,
                enableAnimation: true,
                animationType: AnimationType.elasticOut,
                color: const Color(0xFF00A8B5)),
            NeedlePointer(
                value: 70,
                needleStartWidth: 0,
                needleColor: const Color(0xFFD481FF),
                lengthUnit: GaugeSizeUnit.factor,
                needleLength: 1,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.elasticOut,
                needleEndWidth: 5,
                knobStyle:
                    KnobStyle(knobRadius: 0, sizeUnit: GaugeSizeUnit.factor))
          ],
          minorTickStyle: MinorTickStyle(
              length: 0.04, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
          axisLineStyle: AxisLineStyle(color: Colors.transparent))
    ],
  );
}
