import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class ClockExample extends StatefulWidget {
  ClockExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _ClockExampleState createState() => _ClockExampleState(sample);
}

class _ClockExampleState extends State<ClockExample> {
  _ClockExampleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, ClockExampleFrontPanel(sample));
  }
}

class ClockExampleFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  ClockExampleFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _ClockExampleFrontPanelState createState() => _ClockExampleFrontPanelState(sampleList);
}

class _ClockExampleFrontPanelState extends State<ClockExampleFrontPanel> {
  _ClockExampleFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), updateData);
  }

  void updateData(Timer timer){
    final double _previousValue = _value;
    setState((){
      if(_previousValue >= 0 &&_previousValue < 12){
        _value = _value + 0.2;
      }
      else {

        _value = 0.2;
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
    setState((){
      _centerX = MediaQuery.of(context).orientation == Orientation.portrait ? 0.3 : 0.45;
    });
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(
                  child: getClockExample(false, isIndexed)),
            ),
          );
        });
  }


}

SfRadialGauge getClockExample(bool isTileView, [bool isIndexed]) {
  return SfRadialGauge(
    axes: <RadialAxis>[
      RadialAxis(
          startAngle: 270,
          endAngle: 270,
          radiusFactor: 0.2,
          axisLabelStyle: GaugeTextStyle(fontSize: 6),
          minimum: 0,
          maximum: 12,
          showFirstLabel: false,
          offsetUnit: GaugeSizeUnit.factor,
          interval: 2,
          centerY: 0.65,
          tickOffset: 0.03,
          minorTicksPerInterval: 5,
          labelOffset: 0.2,
          minorTickStyle: MinorTickStyle(
              length: 0.09, lengthUnit: GaugeSizeUnit.factor, thickness: 0.5),
          majorTickStyle: MajorTickStyle(
              length: 0.15, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
          axisLineStyle: AxisLineStyle(
              thickness: 0.03, thicknessUnit: GaugeSizeUnit.factor),
          pointers: <GaugePointer>[
            NeedlePointer(
              value: 5,
              needleLength: 0.7,
              lengthUnit: GaugeSizeUnit.factor,
              needleColor: const Color(0xFF00A8B5),
              needleStartWidth: 0.5,
              needleEndWidth: 1,
              knobStyle: KnobStyle(
                knobRadius: 0,
              ),
            )
          ]),
      RadialAxis(
          startAngle: 270,
          endAngle: 270,
          axisLabelStyle: GaugeTextStyle(
            fontSize: 6,
          ),
          radiusFactor: 0.2,
          labelOffset: 0.2,
          offsetUnit: GaugeSizeUnit.factor,
          minimum: 0,
          maximum: 12,
          showFirstLabel: false,
          interval: 2,
          centerX: isTileView ? 0.39 : _centerX,
          minorTicksPerInterval: 5,
          tickOffset: 0.03,
          minorTickStyle: MinorTickStyle(
              length: 0.09, lengthUnit: GaugeSizeUnit.factor, thickness: 0.5),
          majorTickStyle: MajorTickStyle(
            length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),
          pointers: <GaugePointer>[
            NeedlePointer(
              value: 8,
              needleLength: 0.7,
              lengthUnit: GaugeSizeUnit.factor,
              needleColor: const Color(0xFF00A8B5),
              needleStartWidth: 0.5,
              needleEndWidth: 1,
              knobStyle: KnobStyle(knobRadius: 0),
            )
          ]),
      RadialAxis(
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 12,
          showFirstLabel: false,
          interval: 1,
          radiusFactor: 0.95,
          labelOffset: 0.1,
          offsetUnit: GaugeSizeUnit.factor,
          minorTicksPerInterval: 4,
          tickOffset: 0.03,
          minorTickStyle: MinorTickStyle(
              length: 0.06, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
          majorTickStyle: MajorTickStyle(
              length: 0.1, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
          axisLabelStyle: GaugeTextStyle(fontSize: isTileView ? 12 : 14),
          axisLineStyle: AxisLineStyle(
              thickness: 0.01, thicknessUnit: GaugeSizeUnit.factor),
          pointers: <GaugePointer>[
            NeedlePointer(
                needleLength: 0.6,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 1,
                needleEndWidth: 2,
                value: 10,
                needleColor: _needleColor,
                knobStyle: KnobStyle(knobRadius: 0)),
            NeedlePointer(
                needleLength: 0.85,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 0.5,
                needleEndWidth: 1.5,
                value: 2,
                knobStyle: KnobStyle(
                    color: const Color(0xFF00A8B5),
                    sizeUnit: GaugeSizeUnit.factor,
                    knobRadius: 0.05),
                needleColor: _needleColor),
            NeedlePointer(
                needleLength: 0.9,
                lengthUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationType: AnimationType.bounceOut,
                needleStartWidth: 0.8,
                needleEndWidth: 0.8,
                value: _value,
                needleColor: const Color(0xFF00A8B5),
                tailStyle: TailStyle(
                    width: 0.8,
                    length: 0.2,
                    lengthUnit: GaugeSizeUnit.factor,
                    color: const Color(0xFF00A8B5)),
                knobStyle: KnobStyle(
                    knobRadius: 0.03,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.white)),
          ]),
    ],
  );
}

double _value = 0;
double _centerX = 0.3;
Color _needleColor = const Color(0xFF355C7D);
