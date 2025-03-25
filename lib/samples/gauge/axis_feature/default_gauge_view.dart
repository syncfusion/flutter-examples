/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge axis default sample.
class RadialGaugeDefault extends SampleView {
  /// Renders default radial gauge widget
  const RadialGaugeDefault(Key key) : super(key: key);

  @override
  _RadialGaugeDefaultState createState() => _RadialGaugeDefaultState();
}

class _RadialGaugeDefaultState extends SampleViewState {
  _RadialGaugeDefaultState();

  @override
  Widget build(BuildContext context) {
    return _buildDefaultRadialGauge();
  }

  /// Returns the default axis gauge
  SfRadialGauge _buildDefaultRadialGauge() {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          interval: 10,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.03,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          showTicks: false,
          showLastLabel: true,
          axisLabelStyle: GaugeTextStyle(fontSize: isCardView ? 12 : 14),
          labelOffset: 25,
          radiusFactor: model.isWebFullView ? 0.8 : 0.95,
          pointers: <GaugePointer>[
            NeedlePointer(
              needleLength: 0.7,
              value: 70,
              needleColor: _needleColor,
              needleStartWidth: 0,
              needleEndWidth: isCardView ? 3 : 4,
              knobStyle: KnobStyle(color: _needleColor, knobRadius: 0.05),
            ),
          ],
        ),
      ],
    );
  }

  final Color _needleColor = const Color(0xFFC06C84);
}
