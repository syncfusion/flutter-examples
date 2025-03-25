/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge axis tick customization sample
class RadialTickCustomization extends SampleView {
  /// Creates the gauge axis tick customization sample
  const RadialTickCustomization(Key key) : super(key: key);

  @override
  _RadialTickCustomizationState createState() =>
      _RadialTickCustomizationState();
}

class _RadialTickCustomizationState extends SampleViewState {
  _RadialTickCustomizationState();

  @override
  Widget build(BuildContext context) {
    return getRadialTickCustomization();
  }

  /// Returns the axis tick customized gauge
  SfRadialGauge getRadialTickCustomization() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          showAxisLine: false,
          onLabelCreated: _handleLabelCreated,
          startAngle: 270,
          endAngle: 270,
          canRotateLabels: true,
          labelsPosition: ElementsPosition.outside,
          axisLabelStyle: const GaugeTextStyle(),
          majorTickStyle: MajorTickStyle(
            length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
            dashArray: model.isWebFullView ? null : <double>[2, 1],
          ),
          minorTicksPerInterval: 4,
          interval: 10,
          minorTickStyle: MinorTickStyle(
            length: 0.06,
            thickness: 1,
            lengthUnit: GaugeSizeUnit.factor,

            /// Dash array not supported in web.
            dashArray: model.isWebFullView ? null : <double>[2, 1],
          ),
          pointers: <GaugePointer>[
            NeedlePointer(
              enableAnimation: !model.isWebFullView,
              animationDuration: 1300,
              value: 75,
              needleColor: _tickCustomizationNeedleColor,
              needleStartWidth: 0,
              needleEndWidth: 3,
              needleLength: 0.8,
              tailStyle: TailStyle(
                width: 3,
                lengthUnit: GaugeSizeUnit.logicalPixel,
                length: 20,
                color: _tickCustomizationNeedleColor,
              ),
              knobStyle: KnobStyle(
                knobRadius: 8,
                sizeUnit: GaugeSizeUnit.logicalPixel,
                color: _tickCustomizationNeedleColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Handled callback to hide last label value.
  void _handleLabelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '100') {
      args.text = '';
    }
  }

  final Color _tickCustomizationNeedleColor = const Color(0xFF494CA2);
}
