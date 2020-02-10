import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

//ignore: must_be_immutable
class RadialLinearAnimation extends StatefulWidget {
  RadialLinearAnimation({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialLinearAnimationState createState() =>
      _RadialLinearAnimationState(sample);
}

class _RadialLinearAnimationState extends State<RadialLinearAnimation> {
  _RadialLinearAnimationState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialLinearAnimation(false), sample);
  }
}

Widget getRadialLinearAnimation(bool isTileView) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                startAngle: 270,
                endAngle: 270,
                showLabels: false,
                radiusFactor: 0.8,
                pointers: <GaugePointer>[
                  MarkerPointer(
                      markerHeight: 20,
                      markerWidth: 20,
                      markerType: MarkerType.triangle,
                      markerOffset: 17,
                      value: 80,
                      enableAnimation: true,
                      animationType: AnimationType.linear,
                      color: _linearMarkerColor),
                  NeedlePointer(
                      knobStyle: KnobStyle(
                          knobRadius: isTileView ? 0.065 :
                          MediaQuery.of(context).orientation ==
                              Orientation.portrait ? 0.05 : 0.07,
                          color: _linearNeedleColor),
                      needleStartWidth: 0,
                      needleEndWidth: 5,
                      value: 12,
                      enableAnimation: true,
                      animationType: AnimationType.linear,
                      lengthUnit: GaugeSizeUnit.factor,
                      needleLength: 0.8,
                      needleColor: _linearNeedleColor)
                ],
                axisLineStyle: AxisLineStyle(thickness: 3),
                tickOffset: 2,
                majorTickStyle: MajorTickStyle(
                    thickness: 2, length: 0.02, lengthUnit: GaugeSizeUnit.factor),
                minorTicksPerInterval: 0),
          ],
        );
      });


}

Color _linearNeedleColor = const Color(0xFF355C7D);
Color _linearMarkerColor = const Color(0xFFF67280);
