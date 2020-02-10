import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RadialImageAnnotation extends StatefulWidget {
  RadialImageAnnotation({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialImageAnnotationState createState() =>
      _RadialImageAnnotationState(sample);
}

class _RadialImageAnnotationState extends State<RadialImageAnnotation> {
  _RadialImageAnnotationState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialImageAnnotation(false), sample);
  }
}

SfRadialGauge getRadialImageAnnotation(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          interval: 10,
          radiusFactor: 0.95,
          startAngle: 0,
          endAngle: 360,
          showTicks: false,
          showLabels: false,
          axisLineStyle: AxisLineStyle(thickness: 20),
          pointers: <GaugePointer>[
            RangePointer(
                value: 73,
                width: 20,
                color: const Color(0xFFFFCD60),
                enableAnimation: true,
                gradient: const SweepGradient(
                    colors: <Color>[Color(0xFFFCE38A), Color(0xFFF38181)],
                    stops: <double>[0.25, 0.75]),
                cornerStyle: CornerStyle.bothCurve)
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Column(
                  children: <Widget>[
                    Container(
                        width: isTileView ? 30.00 : 50.00,
                        height: isTileView ? 30.00 : 50.00,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:ExactAssetImage('images/sun.png'),
                            fit: BoxFit.fill,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Container(
                        child: Text('73°F',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isTileView ? 15.00 : 25)),
                      ),
                    )
                  ],
                ),
                angle: 270,
                positionFactor: 0.1)
          ])
    ],
  );
}
