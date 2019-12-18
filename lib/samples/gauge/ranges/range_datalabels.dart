import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RangeDataLabelExample extends StatefulWidget {
  RangeDataLabelExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeDataLabelExampleState createState() =>
      _RangeDataLabelExampleState(sample);
}

class _RangeDataLabelExampleState extends State<RangeDataLabelExample> {
  _RangeDataLabelExampleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRangeDataLabelExample(false), sample);
  }
}

SfRadialGauge getRangeDataLabelExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          showLabels: false,
          showAxisLine: false,
          showTicks: false,
          minimum: 0,
          maximum: 99,
          radiusFactor: 0.9,
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 33,
                color: const Color(0xFFFE2A25),
                label: 'Slow',
                sizeUnit: GaugeSizeUnit.factor,
                labelStyle: GaugeTextStyle(
                    fontFamily: 'Times', fontSize: isTileView ? 16 : 20),
                startWidth: 0.65,
                endWidth: 0.65),
            GaugeRange(
              startValue: 33,
              endValue: 66,
              color: const Color(0xFFFFBA00),
              label: 'Moderate',
              labelStyle: GaugeTextStyle(
                  fontFamily: 'Times', fontSize: isTileView ? 16 : 20),
              startWidth: 0.65,
              endWidth: 0.65,
              sizeUnit: GaugeSizeUnit.factor,
            ),
            GaugeRange(
              startValue: 66,
              endValue: 99,
              color: const Color(0xFF00AB47),
              label: 'Fast',
              labelStyle: GaugeTextStyle(
                  fontFamily: 'Times', fontSize: isTileView ? 16 : 20),
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.65,
              endWidth: 0.65,
            ),
            GaugeRange(
              startValue: 0,
              endValue: 99,
              color: const Color.fromRGBO(155, 155, 155, 0.3),
              rangeOffset: 0.5,
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.15,
              endWidth: 0.15,
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
                value: 60,
                needleLength: 0.7,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 1,
                needleEndWidth: 10,
                knobStyle: KnobStyle(
                  knobRadius: 12,
                  sizeUnit: GaugeSizeUnit.logicalPixel,
                ))
          ])
    ],
  );
}
