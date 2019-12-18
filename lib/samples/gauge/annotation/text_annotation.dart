import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RadialTextAnnotation extends StatefulWidget {
  RadialTextAnnotation({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialTextAnnotationState createState() =>
      _RadialTextAnnotationState(sample);
}

class _RadialTextAnnotationState extends State<RadialTextAnnotation> {
  _RadialTextAnnotationState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialTextAnnotation(false), sample);
  }
}

SfRadialGauge getRadialTextAnnotation(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(showTicks: false,
        showLabels: false,
        startAngle: 180,
        endAngle: 180,
        radiusFactor: 0.9,
        axisLineStyle: AxisLineStyle(
            thickness: 30, dashArray: <double>[8, 10]
        ),
      ),
      RadialAxis(showTicks: false,
          showLabels: false,
          startAngle: 180,
          endAngle: 50,
          radiusFactor: 0.9,
          annotations: <GaugeAnnotation>[GaugeAnnotation(
              angle: 270, positionFactor: 0, verticalAlignment: GaugeAlignment.far,

              widget: Container(child:Text(' 63%',

                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      fontSize: isTileView ? 18 : 25))))],
          axisLineStyle: AxisLineStyle(
              color:  const Color(0xFF00A8B5),
              gradient: const SweepGradient(
                  colors: <Color>[Color(0xFF06974A), Color(0xFFF2E41F)],
                  stops: <double>[0.25, 0.75]
              ),
              thickness: 30, dashArray: <double>[8, 10]
          ))
    ],
  );
}
