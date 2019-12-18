import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RadialGaugeDefault extends StatefulWidget {
  RadialGaugeDefault({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialGaugeDefaultState createState() => _RadialGaugeDefaultState(sample);
}

class _RadialGaugeDefaultState extends State<RadialGaugeDefault> {
  _RadialGaugeDefaultState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getDefaultRadialGauge(false), sample);
  }
}

SfRadialGauge getDefaultRadialGauge(bool isTileView) {
  return SfRadialGauge(  enableLoadingAnimation: true,
    axes: <RadialAxis>[
      RadialAxis(
          interval: 10,
          axisLineStyle: AxisLineStyle(
            thickness: 0.03,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          showTicks: false,
          axisLabelStyle: GaugeTextStyle(
            fontSize: isTileView ? 12 : 14,
          ),
          labelOffset: 25,
          radiusFactor: 0.95,
          pointers: <GaugePointer>[
            NeedlePointer(
                needleLength: 0.7,
                value: 70,
                lengthUnit: GaugeSizeUnit.factor,
                needleColor: _needleColor,
                needleStartWidth: 0,
                needleEndWidth: isTileView ? 3 : 4,
                knobStyle: KnobStyle(
                    sizeUnit: GaugeSizeUnit.factor,
                    color: _needleColor,
                    knobRadius: 0.05)),
          ])
    ],
  );
}

Color _needleColor = const Color(0xFFC06C84);
