import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RangeColorForLabels extends StatefulWidget {
  RangeColorForLabels({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RangeColorForLabelsState createState() => _RangeColorForLabelsState(sample);
}

class _RangeColorForLabelsState extends State<RangeColorForLabels> {
  _RangeColorForLabelsState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRangeColorForLabels(false), sample);
  }
}

SfRadialGauge getRangeColorForLabels(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          showAxisLine: false,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          startAngle: 270,
          endAngle: 270,
          useRangeColorForAxis: true,
          radiusFactor: 0.95,
          interval: 10,
          isInversed: true,
          axisLabelStyle:
              GaugeTextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          majorTickStyle: MajorTickStyle(
              length: 0.15, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
          minorTicksPerInterval: 4,
          labelOffset: 15,
          minorTickStyle: MinorTickStyle(
              length: 0.04, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 35,
                color: const Color(0xFFF8B195),
                sizeUnit: GaugeSizeUnit.factor,
                rangeOffset: 0.06,
                startWidth: 0.05,
                endWidth: 0.25),
            GaugeRange(
                startValue: 35,
                endValue: 70,
                rangeOffset: 0.06,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color(0xFFC06C84),
                startWidth: 0.05,
                endWidth: 0.25),
            GaugeRange(
                startValue: 70,
                endValue: 100,
                rangeOffset: 0.06,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color(0xFF355C7D),
                startWidth: 0.05,
                endWidth: 0.25),
          ])
    ],
  );
}
