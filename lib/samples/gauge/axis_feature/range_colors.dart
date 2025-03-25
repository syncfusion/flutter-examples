/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge range color for axis labels sample
class RangeColorForLabels extends SampleView {
  /// Creates the gauge range color for axis labels sample
  const RangeColorForLabels(Key key) : super(key: key);

  @override
  _RangeColorForLabelsState createState() => _RangeColorForLabelsState();
}

class _RangeColorForLabelsState extends SampleViewState {
  _RangeColorForLabelsState();

  @override
  Widget build(BuildContext context) {
    return _buildRangeColorForLabels();
  }

  /// Returns the range color for axis labels gauge
  SfRadialGauge _buildRangeColorForLabels() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showAxisLine: false,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          startAngle: 270,
          endAngle: 270,
          useRangeColorForAxis: true,
          interval: 10,
          showFirstLabel: false,
          showLastLabel: true,
          isInversed: true,
          axisLabelStyle: const GaugeTextStyle(fontWeight: FontWeight.w500),
          majorTickStyle: const MajorTickStyle(
            length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          minorTicksPerInterval: 4,
          minorTickStyle: const MinorTickStyle(
            length: 0.04,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 35,
              color: const Color(0xFFF8B195),
              sizeUnit: GaugeSizeUnit.factor,
              rangeOffset: 0.06,
              startWidth: model.isWebFullView ? 0.2 : 0.05,
              endWidth: model.isWebFullView ? 0.2 : 0.25,
            ),
            GaugeRange(
              startValue: 35,
              endValue: 70,
              rangeOffset: 0.06,
              sizeUnit: GaugeSizeUnit.factor,
              color: const Color(0xFFC06C84),
              startWidth: model.isWebFullView ? 0.2 : 0.05,
              endWidth: model.isWebFullView ? 0.2 : 0.25,
            ),
            GaugeRange(
              startValue: 70,
              endValue: 100,
              rangeOffset: 0.06,
              sizeUnit: GaugeSizeUnit.factor,
              color: const Color(0xFF355C7D),
              startWidth: model.isWebFullView ? 0.2 : 0.05,
              endWidth: model.isWebFullView ? 0.2 : 0.25,
            ),
          ],
        ),
      ],
    );
  }
}
