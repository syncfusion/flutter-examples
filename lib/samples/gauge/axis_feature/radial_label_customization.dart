/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge label customization sample
class RadialLabelCustomization extends SampleView {
  /// Creates the gauge label customization sample
  const RadialLabelCustomization(Key key) : super(key: key);

  @override
  _RadialLabelCustomizationState createState() =>
      _RadialLabelCustomizationState();
}

class _RadialLabelCustomizationState extends SampleViewState {
  _RadialLabelCustomizationState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialLabelCustomization();
  }

  /// Returns the customized axis label gauge
  SfRadialGauge _buildRadialLabelCustomization() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            startAngle: 180,
            endAngle: 360,
            canScaleToFit: true,
            interval: 10,
            radiusFactor: 0.95,
            labelFormat: '{value}%',
            labelsPosition: ElementsPosition.outside,
            ticksPosition: ElementsPosition.inside,
            labelOffset: 15,
            minorTickStyle: const MinorTickStyle(
                length: 0.05, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
            majorTickStyle: const MajorTickStyle(
                length: 0.1, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
            minorTicksPerInterval: 5,
            pointers: <GaugePointer>[
              NeedlePointer(
                  value: 70,
                  needleStartWidth: 1,
                  needleEndWidth: 3,
                  needleLength: 0.8,
                  lengthUnit: GaugeSizeUnit.factor,
                  knobStyle: const KnobStyle(
                    knobRadius: 8,
                    sizeUnit: GaugeSizeUnit.logicalPixel,
                  ),
                  tailStyle: const TailStyle(
                      width: 3,
                      lengthUnit: GaugeSizeUnit.logicalPixel,
                      length: 20))
            ],
            axisLabelStyle:
                const GaugeTextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            axisLineStyle:
                const AxisLineStyle(thickness: 3, color: Color(0xFF00A8B5))),
      ],
    );
  }
}
