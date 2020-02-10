import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

import '../../../model/helper.dart';
import '../../../model/model.dart';

// ignore: must_be_immutable
class RadialNonLinearLabel extends StatefulWidget {
  RadialNonLinearLabel({this.sample, Key key}) : super(key: key);
  SubItem sample;

  @override
  _RadialNonLinearLabelState createState() =>
      _RadialNonLinearLabelState(sample);
}

class _RadialNonLinearLabelState extends State<RadialNonLinearLabel> {
  _RadialNonLinearLabelState(this.sample);
  final SubItem sample;

  @override
  Widget build(BuildContext context) {
    return getScopedModel(getRadialNonLinearLabel(false), sample);
  }
}

SfRadialGauge getRadialNonLinearLabel(bool isTileView) {
  return SfRadialGauge(enableLoadingAnimation : true,
    animationDuration: 2500,
    axes: <RadialAxis>[
      CustomAxis(
          labelOffset: 15,
          axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15),
          radiusFactor: 0.9,
          minimum: 0,
          showTicks: false,
          maximum: 150,
          axisLabelStyle: GaugeTextStyle(fontSize: 12),
          pointers: <GaugePointer>[
            NeedlePointer(
                enableAnimation: true,
                gradient: LinearGradient(
                    colors: const <Color>[Color.fromRGBO(203,126,223,0.1), Color(0xFFCB7EDF)],
                    stops: const <double>[0.25, 0.75],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
                animationType: AnimationType.easeOutBack,
                value: 60,
                lengthUnit: GaugeSizeUnit.factor,
                animationDuration: 1300,
                needleStartWidth: isTileView ? 3 : 4,
                needleEndWidth: isTileView ? 6 : 8,
                needleLength: 0.8,
                knobStyle: KnobStyle(
                  knobRadius: 0,
                )),
            RangePointer(
                value: 60,
                width: 0.15,
                sizeUnit: GaugeSizeUnit.factor,
                color: _pointerColor,
                animationDuration: 1300,
                animationType: AnimationType.easeOutBack,
                gradient: const SweepGradient(
                    colors: <Color>[Color(0xFF9E40DC), Color(0xFFE63B86)],
                    stops: <double>[0.25, 0.75]),
                enableAnimation: true)
          ])
    ],
  );
}

Color _pointerColor = const Color(0xFF494CA2);

class CustomAxis extends RadialAxis {
  CustomAxis({
    double radiusFactor = 1,
    List<GaugePointer> pointers,
    GaugeTextStyle axisLabelStyle,
    AxisLineStyle axisLineStyle,
    double minimum,
    double maximum,
    bool showTicks,
    double labelOffset,
  }) : super(
          pointers: pointers ?? <GaugePointer>[],
          minimum: minimum,
          maximum: maximum,
          showTicks: showTicks ?? true,
          labelOffset: labelOffset ?? 20,
          axisLabelStyle: axisLabelStyle ??
              GaugeTextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontFamily: 'Segoe UI',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal),
          axisLineStyle: axisLineStyle ??
              AxisLineStyle(
                color: Colors.grey,
                thickness: 10,
              ),
          radiusFactor: radiusFactor,
        );

  @override
  List<CircularAxisLabel> generateVisibleLabels() {
    final List<CircularAxisLabel> _visibleLabels = <CircularAxisLabel>[];
    for (num i = 0; i < 9; i++) {
      final double _value = _calculateLabelValue(i);
      final CircularAxisLabel label = CircularAxisLabel(
          axisLabelStyle, _value.toInt().toString(), i, false);
      label.value = _value;
      _visibleLabels.add(label);
    }

    return _visibleLabels;
  }

  @override
  double valueToFactor(double value) {
    if (value >= 0 && value <= 2) {
      return (value * 0.125) / 2;
    } else if (value > 2 && value <= 5) {
      return (((value - 2) * 0.125) / (5 - 2)) + (1 * 0.125);
    } else if (value > 5 && value <= 10) {
      return (((value - 5) * 0.125) / (10 - 5)) + (2 * 0.125);
    } else if (value > 10 && value <= 20) {
      return (((value - 10) * 0.125) / (20 - 10)) + (3 * 0.125);
    } else if (value > 20 && value <= 30) {
      return (((value - 20) * 0.125) / (30 - 20)) + (4 * 0.125);
    } else if (value > 30 && value <= 50) {
      return (((value - 30) * 0.125) / (50 - 30)) + (5 * 0.125);
    } else if (value > 50 && value <= 100) {
      return (((value - 50) * 0.125) / (100 - 50)) + (6 * 0.125);
    } else if (value > 100 && value <= 150) {
      return (((value - 100) * 0.125) / (150 - 100)) + (7 * 0.125);
    } else {
      return 1;
    }
  }

  /// To return the label value based on interval
  double _calculateLabelValue(num value) {
    if (value == 0) {
      return 0;
    } else if (value == 1) {
      return 2;
    } else if (value == 2) {
      return 5;
    } else if (value == 3) {
      return 10;
    } else if (value == 4) {
      return 20;
    } else if (value == 5) {
      return 30;
    } else if (value == 6) {
      return 50;
    } else if (value == 7) {
      return 100;
    } else {
      return 150;
    }
  }
}
