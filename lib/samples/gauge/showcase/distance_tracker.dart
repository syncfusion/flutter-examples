import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class DistanceTrackerExample extends SampleView {
  const DistanceTrackerExample(Key key) : super(key: key);
  
  @override
  _DistanceTrackerExampleState createState() =>
      _DistanceTrackerExampleState();
}

class _DistanceTrackerExampleState extends SampleViewState {
  _DistanceTrackerExampleState();

  @override
  Widget build(BuildContext context) {
    return DistanceTrackerExampleFrontPanel();
  }
}

class DistanceTrackerExampleFrontPanel extends SampleView {
  //ignore: prefer_const_constructors_in_immutables
  DistanceTrackerExampleFrontPanel();

  @override
  _DistanceTrackerExampleFrontPanelState createState() =>
      _DistanceTrackerExampleFrontPanelState();
}

class _DistanceTrackerExampleFrontPanelState
    extends SampleViewState {
  _DistanceTrackerExampleFrontPanelState();

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        _markerValue = 138;
      } else {
        _markerValue = kIsWeb ? 138: 136;
      }
    });
          return Scaffold(
            backgroundColor:  model.isWeb ? Colors.transparent : model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child:
                  getDistanceTrackerExample(),
            ),
          );
  }

SfRadialGauge getDistanceTrackerExample() {
  return SfRadialGauge(
    enableLoadingAnimation: true,
    axes: <RadialAxis>[
      RadialAxis(
          showLabels: false,
          showTicks: false,
          radiusFactor: 0.8,
          minimum: 0,
          maximum: 240,
          axisLineStyle:
              AxisLineStyle(cornerStyle: CornerStyle.startCurve, thickness: 5),
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 90,
                positionFactor: 0,
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('142',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: isCardView ? 20 : 30)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Text(
                        'km/h',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: isCardView ? 12 : 14),
                      ),
                    )
                  ],
                )),
            GaugeAnnotation(
                angle: 124,
                positionFactor: 1.1,
                widget: Container(
                  child: Text('0',
                      style: TextStyle(fontSize: isCardView ? 12 : 14)),
                )),
            GaugeAnnotation(
                angle: 54,
                positionFactor: 1.1,
                widget: Container(
                  child: Text('240',
                      style: TextStyle(fontSize: isCardView ? 12 : 14)),
                )),
          ],
          pointers: <GaugePointer>[
            RangePointer(
              value: 142,
              width: 18,
              pointerOffset: -3,
              cornerStyle: CornerStyle.bothCurve,
              color: const Color(0xFFF67280),
              gradient: kIsWeb
                  ? null
                  : const SweepGradient(
                      colors: <Color>[Color(0xFFFF7676), Color(0xFFF54EA2)],
                      stops: <double>[0.25, 0.75]),
            ),
            MarkerPointer(
              value: isCardView ? 136 : _markerValue,
              color: Colors.white,
              markerType: MarkerType.circle,
            ),
          ]),
    ],
  );
}

double _markerValue = 138;
}