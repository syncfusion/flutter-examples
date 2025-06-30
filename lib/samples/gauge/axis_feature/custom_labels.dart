/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge axis custom label sample
class GaugeCustomLabels extends SampleView {
  /// Creates the gauge axis custom label sample
  const GaugeCustomLabels(Key key) : super(key: key);

  @override
  _GaugeCustomLabelsState createState() => _GaugeCustomLabelsState();
}

class _GaugeCustomLabelsState extends SampleViewState {
  _GaugeCustomLabelsState();

  @override
  Widget build(BuildContext context) {
    return _buildGaugeCustomLabels(context);
  }

  /// Returns the custom label axis gauge
  SfRadialGauge _buildGaugeCustomLabels(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Brightness brightness = Theme.of(context).brightness;

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          maximum: 80,
          axisLineStyle: const AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: 0.1,
          ),
          interval: 10,
          canRotateLabels: true,
          axisLabelStyle: const GaugeTextStyle(),
          minorTicksPerInterval: 0,
          majorTickStyle: const MajorTickStyle(
            lengthUnit: GaugeSizeUnit.factor,
            length: 0.07,
          ),
          onLabelCreated: _handleLabelCreated,
          pointers: <GaugePointer>[
            NeedlePointer(
              value: 70,
              needleLength: 0.55,
              needleEndWidth: model.isWebFullView
                  ? 18
                  : isCardView
                  ? 10
                  : orientation == Orientation.portrait
                  ? 18
                  : 10,
              gradient: const LinearGradient(
                colors: <Color>[
                  Color(0xFFFF6B78),
                  Color(0xFFFF6B78),
                  Color(0xFFE20A22),
                  Color(0xFFE20A22),
                ],
                stops: <double>[0, 0.5, 0.5, 1],
              ),
              needleColor: const Color(0xFFF67280),
              knobStyle: KnobStyle(
                knobRadius: model.isWebFullView ? 0.098 : 0.09,
                color: Colors.white,
              ),
            ),
            NeedlePointer(
              gradient: const LinearGradient(
                colors: <Color>[
                  Color(0xFFE3DFDF),
                  Color(0xFFE3DFDF),
                  Color(0xFF7A7A7A),
                  Color(0xFF7A7A7A),
                ],
                stops: <double>[0, 0.5, 0.5, 1],
              ),
              value: 30,
              needleLength: 0.55,
              needleColor: brightness == Brightness.dark
                  ? const Color(0xFF888888)
                  : const Color(0x0ffcacca),
              needleEndWidth: model.isWebFullView
                  ? 18
                  : isCardView
                  ? 10
                  : orientation == Orientation.portrait
                  ? 18
                  : 10,
              knobStyle: KnobStyle(
                knobRadius: model.isWebFullView ? 0.098 : 0.09,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Handled callback for change numeric value to compass directional letter.
  void _handleLabelCreated(AxisLabelCreatedArgs args) {
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
}
