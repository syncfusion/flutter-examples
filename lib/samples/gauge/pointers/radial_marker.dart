import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RadialMarkerExample extends StatefulWidget {
  RadialMarkerExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialMarkerExampleState createState() => _RadialMarkerExampleState(sample);
}

class _RadialMarkerExampleState extends State<RadialMarkerExample> {
  _RadialMarkerExampleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialMarkerExample(false), sample);
  }
}

SfRadialGauge getRadialMarkerExample(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          startAngle: 180,
          endAngle: 360,
          radiusFactor: 0.9,
          centerY: 0.6,
          interval: 10,
          showLabels: false,
          showAxisLine: false,
          pointers: <GaugePointer>[
            MarkerPointer(
                value: 70,
                markerWidth: 20,
                markerHeight: 20,
                color: const Color(0xFFF67280),
                markerType: MarkerType.invertedTriangle,
                markerOffset: -7)
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 175,
                positionFactor: 0.8,
                widget: Container(
                    child: Text('Min',
                        style: TextStyle(
                            fontSize: isTileView ? 12 : 16,
                            fontWeight: FontWeight.bold)))),
            GaugeAnnotation(
                angle: 270,
                positionFactor: 0.1,
                widget: Container(
                    child: Text('70%',
                        style: TextStyle(
                            fontSize: isTileView ? 12 : 16,
                            fontWeight: FontWeight.bold)))),
            GaugeAnnotation(
                angle: 5,
                positionFactor: 0.8,
                widget: Container(
                    child: Text('Max',
                        style: TextStyle(
                            fontSize: isTileView ? 12 : 16,
                            fontWeight: FontWeight.bold))))
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 100,
              sizeUnit: GaugeSizeUnit.factor,
              gradient: const SweepGradient(
                  colors: <Color>[Color(0xFFAB64F5), Color(0xFF62DBF6)],
                  stops: <double>[0.25, 0.75]),
              startWidth: 0.4,
              endWidth: 0.4,
              color: const Color(0xFF00A8B5),
            )
          ],
          showTicks: false),
    ],
  );
}
