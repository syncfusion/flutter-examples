/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge direction compass sample using annotation
class RadialCompass extends SampleView {
  /// Creates the gauge direction compass sample using annotation
  const RadialCompass(Key key) : super(key: key);

  @override
  _RadialCompassState createState() => _RadialCompassState();
}

class _RadialCompassState extends SampleViewState {
  _RadialCompassState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialCompass();
  }

  /// Returns the direction compass gauge using annotation support
  SfRadialGauge _buildRadialCompass() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showAxisLine: false,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          startAngle: 320,
          endAngle: 320,
          minorTicksPerInterval: 10,
          maximum: 360,
          interval: 30,
          labelOffset: 20,
          majorTickStyle: const MajorTickStyle(
            length: 0.16,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          minorTickStyle: const MinorTickStyle(
            length: 0.16,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          axisLabelStyle: const GaugeTextStyle(),
          pointers: const <GaugePointer>[
            MarkerPointer(value: 90, markerType: MarkerType.triangle),
            NeedlePointer(
              value: 310,
              needleLength: 0.5,
              needleColor: Color(0xFFC4C4C4),
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0),
              tailStyle: TailStyle(
                color: Color(0xFFC4C4C4),
                width: 1,
                length: 0.5,
              ),
            ),
            NeedlePointer(
              value: 221,
              needleLength: 0.5,
              needleColor: Color(0xFFC4C4C4),
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0),
            ),
            NeedlePointer(
              value: 40,
              needleLength: 0.5,
              needleColor: Color(0xFFC4C4C4),
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0),
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 230,
              positionFactor: 0.38,
              widget: Text(
                'W',
                style: TextStyle(
                  fontFamily: 'Times',
                  fontWeight: FontWeight.bold,
                  fontSize: isCardView ? 12 : 18,
                ),
              ),
            ),
            GaugeAnnotation(
              angle: 310,
              positionFactor: 0.38,
              widget: Text(
                'N',
                style: TextStyle(
                  fontFamily: 'Times',
                  fontWeight: FontWeight.bold,
                  fontSize: isCardView ? 12 : 18,
                ),
              ),
            ),
            GaugeAnnotation(
              angle: 129,
              positionFactor: 0.38,
              widget: Text(
                'S',
                style: TextStyle(
                  fontFamily: 'Times',
                  fontWeight: FontWeight.bold,
                  fontSize: isCardView ? 12 : 18,
                ),
              ),
            ),
            GaugeAnnotation(
              angle: 50,
              positionFactor: 0.38,
              widget: Text(
                'E',
                style: TextStyle(
                  fontFamily: 'Times',
                  fontWeight: FontWeight.bold,
                  fontSize: isCardView ? 12 : 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
