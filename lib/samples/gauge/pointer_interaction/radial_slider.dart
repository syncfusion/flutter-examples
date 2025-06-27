/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge with pointer dragging
class RadialSliderExample extends SampleView {
  /// Creates the gauge with pointer dragging
  const RadialSliderExample(Key key) : super(key: key);

  @override
  _RadialSliderExampleState createState() => _RadialSliderExampleState();
}

class _RadialSliderExampleState extends SampleViewState {
  _RadialSliderExampleState();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _firstMarkerSize = 10;
      _annotationFontSize = 25;
      if (model.isWebFullView) {
        width = width * 0.35;
      }
    } else {
      _firstMarkerSize = model.isWebFullView ? 10 : 5;
      _annotationFontSize = model.isWebFullView ? 25 : 15;
      width = width * 0.35;
    }

    return Scaffold(
      backgroundColor: model.isWebFullView
          ? Colors.transparent
          : model.sampleOutputCardColor,

      /// Added separate view for sample browser tile view and expanded view.
      /// In tile view, slider widget is removed.
      body: isCardView
          ? _buildRadialSliderExample(true)
          : Padding(
              padding: model.isWebFullView
                  ? const EdgeInsets.fromLTRB(5, 20, 5, 20)
                  : const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 7, // takes 70% of available height
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          axisLineStyle: const AxisLineStyle(
                            thickness: 0.2,
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          showTicks: false,
                          showLastLabel: true,
                          onAxisTapped: handlePointerValueChanged,
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: _currentValue,
                              color: model.primaryColor,
                              onValueChanged: handlePointerValueChanged,
                              onValueChangeEnd: handlePointerValueChanged,
                              onValueChanging: handlePointerValueChanging,
                              enableDragging: true,
                              width: 0.2,
                              sizeUnit: GaugeSizeUnit.factor,
                            ),
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
                              angle: 0,
                              widget: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    '$_annotationValue%',
                                    style: TextStyle(
                                      fontSize: _annotationFontSize,
                                      fontFamily: 'Times',
                                      fontWeight: FontWeight.bold,
                                      color: model.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: model.isWebFullView ? 2 : 3,
                    child: SizedBox(
                      width: width,
                      child: SfSlider(
                        activeColor: model.primaryColor,
                        inactiveColor: model.primaryColor.withValues(
                          alpha: 0.4,
                        ),
                        min: 5,
                        max: 100,
                        onChanged: handlePointerValueChanged,
                        value: _currentValue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handlePointerValueChanged(dynamic value) {
    if (value.toInt() > 6) {
      setState(() {
        _currentValue = value.roundToDouble();
        final int currentValue = _currentValue.toInt();
        _annotationValue = '$currentValue';
        _markerValue = _currentValue - 2;
      });
    }
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() <= 6) {
      args.cancel = true;
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleCardPointerValueChanged(double value) {
    if (value.toInt() > 6) {
      setState(() {
        _cardCurrentValue = value.roundToDouble();
        final int cardCurrentValue = _cardCurrentValue.toInt();
        _cardAnnotationValue = '$cardCurrentValue';
        _cardMarkerValue = _cardCurrentValue - 2;
      });
    }
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleCardPointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() <= 6) {
      args.cancel = true;
    }
  }

  /// Returns the radial slider gauge
  Widget _buildRadialSliderExample(bool isTileView) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          showTicks: false,
          showLabels: false,
          radiusFactor: 1,
          pointers: <GaugePointer>[
            RangePointer(
              width: 0.2,
              color: model.primaryColor,
              value: _cardCurrentValue,
              onValueChanged: handleCardPointerValueChanged,
              onValueChangeEnd: handleCardPointerValueChanged,
              onValueChanging: handleCardPointerValueChanging,
              enableDragging: true,
              sizeUnit: GaugeSizeUnit.factor,
            ),
            MarkerPointer(
              value: _cardMarkerValue,
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
                children: <Widget>[
                  Text(
                    _cardAnnotationValue,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      color: model.primaryColor,
                    ),
                  ),
                  Text(
                    '%',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Times',
                      fontWeight: FontWeight.bold,
                      color: model.primaryColor,
                    ),
                  ),
                ],
              ),
              positionFactor: 0.13,
              angle: 0,
            ),
          ],
        ),
      ],
    );
  }

  double _currentValue = 60;
  double _markerValue = 58;
  double _firstMarkerSize = 10;
  double _annotationFontSize = 25;
  String _annotationValue = '60';
  String _cardAnnotationValue = '60';
  double _cardCurrentValue = 60;
  double _cardMarkerValue = 58;
}
