///Package imports
import 'package:flutter/cupertino.dart';

///calendar import
import 'package:syncfusion_flutter_gauges/gauges.dart';

///Local import
import '../../../model/sample_view.dart';

/// Widget of the RadialSlider state.
class RadialRangeSliderStateTypes extends SampleView {
  /// Creates the RadialSlider state sample.
  const RadialRangeSliderStateTypes(Key key) : super(key: key);

  @override
  _RadialRangeSliderStateTypesState createState() =>
      _RadialRangeSliderStateTypesState();
}

class _RadialRangeSliderStateTypesState extends SampleViewState {
  _RadialRangeSliderStateTypesState();

  bool _enableDragging = true;
  double _secondMarkerValue = 30;
  double _firstMarkerValue = 0;
  double _markerSize = 30;
  final double _annotationFontSize = 25;
  String _annotationValue1 = '0';
  String _annotationValue2 = '30%';

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _markerSize = 35;
    } else {
      _markerSize = model.isWebFullView ? 35 : 25;
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
              thickness: 0.05,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: _secondMarkerValue,
                startValue: _firstMarkerValue,
                sizeUnit: GaugeSizeUnit.factor,
                color: _enableDragging
                    ? const Color.fromRGBO(44, 117, 220, 1)
                    : const Color(0xFF888888),
                endWidth: 0.05,
                startWidth: 0.05,
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: _firstMarkerValue,
                elevation: 5,
                onValueChanged: handleFirstPointerValueChanged,
                onValueChanging: handleFirstPointerValueChanging,
                enableDragging: _enableDragging,
                color: _enableDragging
                    ? const Color.fromRGBO(44, 117, 220, 1)
                    : const Color(0xFF888888),
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
              MarkerPointer(
                value: _secondMarkerValue,
                elevation: 5,
                onValueChanged: handleSecondPointerValueChanged,
                onValueChanging: handleSecondPointerValueChanging,
                enableDragging: _enableDragging,
                color: _enableDragging
                    ? const Color.fromRGBO(44, 117, 220, 1)
                    : const Color(0xFF888888),
                markerHeight: _markerSize,
                markerWidth: _markerSize,
                markerType: MarkerType.circle,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '$_annotationValue1 - $_annotationValue2',
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0), //as you need
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
  void handleSecondPointerValueChanged(double markerValue) {
    setState(() {
      _secondMarkerValue = markerValue;
      final int value = _secondMarkerValue.abs().toInt();
      _annotationValue2 = '$value%';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleFirstPointerValueChanged(double markerValue) {
    setState(() {
      _firstMarkerValue = markerValue;
      final int value = _firstMarkerValue.abs().toInt();
      _annotationValue1 = '$value';
    });
  }

  /// Value changeing call back for first pointer
  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }
}
