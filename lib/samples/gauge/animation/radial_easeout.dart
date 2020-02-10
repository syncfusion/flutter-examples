import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class RadialEaseOutAnimation extends StatefulWidget {
  RadialEaseOutAnimation({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialEaseOutAnimationState createState() =>
      _RadialEaseOutAnimationState(sample);
}

class _RadialEaseOutAnimationState extends State<RadialEaseOutAnimation> {
  _RadialEaseOutAnimationState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialEaseOutAnimation(false), sample);
  }
}

SfRadialGauge getRadialEaseOutAnimation(bool isTileView) {

  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          startAngle: 180,
          endAngle: 360,
          showTicks: false,
          showLabels: false,
          centerY: 0.6,
          radiusFactor: 0.8,
          minimum: 0,
          maximum: 50,
          axisLineStyle: AxisLineStyle(thickness: 40),
          pointers: <GaugePointer>[
            RangePointer(
              enableAnimation: true,
              animationType: AnimationType.easeOutBack,
              width: 40,
              color: const Color(0xFF00A8B5),
              value: 40,
              gradient: const SweepGradient(
                  colors: <Color>[Color(0xFFD046CA), Color(0xFF6094EA)],
                  stops: <double>[0.25, 0.75]),
            ),
            NeedlePointer(
                knobStyle: KnobStyle(
                    knobRadius: 5,
                    sizeUnit: GaugeSizeUnit.logicalPixel),
                needleEndWidth: 2,
                needleStartWidth: 2,
                lengthUnit: GaugeSizeUnit.factor,
                needleLength: 0.98,
                value: 40,
                enableAnimation: true,
                animationType: AnimationType.easeOutBack)
          ])
    ],
  );
}
