/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge pointer ease out animation sample
class RadialEaseOutAnimation extends SampleView {
  /// Creates gauge with [easeOutBack] animation
  const RadialEaseOutAnimation(Key key) : super(key: key);

  @override
  _RadialEaseOutAnimationState createState() => _RadialEaseOutAnimationState();
}

class _RadialEaseOutAnimationState extends SampleViewState {
  _RadialEaseOutAnimationState();

  final Color _darkNeedleColor = const Color(0xFFDCDCDC);

  @override
  Widget build(BuildContext context) {
    return _buildRadialEaseOutAnimation();
  }

  /// Returns the pointer ease out animation gauge
  SfRadialGauge _buildRadialEaseOutAnimation() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 180,
          endAngle: 360,
          showTicks: false,
          showLabels: false,
          canScaleToFit: true,
          radiusFactor: 0.8,
          maximum: 50,
          axisLineStyle: const AxisLineStyle(thickness: 40),
          pointers: <GaugePointer>[
            const RangePointer(
              enableAnimation: true,
              animationType: AnimationType.easeOutBack,
              width: 40,
              color: Color(0xFF00A8B5),
              value: 40,
              gradient: SweepGradient(
                colors: <Color>[Color(0xFFD046CA), Color(0xFF6094EA)],
                stops: <double>[0.25, 0.75],
              ),
            ),
            NeedlePointer(
              knobStyle: KnobStyle(
                color:
                    model.themeData.colorScheme.brightness == Brightness.light
                    ? null
                    : _darkNeedleColor,
                knobRadius: 5,
                sizeUnit: GaugeSizeUnit.logicalPixel,
              ),
              needleEndWidth: 2,
              needleStartWidth: 2,
              needleColor:
                  model.themeData.colorScheme.brightness == Brightness.light
                  ? null
                  : _darkNeedleColor,
              needleLength: 0.98,
              value: 40,
              enableAnimation: true,
              animationType: AnimationType.easeOutBack,
            ),
          ],
        ),
      ],
    );
  }
}
