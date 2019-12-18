import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class DistanceTrackerExample extends StatefulWidget {
  DistanceTrackerExample({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _DistanceTrackerExampleState createState() =>
      _DistanceTrackerExampleState(sample);
}

class _DistanceTrackerExampleState extends State<DistanceTrackerExample> {
  _DistanceTrackerExampleState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, DistanceTrackerExampleFrontPanel(sample));
  }
}

class DistanceTrackerExampleFrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  DistanceTrackerExampleFrontPanel(this.sampleList);
  final SubItem sampleList;

  @override
  _DistanceTrackerExampleFrontPanelState createState() => _DistanceTrackerExampleFrontPanelState(sampleList);
}

class _DistanceTrackerExampleFrontPanelState extends State<DistanceTrackerExampleFrontPanel> {
  _DistanceTrackerExampleFrontPanelState(this.sample);
  final SubItem sample;
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    setState((){
      if(MediaQuery.of(context).orientation == Orientation.portrait){
        _markerValue = 138;
      }else{
        _markerValue = 136;
      }
    });
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
            backgroundColor: model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
              child: Container(
                  child:  getDistanceTrackerExample(false, isIndexed)),
            ),
          );
        });
  }


}

SfRadialGauge getDistanceTrackerExample(bool isTileView, [bool isIndexed]) {
  return SfRadialGauge(
    enableLoadingAnimation: true,
    axes: <RadialAxis>[

      RadialAxis(showLabels: false, showTicks: false, radiusFactor: 0.8,
          minimum: 0, maximum: 240,
          axisLineStyle:AxisLineStyle(
              cornerStyle: CornerStyle.startCurve,
              thickness: 5),
          annotations: <GaugeAnnotation>[GaugeAnnotation(angle: 90, positionFactor: 0,
              widget: Column(children: <Widget>[ Text('142',
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic, fontSize: isTileView ? 20 : 30
                  )),
                Padding(padding: const EdgeInsets.fromLTRB(0,2,0,0),
                  child: Text('km/h',
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic, fontSize: isTileView ? 12 : 14
                    ),),
                )
              ],)
          ),
            GaugeAnnotation(angle: 124, positionFactor: 1.1, widget: Container(child: Text('0',
                style: TextStyle( fontSize: isTileView ? 12 : 14
                )),)),
            GaugeAnnotation(angle: 54, positionFactor: 1.1, widget: Container(child: Text('240',
                style: TextStyle( fontSize: isTileView ? 12 : 14
                )),)),
          ],
          pointers: <GaugePointer>[

            RangePointer(value: 142,
              width: 18, pointerOffset: -3,
              cornerStyle: CornerStyle.bothCurve,
              color: const Color(0xFFF67280),
              gradient: const SweepGradient(
                  colors: <Color>[Color(0xFFFF7676), Color(0xFFF54EA2)],
                  stops: <double>[0.25, 0.75]
              ),
            ),MarkerPointer(value: isTileView ? 136 : _markerValue,
                color: Colors.white, markerType: MarkerType.circle, ),
          ]
      ),


    ],
  );
}

double _markerValue = 138;