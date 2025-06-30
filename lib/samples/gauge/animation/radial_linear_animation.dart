/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge pointer linear animation sample
class RadialLinearAnimation extends SampleView {
  /// Creates gauge with [linear] animation
  const RadialLinearAnimation(Key key) : super(key: key);

  @override
  _RadialLinearAnimationState createState() => _RadialLinearAnimationState();
}

class _RadialLinearAnimationState extends SampleViewState {
  _RadialLinearAnimationState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialLinearAnimation(context);
  }

  /// Returns the pointer linear animation gauge
  Widget _buildRadialLinearAnimation(BuildContext context) {
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
              color: _linearMarkerColor,
            ),
            NeedlePointer(
              knobStyle: KnobStyle(
                knobRadius:
                    MediaQuery.of(context).orientation == Orientation.portrait
                    ? 0.05
                    : 0.07,
                color: _linearNeedleColor,
              ),
              needleStartWidth: 0,
              needleEndWidth: 5,
              value: 12,
              enableAnimation: true,
              animationType: AnimationType.linear,
              needleLength: 0.8,
              needleColor:
                  model.themeData.colorScheme.brightness == Brightness.light
                  ? _linearNeedleColor
                  : _linearNeedleDarkColor,
            ),
          ],
          axisLineStyle: const AxisLineStyle(thickness: 3),
          tickOffset: 2,
          majorTickStyle: const MajorTickStyle(
            thickness: 2,
            length: 0.02,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          minorTicksPerInterval: 0,
        ),
      ],
    );
  }

  final Color _linearNeedleColor = const Color(0xFF355C7D);
  final Color _linearNeedleDarkColor = const Color(0xFFDCDCDC);
  final Color _linearMarkerColor = const Color(0xFFF67280);
}
