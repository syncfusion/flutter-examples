import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class RadialSlowMiddleAnimation extends StatefulWidget {
   RadialSlowMiddleAnimation({this.sample, Key key}) : super(key: key);
   SubItem sample;

  @override
  _RadialSlowMiddleAnimationState createState() =>
      _RadialSlowMiddleAnimationState(sample);
}

class _RadialSlowMiddleAnimationState extends State<RadialSlowMiddleAnimation> {
  _RadialSlowMiddleAnimationState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialSlowMiddleAnimation(false), sample);
  }
}

SfRadialGauge getRadialSlowMiddleAnimation(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          startAngle: 270,
          endAngle: 270,
          showAxisLine: false,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          minimum: 0,
          maximum: 12,
          interval: 1,
          needsRotateLabels: true,
          majorTickStyle: MajorTickStyle(
              length: 0.15, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
          minorTicksPerInterval: 4,
          showFirstLabel: false,
          axisLabelStyle: GaugeTextStyle(fontSize: 12),
          minorTickStyle: MinorTickStyle(
              length: 0.07, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
          pointers: <GaugePointer>[
            NeedlePointer(
                needleLength: 0.95,
                needleStartWidth: 0,
                lengthUnit: GaugeSizeUnit.factor,
                needleEndWidth: 5,
                needleColor: const Color(0xFFC06C84),
                knobStyle: KnobStyle(knobRadius: 0),
                value: 11,
                enableAnimation: true,
                animationType: AnimationType.slowMiddle),
            NeedlePointer(
              needleLength: 0.7,
              needleStartWidth: 0,
              lengthUnit: GaugeSizeUnit.factor,
              needleEndWidth: 5,
              needleColor: const Color(0xFFF67280),
              value: 2,
              enableAnimation: true,
              animationType: AnimationType.slowMiddle,
              knobStyle: KnobStyle(
                  color: const Color(0xFFF67280),
                  sizeUnit: GaugeSizeUnit.logicalPixel,
                  knobRadius: 10),
            ),
            NeedlePointer(
                needleLength: 0.8,
                needleStartWidth: 1,
                lengthUnit: GaugeSizeUnit.factor,
                needleEndWidth: 1,
                needleColor: _slowMiddleNeedleColor,
                knobStyle: KnobStyle(
                    knobRadius: 5,
                    sizeUnit: GaugeSizeUnit.logicalPixel,
                    color: _slowMiddleNeedleColor),
                value: 10.4,
                enableAnimation: true,
                animationType: AnimationType.slowMiddle),
          ])
    ],
  );
}

Color _slowMiddleNeedleColor = const Color(0xFF355C7D);
