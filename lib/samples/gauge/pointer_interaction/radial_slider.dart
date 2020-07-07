import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RadialSlider extends StatefulWidget {
  RadialSlider({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialSliderState createState() => _RadialSliderState(sample);
}

class _RadialSliderState extends State<RadialSlider> {
  _RadialSliderState(this.sample);
  final SubItem sample;
  bool panelOpen;
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(RadialSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return getScopedModel(null, sample, RadialSliderFrontPanel(sample));
  }
}

class RadialSliderFrontPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  RadialSliderFrontPanel([this.subItemList]);
  final SubItem subItemList;

  @override
  _RadialSliderFrontPanelState createState() =>
      _RadialSliderFrontPanelState(subItemList);
}

class _RadialSliderFrontPanelState extends State<RadialSliderFrontPanel> {
  _RadialSliderFrontPanelState(this.sample);
  final SubItem sample;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _markerSize = 20;
      _annotationFontSize = 25;
      _thickness = 0.06;
      _borderWidth = 5;
    } else {
      _markerSize = 18;
      _annotationFontSize = 15;
      _thickness = 0.1;
      _borderWidth = 4;
    }
    return ScopedModelDescendant<SampleModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, SampleModel model) {
          return Scaffold(
              backgroundColor:
                  model.isWeb ? Colors.transparent : model.cardThemeColor,
              body: Padding(
                padding: kIsWeb
                    ? const EdgeInsets.fromLTRB(5, 20, 5, 20)
                    : const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(
                      axisLineStyle: AxisLineStyle(
                          thickness: _thickness,
                          thicknessUnit: GaugeSizeUnit.factor),
                      radiusFactor: kIsWeb ? 0.8 : 0.95,
                      minorTicksPerInterval: 4,
                      showFirstLabel: false,
                      minimum: 0,
                      maximum: 12,
                      interval: 1,
                      startAngle: 270,
                      endAngle: 270,
                      pointers: <GaugePointer>[
                        MarkerPointer(
                          value: _firstMarkerValue,
                          onValueChanged: onFirstPointerValueChanged,
                          onValueChanging: onFirstPointerValueChanging,
                          enableDragging: true,
                          borderColor: const Color(0xFFFFCD60),
                          borderWidth: _borderWidth,
                          color: Colors.white,
                          markerHeight: _markerSize,
                          markerWidth: _markerSize,
                          markerType: MarkerType.circle,
                        ),
                        MarkerPointer(
                          value: _secondMarkerValue,
                          onValueChanged: onSecondPointerValueChanged,
                          onValueChanging: onSecondPointerValueChanging,
                          color: Colors.white,
                          enableDragging: true,
                          borderColor: const Color(0xFFFFCD60),
                          markerHeight: _markerSize,
                          borderWidth: _borderWidth,
                          markerWidth: _markerSize,
                          markerType: MarkerType.circle,
                        ),
                      ],
                      ranges: <GaugeRange>[
                        GaugeRange(
                            endValue: _secondMarkerValue,
                            sizeUnit: GaugeSizeUnit.factor,
                            startValue: _firstMarkerValue,
                            startWidth: _thickness,
                            endWidth: _thickness)
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Row(
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
                                  ' hr',
                                  style: TextStyle(
                                      fontSize: _annotationFontSize,
                                      fontFamily: 'Times',
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00A8B5)),
                                ),
                                Text(
                                  ' $_minutesValue',
                                  style: TextStyle(
                                      fontSize: _annotationFontSize,
                                      fontFamily: 'Times',
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00A8B5)),
                                ),
                                Text(
                                  'm',
                                  style: TextStyle(
                                      fontSize: _annotationFontSize,
                                      fontFamily: 'Times',
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00A8B5)),
                                )
                              ],
                            ),
                            positionFactor: 0.1,
                            angle: 0)
                      ])
                ]),
              ));
        });
  }

  void onFirstPointerValueChanged(double value) {
    setState(() {
      _firstMarkerValue = value;
      final int _value = (_firstMarkerValue - _secondMarkerValue).abs().toInt();
      final String _hourValue = '$_value';
      _annotationValue = _hourValue.length == 1 ? '0' + _hourValue : _hourValue;
      _calculateMinutes(_value);
    });
  }

  void onFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 1) {
      if (args.value >= _secondMarkerValue) {
        if ((args.value - _firstMarkerValue).abs() > 1) {
          args.cancel = true;
        } else {
          _firstMarkerValue = _secondMarkerValue;
          _secondMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  void onSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 1) {
      if (args.value <= _firstMarkerValue) {
        if ((args.value - _secondMarkerValue).abs() > 1) {
          args.cancel = true;
        } else {
          _secondMarkerValue = _firstMarkerValue;
          _firstMarkerValue = args.value;
        }
      } else {
        args.cancel = true;
      }
    }
  }

  void onSecondPointerValueChanged(double value) {
    setState(() {
      _secondMarkerValue = value;
      final int _value = (_firstMarkerValue - _secondMarkerValue).abs().toInt();
      final String _hourValue = '$_value';
      _annotationValue = _hourValue.length == 1 ? '0' + _hourValue : _hourValue;
      _calculateMinutes(_value);
    });
  }

  void _calculateMinutes(int _value) {
    final double _minutes =
        (_firstMarkerValue - _secondMarkerValue).abs() - _value;
    final List<String> _minsList = _minutes.toStringAsFixed(2).split('.');
    double _currentMinutes = double.parse(_minsList[1]);
    _currentMinutes =
        _currentMinutes > 60 ? _currentMinutes - 60 : _currentMinutes;
    final String _actualValue = _currentMinutes.toInt().toString();
    _minutesValue =
        _actualValue.length == 1 ? '0' + _actualValue : _actualValue;
  }
}

class BackPanel extends StatefulWidget {
  //ignore:prefer_const_constructors_in_immutables
  BackPanel(this.sample);
  final SubItem sample;

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  _BackPanelState(this.sample);
  final SubItem sample;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  void _afterLayout(dynamic _) {
    _getSizesAndPosition();
  }

  void _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final Size size = renderBoxRed.size;
    final Offset position = renderBoxRed.localToGlobal(Offset.zero);
    const double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, SampleModel model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                Padding(
                  key: _globalKey,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    sample.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget getRadialSlider(bool isTileView) {
  return SfRadialGauge(axes: <RadialAxis>[
    RadialAxis(
        axisLineStyle:
            AxisLineStyle(thickness: 0.06, thicknessUnit: GaugeSizeUnit.factor),
        minorTicksPerInterval: 4,
        showFirstLabel: false,
        minimum: 0,
        maximum: 12,
        interval: 1,
        startAngle: 270,
        endAngle: 270,
        pointers: <GaugePointer>[
          MarkerPointer(
            value: 2,
            borderColor: const Color(0xFFFFCD60),
            borderWidth: 3,
            color: Colors.white,
            markerHeight: 15,
            markerWidth: 15,
            markerType: MarkerType.circle,
          ),
          MarkerPointer(
            value: 8,
            color: Colors.white,
            borderColor: const Color(0xFFFFCD60),
            markerHeight: 15,
            borderWidth: 3,
            markerWidth: 15,
            markerType: MarkerType.circle,
          ),
        ],
        ranges: <GaugeRange>[
          GaugeRange(
              endValue: _secondMarkerValue,
              sizeUnit: GaugeSizeUnit.factor,
              startValue: _firstMarkerValue,
              startWidth: 0.06,
              endWidth: 0.06)
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              widget: const Text(
                '6 hr 40 m',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Times',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A8B5)),
              ),
              positionFactor: 0.05,
              angle: 0)
        ])
  ]);
}

double _borderWidth = 5;
double _firstMarkerValue = 2;
double _secondMarkerValue = 8;
double _markerSize = 25;
double _annotationFontSize = 25;
double _thickness = 0.06;
String _annotationValue = '6';
String _minutesValue = '40';
