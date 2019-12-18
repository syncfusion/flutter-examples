import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class GaugeCustomLabels extends StatefulWidget {
  GaugeCustomLabels({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _GaugeCustomLabelsState createState() => _GaugeCustomLabelsState(sample);
}

class _GaugeCustomLabelsState extends State<GaugeCustomLabels> {
  _GaugeCustomLabelsState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel( getGaugeCustomLabels(false), sample);
  }
}


Widget getGaugeCustomLabels(bool isTileView, [bool isIndexed]) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Orientation _orientation = MediaQuery.of(context).orientation;
        final Brightness _brightness = Theme.of(context).brightness;

        return SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              startAngle: 270,
              endAngle: 270,
              radiusFactor: 0.9,
              minimum: 0,
              maximum: 80,
              axisLineStyle:
              AxisLineStyle(thicknessUnit: GaugeSizeUnit.factor, thickness: 0.1),
              interval: 10,
              needsRotateLabels: true,
              axisLabelStyle: GaugeTextStyle(fontSize: 12),
              minorTicksPerInterval: 0,
              majorTickStyle: MajorTickStyle(
                  thickness: 1.5, lengthUnit: GaugeSizeUnit.factor, length: 0.07),
              showLabels: true,
              onLabelCreated: labelCreated,
              pointers: <GaugePointer>[
                NeedlePointer(
                    value: 70,
                    lengthUnit: GaugeSizeUnit.factor,
                    needleLength: 0.55,
                    needleEndWidth: isTileView ? 10 :
                    _orientation == Orientation.portrait ? 18: 10,
                    gradient: const LinearGradient(colors: <Color>[
                      Color(0xFFFF6B78),
                      Color(0xFFFF6B78),
                      Color(0xFFE20A22),
                      Color(0xFFE20A22)
                    ], stops: <double>[
                      0,
                      0.5,
                      0.5,
                      1
                    ]),
                    needleColor: const Color(0xFFF67280),
                    knobStyle: KnobStyle(
                        knobRadius: 0.1,
                        sizeUnit: GaugeSizeUnit.factor,
                        color: Colors.white)),
                NeedlePointer(
                    gradient: const LinearGradient(colors: <Color>[
                      Color(0xFFE3DFDF),
                      Color(0xFFE3DFDF),
                      Color(0xFF7A7A7A),
                      Color(0xFF7A7A7A)
                    ], stops: <double>[
                      0,
                      0.5,
                      0.5,
                      1
                    ]),
                    value: 30,
                    needleLength: 0.55,
                    lengthUnit: GaugeSizeUnit.factor,
                    needleColor: _brightness == Brightness.dark ?
        const Color(0xFF888888): const Color(0xFFFCACACA),
                    needleEndWidth: isTileView ? 10 :
                    _orientation == Orientation.portrait ? 18: 10,
                    knobStyle: KnobStyle(
                        knobRadius: 0.1,
                        sizeUnit: GaugeSizeUnit.factor,
                        color: Colors.white))
              ],
            )
          ],
        );
  });
}


void labelCreated(AxisLabelCreatedArgs args) {
  if (args.text == '80' || args.text == '0') {
    args.text = 'N';
  } else if (args.text == '10') {
    args.text = 'NE';
  } else if (args.text == '20') {
    args.text = 'E';
  } else if (args.text == '30') {
    args.text = 'SE';
  } else if (args.text == '40') {
    args.text = 'S';
  } else if (args.text == '50') {
    args.text = 'SW';
  } else if (args.text == '60') {
    args.text = 'W';
  } else if (args.text == '70') {
    args.text = 'NW';
  }
}
