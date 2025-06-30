// Dart imports
import 'dart:async';
import 'dart:math' as math;

/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge clock sample.
class ClockExample extends SampleView {
  /// Creates the gauge clock sample.
  const ClockExample(Key key) : super(key: key);

  @override
  _ClockExampleState createState() => _ClockExampleState();
}

class _ClockExampleState extends SampleViewState {
  _ClockExampleState();
  late Timer timer;
  bool enableNeedleAnimation = true;

  @override
  void initState() {
    super.initState();
    // update the needle pointer in 1 second interval
    timer = Timer.periodic(const Duration(milliseconds: 1000), _updateData);
  }

  void _updateData(Timer timer) {
    final double previousValue = _value;
    setState(() {
      if (previousValue >= 0 && previousValue < 12) {
        if (!enableNeedleAnimation) {
          enableNeedleAnimation = true;
        }

        _value = _value + 0.2;
      } else {
        enableNeedleAnimation = false;
        _value = 0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double containerSize = math.min(size.width, size.height);
    return Center(
      child: SizedBox(
        height: containerSize,
        width: containerSize,
        child: _buildClockExample(),
      ),
    );
  }

  /// Returns the gauge clock
  SfRadialGauge _buildClockExample() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        /// Renders inner axis and positioned it using CenterX and
        /// CenterY properties and reduce the radius using radiusFactor
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          radiusFactor: 0.2,
          axisLabelStyle: const GaugeTextStyle(fontSize: 6),
          maximum: 12,
          showFirstLabel: false,
          showLastLabel: true,
          offsetUnit: GaugeSizeUnit.factor,
          interval: 2,
          centerY: 0.66,
          tickOffset: 0.03,
          minorTicksPerInterval: 5,
          labelOffset: 0.2,
          minorTickStyle: const MinorTickStyle(
            length: 0.09,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 0.5,
          ),
          majorTickStyle: const MajorTickStyle(
            length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          axisLineStyle: const AxisLineStyle(
            thickness: 0.03,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: const <GaugePointer>[
            NeedlePointer(
              value: 5,
              needleLength: 0.7,
              needleColor: Color(0xFF00A8B5),
              needleStartWidth: 0.5,
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0),
            ),
          ],
        ),

        /// Renders inner axis and positioned it using CenterX and
        /// CenterY properties and reduce the radius using radiusFactor
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          axisLabelStyle: const GaugeTextStyle(fontSize: 6),
          radiusFactor: 0.2,
          labelOffset: 0.2,
          offsetUnit: GaugeSizeUnit.factor,
          maximum: 12,
          showFirstLabel: false,
          showLastLabel: true,
          interval: 2,
          centerX: isCardView
              ? 0.38
              : model.isWebFullView
              ? 0.38
              : 0.335,
          minorTicksPerInterval: 5,
          tickOffset: 0.03,
          minorTickStyle: const MinorTickStyle(
            length: 0.09,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 0.5,
          ),
          majorTickStyle: const MajorTickStyle(
            length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          axisLineStyle: const AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: 0.03,
          ),
          pointers: const <GaugePointer>[
            NeedlePointer(
              value: 8,
              needleLength: 0.7,
              needleColor: Color(0xFF00A8B5),
              needleStartWidth: 0.5,
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0),
            ),
          ],
        ),
        // Renders outer axis
        RadialAxis(
          startAngle: 270,
          endAngle: 270,
          maximum: 12,
          showFirstLabel: false,
          showLastLabel: true,
          interval: 1,
          radiusFactor: model.isWebFullView ? 0.8 : 0.95,
          labelOffset: 0.1,
          offsetUnit: GaugeSizeUnit.factor,
          minorTicksPerInterval: 4,
          tickOffset: 0.03,
          minorTickStyle: const MinorTickStyle(
            length: 0.06,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          majorTickStyle: const MajorTickStyle(
            length: 0.1,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          axisLabelStyle: GaugeTextStyle(fontSize: isCardView ? 12 : 14),
          axisLineStyle: const AxisLineStyle(
            thickness: 0.01,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            NeedlePointer(
              needleEndWidth: 2,
              value: 10,
              needleColor: _needleColor,
              knobStyle: const KnobStyle(knobRadius: 0),
            ),
            NeedlePointer(
              needleLength: 0.85,
              needleStartWidth: 0.5,
              needleEndWidth: 1.5,
              value: 2,
              knobStyle: const KnobStyle(
                color: Color(0xFF00A8B5),
                knobRadius: 0.05,
              ),
              needleColor: _needleColor,
            ),
            NeedlePointer(
              needleLength: 0.9,
              enableAnimation: enableNeedleAnimation,
              animationType: AnimationType.bounceOut,
              needleStartWidth: 0.8,
              needleEndWidth: 0.8,
              value: _value,
              needleColor: const Color(0xFF00A8B5),
              tailStyle: const TailStyle(
                width: 0.8,
                length: 0.2,
                color: Color(0xFF00A8B5),
              ),
              knobStyle: const KnobStyle(knobRadius: 0.03, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  double _value = 0;
  final Color _needleColor = const Color(0xFF355C7D);
}
