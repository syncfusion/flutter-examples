/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge pointer bounce out animation sample
class RadialBounceOutExample extends SampleView {
  /// Creates the gauge pointer bounce out animation sample
  const RadialBounceOutExample(Key key) : super(key: key);

  @override
  _RadialBounceOutExampleState createState() => _RadialBounceOutExampleState();
}

class _RadialBounceOutExampleState extends SampleViewState {
  _RadialBounceOutExampleState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialBounceOutExample();
  }

  /// Returns the pointer bounce out animation gauge
  SfRadialGauge _buildRadialBounceOutExample() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          radiusFactor: model.isWebFullView ? 0.85 : 0.98,
          startAngle: 90,
          endAngle: 330,
          minimum: -8,
          maximum: 12,
          showAxisLine: false,
          showLastLabel: true,
          majorTickStyle: const MajorTickStyle(
            length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 2,
          ),
          labelOffset: 8,
          axisLabelStyle: GaugeTextStyle(
            fontFamily: 'Times',
            fontSize: isCardView ? 10 : 12,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
          minorTicksPerInterval: 9,
          interval: 2,
          pointers: const <GaugePointer>[
            NeedlePointer(
              needleStartWidth: 2,
              needleEndWidth: 2,
              needleColor: Color(0xFFF67280),
              needleLength: 0.8,
              enableAnimation: true,
              animationType: AnimationType.bounceOut,
              animationDuration: 1500,
              knobStyle: KnobStyle(
                knobRadius: 8,
                sizeUnit: GaugeSizeUnit.logicalPixel,
                color: Color(0xFFF67280),
              ),
            ),
          ],
          minorTickStyle: const MinorTickStyle(
            length: 0.08,
            thickness: 1,
            lengthUnit: GaugeSizeUnit.factor,
            color: Color(0xFFC4C4C4),
          ),
          axisLineStyle: const AxisLineStyle(
            color: Color(0xFFDADADA),
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: 0.1,
          ),
        ),
      ],
    );
  }
}
