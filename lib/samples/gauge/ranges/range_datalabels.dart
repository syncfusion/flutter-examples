/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge range data label sample
class RangeDataLabelExample extends SampleView {
  /// Creates the gauge range data label sample
  const RangeDataLabelExample(Key key) : super(key: key);

  @override
  _RangeDataLabelExampleState createState() => _RangeDataLabelExampleState();
}

class _RangeDataLabelExampleState extends SampleViewState {
  _RangeDataLabelExampleState();

  @override
  Widget build(BuildContext context) {
    return _buildRangeDataLabelExample();
  }

  /// Returns the range data label gauge
  SfRadialGauge _buildRangeDataLabelExample() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showLabels: false,
          showAxisLine: false,
          showTicks: false,
          maximum: 99,
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 33,
              color: const Color(0xFFFE2A25),
              // Added range label
              label: 'Slow',
              sizeUnit: GaugeSizeUnit.factor,
              labelStyle: GaugeTextStyle(
                fontFamily: 'Times',
                fontSize: isCardView ? 16 : 20,
              ),
              startWidth: 0.65,
              endWidth: 0.65,
            ),
            GaugeRange(
              startValue: 33,
              endValue: 66,
              color: const Color(0xFFFFBA00),
              // Added range label
              label: 'Moderate',
              labelStyle: GaugeTextStyle(
                fontFamily: 'Times',
                fontSize: isCardView ? 16 : 20,
              ),
              startWidth: 0.65,
              endWidth: 0.65,
              sizeUnit: GaugeSizeUnit.factor,
            ),
            GaugeRange(
              startValue: 66,
              endValue: 99,
              color: const Color(0xFF00AB47),
              // Added range label
              label: 'Fast',
              labelStyle: GaugeTextStyle(
                fontFamily: 'Times',
                fontSize: isCardView ? 16 : 20,
              ),
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.65,
              endWidth: 0.65,
            ),
            // Added small height range in bottom to show shadow effect.
            GaugeRange(
              startValue: 0,
              endValue: 99,
              color: const Color.fromRGBO(155, 155, 155, 0.3),
              rangeOffset: 0.5,
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.15,
              endWidth: 0.15,
            ),
          ],
          pointers: const <GaugePointer>[
            NeedlePointer(
              value: 60,
              needleLength: 0.7,
              knobStyle: KnobStyle(
                knobRadius: 12,
                sizeUnit: GaugeSizeUnit.logicalPixel,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
