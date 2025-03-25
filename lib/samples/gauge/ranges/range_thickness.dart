/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge range thickness sample
class RangeThicknessExample extends SampleView {
  /// Creates the gauge range thickness sample
  const RangeThicknessExample(Key key) : super(key: key);

  @override
  _RangeThicknessExampleState createState() => _RangeThicknessExampleState();
}

class _RangeThicknessExampleState extends SampleViewState {
  _RangeThicknessExampleState();

  @override
  Widget build(BuildContext context) {
    return _buildRangeThicknessExampleGauge();
  }

  /// Returns the range thickness gauge
  SfRadialGauge _buildRangeThicknessExampleGauge() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showAxisLine: false,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          radiusFactor: 0.9,
          canRotateLabels: true,
          showLastLabel: true,
          majorTickStyle: const MajorTickStyle(
            length: 0.1,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          minorTickStyle: const MinorTickStyle(
            length: 0.04,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          minorTicksPerInterval: 5,
          interval: 10,
          axisLabelStyle: const GaugeTextStyle(),
          useRangeColorForAxis: true,
          pointers: const <GaugePointer>[
            NeedlePointer(
              enableAnimation: true,
              value: 70,
              tailStyle: TailStyle(length: 0.2, width: 5),
              needleEndWidth: 5,
              needleLength: 0.7,
              knobStyle: KnobStyle(),
            ),
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 30,
              endValue: 100,
              startWidth: model.isWebFullView ? 0.2 : 0.05,
              gradient: const SweepGradient(
                colors: <Color>[Color(0xFF289AB1), Color(0xFF43E695)],
                stops: <double>[0.25, 0.75],
              ),
              color: const Color(0xFF289AB1),
              rangeOffset: 0.08,
              endWidth: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
            ),
          ],
        ),
      ],
    );
  }
}
