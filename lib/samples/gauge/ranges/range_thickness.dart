import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RangeThicknessExample extends StatefulWidget {
  RangeThicknessExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeThicknessExampleState createState() =>
      _RangeThicknessExampleState(sample);
}

class _RangeThicknessExampleState extends State<RangeThicknessExample> {
  _RangeThicknessExampleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRangeThicknessExampleGauge(false), sample);
  }
}

SfRadialGauge getRangeThicknessExampleGauge(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          showAxisLine: false,
          minimum: 0,
          maximum: 100,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          radiusFactor: 0.9,
          needsRotateLabels: true,
          majorTickStyle: MajorTickStyle(
            length: 0.1,
            thickness: 1.5,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          minorTickStyle: MinorTickStyle(
            length: 0.04,
            thickness: 1.5,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          minorTicksPerInterval: 5,
          interval: 10,
          labelOffset: 15,
          axisLabelStyle: GaugeTextStyle(fontSize: 12),
          useRangeColorForAxis: true,
          pointers: <GaugePointer>[
            NeedlePointer(
                needleStartWidth: 1,
                enableAnimation: true,
                value: 70,
                tailStyle: TailStyle(
                    length: 0.2, width: 5, lengthUnit: GaugeSizeUnit.factor),
                needleEndWidth: 5,
                needleLength: 0.7,
                lengthUnit: GaugeSizeUnit.factor,
                knobStyle: KnobStyle(
                  knobRadius: 0.08,
                  sizeUnit: GaugeSizeUnit.factor,
                ))
          ],
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: 30,
                endValue: 100,
                startWidth: 0.05,
                gradient: const SweepGradient(
                    colors: <Color>[Color(0xFF289AB1), Color(0xFF43E695)],
                    stops: <double>[0.25, 0.75]),
                color: const Color(0xFF289AB1),
                rangeOffset: 0.08,
                endWidth: 0.2,
                sizeUnit: GaugeSizeUnit.factor)
          ]),
    ],
  );
}
