import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// ignore: must_be_immutable
class RadialPointerDragging extends SampleView {
  const RadialPointerDragging(Key key) : super(key: key);

  @override
  _RadialPointerDraggingState createState() => _RadialPointerDraggingState();
}

class _RadialPointerDraggingState extends SampleViewState {
  _RadialPointerDraggingState();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 10;
      _annotationFontSize = 25;
      if (kIsWeb) {
        _width = _width * 0.35;
      }

    } else {
      _firstMarkerSize = kIsWeb ? 10 : 5;
      _annotationFontSize = kIsWeb ? 25: 15;
      _width = _width *  0.35;
    }

    return Scaffold(
        backgroundColor: model.isWeb ? Colors.transparent : model.cardThemeColor,
        body: isCardView
            ? getRadialPointerDragging(true)
            : Padding(
                padding: kIsWeb ? const EdgeInsets.fromLTRB(5, 20, 5, 20)
                    : const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 7, // takes 30% of available width
                      child: SfRadialGauge(axes: <RadialAxis>[
                        RadialAxis(
                            axisLineStyle: AxisLineStyle(
                                thickness: 0.2,
                                thicknessUnit: GaugeSizeUnit.factor),
                            showTicks: false,
                            showLabels: true,
                            onAxisTapped: onPointerValueChanged,
                            pointers: <GaugePointer>[
                              RangePointer(
                                  value: _currentValue,
                                  onValueChanged: onPointerValueChanged,
                                  onValueChangeEnd: onPointerValueChanged,
                                  onValueChanging: onPointerValueChanging,
                                  enableDragging: true,
                                  width: 0.2,
                                  sizeUnit: GaugeSizeUnit.factor),
                              MarkerPointer(
                                value: _markerValue,
                                color: Colors.white,
                                markerHeight: _firstMarkerSize,
                                markerWidth: _firstMarkerSize,
                                markerType: MarkerType.circle,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                     Text(
                                        '$_annotationValue',
                                        style: TextStyle(
                                            fontSize: _annotationFontSize,
                                            fontFamily: 'Times',
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF00A8B5)),
                                      ),
                                      Text(
                                        ' %',
                                        style: TextStyle(
                                            fontSize: _annotationFontSize,
                                            fontFamily: 'Times',
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF00A8B5)),
                                      )
                                    ],
                                  ),
                                  positionFactor: 0.13,
                                  angle: 0)
                            ])
                      ]),
                    ),
                    Expanded(
                        flex: kIsWeb ? 2 : 3, // takes 30% of available width
                        child: Container(
                          width: _width,
                          child: Slider(
                            activeColor: const Color(0xFF02AAB0),
                            inactiveColor: const Color(0xFF00CDAC),
                            min: 5,
                            max: 100,
                            onChanged: onPointerValueChanged,
                            value: _currentValue,
                          ),
                        )),
                  ],
                )));
  }

  void onPointerValueChanged(double value) {
    if (value.toInt() > 6) {
      setState(() {
        _currentValue = value.roundToDouble();
        final int _value = _currentValue.toInt();
        _annotationValue = '$_value';
        _markerValue = _currentValue - 2;
      });
    }
  }

  void onPointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() <= 6) {
      args.cancel = true;
    }
  }
}

Widget getRadialPointerDragging(bool isTileView) {
  return SfRadialGauge(axes: <RadialAxis>[
    RadialAxis(
        axisLineStyle:
            AxisLineStyle(thickness: 0.2, thicknessUnit: GaugeSizeUnit.factor),
        showTicks: false,
        showLabels: false,
        radiusFactor: 1,
        pointers: <GaugePointer>[
          RangePointer(value: 60, width: 0.2, sizeUnit: GaugeSizeUnit.factor),
          MarkerPointer(
            value: 58,
            color: Colors.white,
            markerHeight: 5,
            markerWidth: 5,
            markerType: MarkerType.circle,
          ),
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              widget: Row(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text(
                    '60',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A8B5)),
                  ),
                  Text(
                    ' %',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A8B5)),
                  )
                ],
              ),
              positionFactor: 0.13,
              angle: 0)
        ])
  ]);
}

double _currentValue = 60;
double _markerValue = 58;
double _firstMarkerSize = 10;
double _annotationFontSize = 25;
String _annotationValue = '60';
