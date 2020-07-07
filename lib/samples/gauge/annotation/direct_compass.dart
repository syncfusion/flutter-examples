import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class RadialCompass extends StatefulWidget {
  RadialCompass({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialCompassState createState() => _RadialCompassState(sample);
}

class _RadialCompassState extends State<RadialCompass> {
  _RadialCompassState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialCompass(false), sample);
  }
}

SfRadialGauge getRadialCompass(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          showAxisLine: false,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          startAngle: 320,
          endAngle: 320,
          minorTicksPerInterval: 10,
          minimum: 0,
          maximum: 360,
          showLastLabel: false,
          interval: 30,
          labelOffset: 20,
          majorTickStyle:
              MajorTickStyle(length: 0.16, lengthUnit: GaugeSizeUnit.factor),
          minorTickStyle: MinorTickStyle(
              length: 0.16, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
          axisLabelStyle: GaugeTextStyle(fontSize: 12),
          pointers: <GaugePointer>[
            MarkerPointer(value: 90, markerType: MarkerType.triangle),
            NeedlePointer(
                value: 310,
                needleLength: 0.5,
                lengthUnit: GaugeSizeUnit.factor,
                needleColor: const Color(0xFFC4C4C4),
                needleStartWidth: 1,
                needleEndWidth: 1,
                knobStyle: KnobStyle(knobRadius: 0),
                tailStyle: TailStyle(
                    color: const Color(0xFFC4C4C4),
                    width: 1,
                    lengthUnit: GaugeSizeUnit.factor,
                    length: 0.5)),
            NeedlePointer(
              value: 221,
              needleLength: 0.5,
              lengthUnit: GaugeSizeUnit.factor,
              needleColor: const Color(0xFFC4C4C4),
              needleStartWidth: 1,
              needleEndWidth: 1,
              knobStyle:
                  KnobStyle(knobRadius: 0, sizeUnit: GaugeSizeUnit.factor),
            ),
            NeedlePointer(
              value: 40,
              needleLength: 0.5,
              lengthUnit: GaugeSizeUnit.factor,
              needleColor: const Color(0xFFC4C4C4),
              needleStartWidth: 1,
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0),
            )
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 230,
                positionFactor: 0.38,
                widget: Container(
                  child: Text('W',
                      style: TextStyle(
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                          fontSize: isTileView ? 12 : 18)),
                )),
            GaugeAnnotation(
                angle: 310,
                positionFactor: 0.38,
                widget: Container(
                  child: Text('N',
                      style: TextStyle(
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                          fontSize: isTileView ? 12 : 18)),
                )),
            GaugeAnnotation(
                angle: 129,
                positionFactor: 0.38,
                widget: Container(
                  child: Text('S',
                      style: TextStyle(
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                          fontSize: isTileView ? 12 : 18)),
                )),
            GaugeAnnotation(
                angle: 50,
                positionFactor: 0.38,
                widget: Container(
                  child: Text('E',
                      style: TextStyle(
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                          fontSize: isTileView ? 12 : 18)),
                ))
          ])
    ],
  );
}
