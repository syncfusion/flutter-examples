import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class MultipleRangePointerExample extends StatefulWidget {
   MultipleRangePointerExample({this.sample, Key key}) : super(key: key);
   SubItem sample;

  @override
  _MultipleRangePointerExampleState createState() => _MultipleRangePointerExampleState(sample);
}

class _MultipleRangePointerExampleState extends State<MultipleRangePointerExample> {
  _MultipleRangePointerExampleState(this.sample);
  final SubItem sample;
  
  @override
  Widget build(BuildContext context) {
    return getScopedModel(getMultipleRangePointerExampleGauge(false), sample);
  }
}


SfRadialGauge getMultipleRangePointerExampleGauge(bool isTileView) {
  return SfRadialGauge(
    axes: <RadialAxis>[

      RadialAxis( showLabels: false, showTicks: false,
          startAngle: 270, endAngle: 270, minimum: 0, maximum: 100,
         radiusFactor: 0.8,
          axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: 0.15),
          annotations: <GaugeAnnotation>[GaugeAnnotation(angle: 180,
              widget:  Row(children: <Widget>[Container(
                child: Text('50', style: TextStyle(
                  fontFamily: 'Times',
                  fontSize: isTileView ? 18 : 22, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic
                ),),
              ),
                Container(child: Text(' / 100', style: TextStyle(
                fontFamily: 'Times',
                fontSize: isTileView ? 18 : 22, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic
                ),),)
              ],)),
          ],
          pointers:<GaugePointer>[RangePointer(value: 50,  cornerStyle: CornerStyle.bothCurve,
              enableAnimation: true, animationDuration: 1200, animationType: AnimationType.ease,
              sizeUnit: GaugeSizeUnit.factor,
                 gradient: const SweepGradient(
                  colors:<Color>[Color(0xFF6A6EF6), Color(0xFFDB82F5)],
                  stops: <double>[0.25, 0.75]
              ),
              color: const Color(0xFF00A8B5),  width: 0.15),
          ]
      ),
    ],
  );
}






