///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider state.
class RadialSliderStateTypes extends SampleView {
  const RadialSliderStateTypes(Key key) : super(key: key);

  @override
  _RadialSliderStateTypesState createState() => _RadialSliderStateTypesState();
}

class _RadialSliderStateTypesState extends SampleViewState {
  _RadialSliderStateTypesState();

  bool _enableDragging = true;
  double _value = 30;
  double _markerValue = 28.75;
  double _annotationFontSize = 25;
  String _annotationValue = '30';
  double _firstMarkerSize = 30;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 30;
      _annotationFontSize = 25;
    } else {
      _firstMarkerSize = model.isWeb ? 22 : 20;
      _firstMarkerSize = model.isWeb ? 20 : 20;
      _annotationFontSize = model.isWeb ? 25 : 15;
    }

    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              radiusFactor: 0.8,
              axisLineStyle: AxisLineStyle(
                  thickness: model.isWeb ? 0.15 : 0.25,
                  thicknessUnit: GaugeSizeUnit.factor),
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              pointers: <GaugePointer>[
                RangePointer(
                    width: model.isWeb ? 0.15 : 0.25,
                    value: _value,
                    enableDragging: _enableDragging,
                    cornerStyle: CornerStyle.bothCurve,
                    onValueChanged: handlePointerValueChanged,
                    onValueChangeEnd: handlePointerValueChanged,
                    onValueChanging: handlePointerValueChanging,
                    color: _enableDragging
                        ? const Color.fromRGBO(34, 144, 199, 1)
                        : const Color(0xFF888888),
                    sizeUnit: GaugeSizeUnit.factor),
                MarkerPointer(
                  value: _markerValue,
                  color: Colors.white,
                  markerHeight: _firstMarkerSize,
                  markerWidth: _firstMarkerSize,
                  markerType: MarkerType.circle,
                )
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
                          ),
                        ),
                        Text(
                          '%',
                          style: TextStyle(
                            fontSize: _annotationFontSize,
                            fontFamily: 'Times',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    positionFactor: 0.13,
                    angle: 90)
              ])
        ],
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(children: <Widget>[
        Text('Enable Drag', style: TextStyle(color: model.textColor)),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                activeColor: model.backgroundColor,
                value: _enableDragging,
                onChanged: (bool value) {
                  setState(() {
                    _enableDragging = value;
                    stateSetter(() {});
                  });
                },
              )),
        ),
      ]);
    });
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handlePointerValueChanged(double value) {
    _setPointerValue(value);
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if ((args.value.toInt() - _value).abs() > 20) {
      args.cancel = true;
      if (_value > 50) {
        final double value = 100;
        _setPointerValue(value);
      }
    }
  }

  /// Method to set the pointer value
  void _setPointerValue(double value) {
    setState(() {
      _value = value;
      _markerValue = value - 1.75;
      int _currentValue = _value.toInt();
      _currentValue = _currentValue >= 100 ? 100 : _currentValue;
      _annotationValue = '$_currentValue';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
