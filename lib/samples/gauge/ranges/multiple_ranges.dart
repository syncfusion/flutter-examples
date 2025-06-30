/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge multiple range sample
class MultipleRangesExample extends SampleView {
  /// Creates the gauge multiple range sample
  const MultipleRangesExample(Key key) : super(key: key);

  @override
  _MultipleRangesExampleState createState() => _MultipleRangesExampleState();
}

class _MultipleRangesExampleState extends SampleViewState {
  _MultipleRangesExampleState();

  @override
  Widget build(BuildContext context) {
    return _buildMultipleRangesExampleGauge(context);
  }

  /// Returns the multiple range gauge
  SfRadialGauge _buildMultipleRangesExampleGauge(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showAxisLine: false,
          showLabels: false,
          showTicks: false,
          startAngle: 180,
          endAngle: 360,
          maximum: 80,
          canScaleToFit: true,
          pointers: <GaugePointer>[
            NeedlePointer(
              value: 30,
              needleEndWidth: isCardView
                  ? 5
                  : MediaQuery.of(context).orientation == Orientation.portrait
                  ? 10
                  : 6,
              needleLength: 0.7,
              knobStyle: const KnobStyle(),
            ),
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 18,
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0,
              endWidth: 0.1,
              color: const Color(0xFFA8AAE2),
            ),
            GaugeRange(
              startValue: 20,
              endValue: 38,
              startWidth: 0.1,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.15,
              color: const Color.fromRGBO(168, 170, 226, 1),
            ),
            GaugeRange(
              startValue: 40,
              endValue: 58,
              startWidth: 0.15,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.2,
              color: const Color(0xFF7B7DC7),
            ),
            GaugeRange(
              startValue: 60,
              endValue: 78,
              startWidth: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.25,
              color: const Color.fromRGBO(73, 76, 162, 1),
            ),
          ],
        ),
      ],
    );
  }
}
