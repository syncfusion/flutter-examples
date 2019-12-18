import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class MultipleNeedleExample extends StatefulWidget {
  MultipleNeedleExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _MultipleNeedleExampleState createState() =>
      _MultipleNeedleExampleState(sample);
}

class _MultipleNeedleExampleState extends State<MultipleNeedleExample> {
  _MultipleNeedleExampleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getMultipleNeedleExample(false), sample);
  }
}

SfRadialGauge getMultipleNeedleExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          showAxisLine: false,
          radiusFactor: 0.5,
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 60,
          showFirstLabel: false,
          interval: 5,
          labelOffset: 10,
          minorTicksPerInterval: 5,
          axisLabelStyle: GaugeTextStyle(fontSize: 10),
          onLabelCreated: mainAxisLabelCreated,
          minorTickStyle: MinorTickStyle(
              lengthUnit: GaugeSizeUnit.factor, length: 0.03, thickness: 1),
          majorTickStyle:
              MajorTickStyle(lengthUnit: GaugeSizeUnit.factor, length: 0.1)),
      RadialAxis(
          axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: 0.08,
              color: const Color(0xFFFFCD60)),
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 12,
          radiusFactor: 0.9,
          showFirstLabel: false,
          interval: 1,
          labelOffset: 10,
          axisLabelStyle: GaugeTextStyle(fontSize: isTileView ? 10 : 12),
          minorTicksPerInterval: 5,
          onLabelCreated: mainAxisLabelCreated,
          minorTickStyle: MinorTickStyle(
              lengthUnit: GaugeSizeUnit.factor, length: 0.05, thickness: 1),
          majorTickStyle:
              MajorTickStyle(lengthUnit: GaugeSizeUnit.factor, length: 0.1),
          pointers: <GaugePointer>[
            NeedlePointer(
                value: 8,
                needleLength: 0.35,
                needleColor: const Color(0xFFF67280),
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 0,
                needleEndWidth: isTileView ? 3 : 5,
                enableAnimation: true,
                knobStyle: KnobStyle(knobRadius: 0),
                animationType: AnimationType.ease),
            NeedlePointer(
                value: 3,
                needleLength: 0.85,
                lengthUnit: GaugeSizeUnit.factor,
                needleColor: const Color(0xFFF67280),
                needleStartWidth: 0,
                needleEndWidth: isTileView ? 3 : 5,
                enableAnimation: true,
                animationType: AnimationType.ease,
                knobStyle: KnobStyle(
                    borderColor: const Color(0xFFF67280),
                    borderWidth: 0.015,
                    color: Colors.white,
                    sizeUnit: GaugeSizeUnit.factor,
                    knobRadius: isTileView ? 0.04 : 0.05)),
          ]),
    ],
  );
}

void mainAxisLabelCreated(AxisLabelCreatedArgs args) {
  if (args.text == '12') {
    args.text = '12h';
  }
}
