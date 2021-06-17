/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge pointer elastic out animation sample
class RadialElasticOutAnimation extends SampleView {
  /// Creates gauge with [elasticOut] animation
  const RadialElasticOutAnimation(Key key) : super(key: key);

  @override
  _RadialElasticOutAnimationState createState() =>
      _RadialElasticOutAnimationState();
}

/// Returns pointer elastic out animation gauge
class _RadialElasticOutAnimationState extends SampleViewState {
  _RadialElasticOutAnimationState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialElasticOutAnimation();
  }

  SfRadialGauge _buildRadialElasticOutAnimation() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            startAngle: 180,
            endAngle: 360,
            showAxisLine: true,
            canScaleToFit: true,
            interval: 10,
            showLabels: false,
            radiusFactor: 0.9,
            majorTickStyle: const MajorTickStyle(
                length: 0.1, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
            minorTicksPerInterval: 4,
            pointers: <GaugePointer>[
              RangePointer(
                  gradient: const SweepGradient(
                      colors: <Color>[Color(0xFFD481FF), Color(0xFF06F0E0)],
                      stops: <double>[0.25, 0.75]),
                  value: 70,
                  width: 5,
                  animationDuration: 2000,
                  enableAnimation: true,
                  animationType: AnimationType.elasticOut,
                  color: const Color(0xFF00A8B5)),
              NeedlePointer(
                  value: 70,
                  needleStartWidth: 0,
                  needleColor:
                      model.isWebFullView ? null : const Color(0xFFD481FF),
                  lengthUnit: GaugeSizeUnit.factor,
                  needleLength: 1,
                  enableAnimation: true,
                  animationDuration: 2000,
                  animationType: AnimationType.elasticOut,
                  needleEndWidth: 5,
                  knobStyle: const KnobStyle(
                      knobRadius: 0, sizeUnit: GaugeSizeUnit.factor))
            ],
            minorTickStyle: const MinorTickStyle(
                length: 0.04, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
            axisLineStyle: const AxisLineStyle(color: Colors.transparent))
      ],
    );
  }
}
