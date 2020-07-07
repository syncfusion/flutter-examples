import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

//ignore: must_be_immutable
class RadialLinearAnimation extends SampleView {
  const RadialLinearAnimation(Key key) : super(key: key);
  
  @override
  _RadialLinearAnimationState createState() =>
      _RadialLinearAnimationState();
}

class _RadialLinearAnimationState extends SampleViewState {
  _RadialLinearAnimationState();
  
  @override
  Widget build(BuildContext context) {
    return getRadialLinearAnimation(false);
  }


Widget getRadialLinearAnimation(bool isCardView) {
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
                      knobRadius: isCardView
                          ? 0.065
                          : MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 0.05
                              : 0.07,
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

final Color _linearNeedleColor = const Color(0xFF355C7D);
final Color _linearMarkerColor = const Color(0xFFF67280);
}