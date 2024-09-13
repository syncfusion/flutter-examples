/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge image annotation sample
class RadialImageAnnotation extends SampleView {
  /// Creates the gauge image annotation sample
  const RadialImageAnnotation(Key key) : super(key: key);

  @override
  _RadialImageAnnotationState createState() => _RadialImageAnnotationState();
}

class _RadialImageAnnotationState extends SampleViewState {
  _RadialImageAnnotationState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialImageAnnotation();
  }

  /// Returns the image annotation gauge
  SfRadialGauge _buildRadialImageAnnotation() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          interval: 10,
          radiusFactor: model.isWebFullView ? 0.8 : 0.95,
          startAngle: 0,
          endAngle: 360,
          showTicks: false,
          showLabels: false,
          axisLineStyle: const AxisLineStyle(thickness: 20),
          pointers: const <GaugePointer>[
            RangePointer(
              value: 73,
              width: 20,
              color: Color(0xFFFFCD60),
              enableAnimation: true,
              gradient: SweepGradient(
                colors: <Color>[Color(0xFFFCE38A), Color(0xFFF38181)],
                stops: <double>[0.25, 0.75],
              ),
              cornerStyle: CornerStyle.bothCurve,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 270,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Added image widget as an annotation
                  Container(
                    width: isCardView ? 30.00 : 50.00,
                    height: isCardView ? 30.00 : 50.00,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('images/sun.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      '73°F',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isCardView ? 15.00 : 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
