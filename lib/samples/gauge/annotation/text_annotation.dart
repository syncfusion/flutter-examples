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
    return _getRadialTextAnnotation();
  }

  /// Returns the text annotation gauge
  SfRadialGauge _getRadialTextAnnotation() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showTicks: false,
          showLabels: false,
          startAngle: 180,
          endAngle: 180,
          radiusFactor: model.isWeb ? 0.8 : 0.9,
          axisLineStyle: AxisLineStyle(
              // Dash array not supported in web
              thickness: 30,
              dashArray: model.isWeb ? null : <double>[8, 10]),
        ),
        RadialAxis(
            showTicks: false,
            showLabels: false,
            startAngle: 180,
            endAngle: 50,
            radiusFactor: model.isWeb ? 0.8 : 0.9,
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 270,
                  positionFactor: 0,
                  verticalAlignment: GaugeAlignment.far,
                  widget: Container(
                      // added text widget as an annotation.
                      child: Text(' 63%',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Times',
                              fontWeight: FontWeight.bold,
                              fontSize: isCardView ? 18 : 25))))
            ],
            axisLineStyle: AxisLineStyle(
                color: const Color(0xFF00A8B5),
                // Sweep gradient not supported in web
                gradient: model.isWeb
                    ? null
                    : const SweepGradient(
                        colors: <Color>[Color(0xFF06974A), Color(0xFFF2E41F)],
                        stops: <double>[0.25, 0.75]),
                thickness: 30,
                dashArray: model.isWeb ? null : <double>[8, 10]))
      ],
    );
  }
}
