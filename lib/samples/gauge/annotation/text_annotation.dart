/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge text annotation sample
class RadialTextAnnotation extends SampleView {
  /// Creates the gauge text annotation sample
  const RadialTextAnnotation(Key key) : super(key: key);

  @override
  _RadialTextAnnotationState createState() => _RadialTextAnnotationState();
}

class _RadialTextAnnotationState extends SampleViewState {
  _RadialTextAnnotationState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialTextAnnotation();
  }

  /// Returns the text annotation gauge
  SfRadialGauge _buildRadialTextAnnotation() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showTicks: false,
          showLabels: false,
          startAngle: 180,
          endAngle: 180,
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          axisLineStyle: const AxisLineStyle(
            // Dash array not supported in web
            thickness: 30,
            dashArray: <double>[8, 10],
          ),
        ),
        RadialAxis(
          showTicks: false,
          showLabels: false,
          startAngle: 180,
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 270,
              widget: Text(
                ' 63%',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Times',
                  fontWeight: FontWeight.bold,
                  fontSize: isCardView ? 18 : 25,
                ),
              ),
            ),
          ],
          axisLineStyle: const AxisLineStyle(
            color: Color(0xFF00A8B5),
            gradient: SweepGradient(
              colors: <Color>[Color(0xFF06974A), Color(0xFFF2E41F)],
              stops: <double>[0.25, 0.75],
            ),
            thickness: 30,
            dashArray: <double>[8, 10],
          ),
        ),
      ],
    );
  }
}
