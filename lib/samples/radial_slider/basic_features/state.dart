///Package imports
import 'package:flutter/cupertino.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider state.
class RadialSliderStateTypes extends SampleView {
  /// Creates the RadialSlider state.
  const RadialSliderStateTypes(Key key) : super(key: key);

  @override
  _RadialSliderStateTypesState createState() => _RadialSliderStateTypesState();
}

class _RadialSliderStateTypesState extends SampleViewState {
  _RadialSliderStateTypesState();

  bool _enableDragging = true;
  double _value = 30;
  double _annotationFontSize = 20;
  String _annotationValue = '30';
  double _firstMarkerSize = 30;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 25;
      _annotationFontSize = 20;
    } else {
      _firstMarkerSize = model.isWebFullView ? 35 : 15;
      _annotationFontSize = model.isWebFullView ? 20 : 15;
    }

    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.8,
            axisLineStyle: AxisLineStyle(
              color: model.themeData.colorScheme.brightness == Brightness.light
                  ? const Color.fromRGBO(191, 214, 245, 1)
                  : const Color.fromRGBO(36, 58, 89, 1),
              thickness: model.isWebFullView ? 0.05 : 0.075,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            pointers: <GaugePointer>[
              RangePointer(
                width: model.isWebFullView ? 0.05 : 0.075,
                value: _value,
                cornerStyle: CornerStyle.bothCurve,
                color: _enableDragging
                    ? const Color.fromRGBO(44, 117, 220, 1)
                    : const Color(0xFF888888),
                sizeUnit: GaugeSizeUnit.factor,
              ),
              MarkerPointer(
                value: _value,
                onValueChanged: handlePointerValueChanged,
                onValueChangeEnd: handlePointerValueChanged,
                onValueChanging: handlePointerValueChanging,
                elevation: 5,
                enableDragging: _enableDragging,
                color: _enableDragging
                    ? const Color.fromRGBO(44, 117, 220, 1)
                    : const Color(0xFF888888),
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
                      _annotationValue,
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        // fontFamily: 'Times',
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        // fontFamily: 'Times',
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                angle: 90,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Enable drag', style: TextStyle(color: model.textColor)),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
              child: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeTrackColor: model.primaryColor,
                  value: _enableDragging,
                  onChanged: (bool value) {
                    setState(() {
                      _enableDragging = value;
                      stateSetter(() {});
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
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
        const double value = 100;
        _setPointerValue(value);
      }
    }
  }

  /// Method to set the pointer value
  void _setPointerValue(double value) {
    setState(() {
      _value = value;
      // ignore: no_leading_underscores_for_local_identifiers
      int _currentValue = _value.toInt();
      _currentValue = _currentValue >= 100 ? 100 : _currentValue;
      _annotationValue = '$_currentValue';
    });
  }
}
