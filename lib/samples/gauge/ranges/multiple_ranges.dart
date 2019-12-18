import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class MultipleRangesExample extends StatefulWidget {
   MultipleRangesExample({this.sample, Key key}) : super(key: key);
   SubItem sample;

  @override
  _MultipleRangesExampleState createState() => _MultipleRangesExampleState(sample);
}

class _MultipleRangesExampleState extends State<MultipleRangesExample> {
  _MultipleRangesExampleState(this.sample);
  final SubItem sample;
  

  @override
  Widget build(BuildContext context) {
   return getScopedModel(getMultipleRangesExampleGauge(false), sample);
  }
}



Widget getMultipleRangesExampleGauge(bool isTileView) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(showAxisLine: false,
          showLabels: false,
          showTicks: false,
          startAngle: 180,
          endAngle: 360,
          minimum: 0,
          maximum: 80,
          centerY: 0.7,
          radiusFactor: 0.95,
          pointers: <GaugePointer>[
            NeedlePointer(needleStartWidth: 1,
                value: 30,
                needleEndWidth: isTileView ? 5 : MediaQuery.of(context).orientation
                    == Orientation.portrait ?  10 :  6,
                needleLength: 0.7,
                lengthUnit: GaugeSizeUnit.factor,
                knobStyle: KnobStyle(
                  knobRadius: 0.08, sizeUnit: GaugeSizeUnit.factor,
                ))
          ],
          ranges: <GaugeRange>[
            GaugeRange(startValue: 0,
                endValue: 18,
                sizeUnit: GaugeSizeUnit.factor,
                startWidth: 0,
                endWidth: 0.1,
                color: const Color(0xFFA8AAE2)),
            GaugeRange(startValue: 20,
                endValue: 38,
                startWidth: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.15,
                color: const Color.fromRGBO(168, 170, 226, 1)),
            GaugeRange(startValue: 40,
                endValue: 58,
                startWidth: 0.15,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.2,
                color: const Color(0xFF7B7DC7)),
            GaugeRange(startValue: 60,
                endValue: 78,
                startWidth: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.25,
                color: const Color.fromRGBO(73, 76, 162, 1)),
          ]
      ),

    ],
  );
});
}







