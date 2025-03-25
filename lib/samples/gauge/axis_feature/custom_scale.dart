/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the non-linear label gauge sample
class RadialNonLinearLabel extends SampleView {
  /// Creates the non-linear label gauge sample
  const RadialNonLinearLabel(Key key) : super(key: key);

  @override
  _RadialNonLinearLabelState createState() => _RadialNonLinearLabelState();
}

class _RadialNonLinearLabelState extends SampleViewState {
  _RadialNonLinearLabelState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialNonLinearLabel();
  }

  /// Returns the non-linear axis label gauge
  SfRadialGauge _buildRadialNonLinearLabel() {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      key: model.isWebFullView ? UniqueKey() : null,
      animationDuration: 2500,
      axes: <RadialAxis>[
        RadialAxis(
          axisLineStyle: const AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: 0.15,
          ),
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          showTicks: false,
          showLastLabel: true,
          maximum: 150,
          axisLabelStyle: const GaugeTextStyle(),
          // Added custom axis renderer that extended from RadialAxisRenderer
          onCreateAxisRenderer: handleCreateAxisRenderer,
          pointers: <GaugePointer>[
            NeedlePointer(
              enableAnimation: true,
              gradient: const LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(203, 126, 223, 0),
                  Color(0xFFCB7EDF),
                ],
                stops: <double>[0.25, 0.75],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              animationType: AnimationType.easeOutBack,
              value: 60,
              animationDuration: 1300,
              needleStartWidth: isCardView ? 3 : 4,
              needleEndWidth: isCardView ? 6 : 8,
              needleLength: 0.8,
              knobStyle: const KnobStyle(knobRadius: 0),
            ),
            RangePointer(
              value: 60,
              width: 0.15,
              sizeUnit: GaugeSizeUnit.factor,
              color: _pointerColor,
              animationDuration: 1300,
              animationType: AnimationType.easeOutBack,
              gradient: const SweepGradient(
                colors: <Color>[Color(0xFF9E40DC), Color(0xFFE63B86)],
                stops: <double>[0.25, 0.75],
              ),
              enableAnimation: true,
            ),
          ],
        ),
      ],
    );
  }

  GaugeAxisRenderer handleCreateAxisRenderer() {
    final _CustomAxisRenderer customAxisRenderer = _CustomAxisRenderer();
    return customAxisRenderer;
  }

  final Color _pointerColor = const Color(0xFF494CA2);
}

class _CustomAxisRenderer extends RadialAxisRenderer {
  _CustomAxisRenderer() : super();

  /// Generated the 9 non-linear interval labels from 0 to 150
  /// instead of actual generated labels.
  @override
  List<CircularAxisLabel> generateVisibleLabels() {
    final List<CircularAxisLabel> visibleLabels = <CircularAxisLabel>[];
    for (num i = 0; i < 9; i++) {
      final double labelValue = _calculateLabelValue(i);
      final CircularAxisLabel label = CircularAxisLabel(
        axis.axisLabelStyle,
        labelValue.toInt().toString(),
        i,
        false,
      );
      label.value = labelValue;
      visibleLabels.add(label);
    }

    return visibleLabels;
  }

  /// Returns the factor(0 to 1) from value to place the labels in an axis.
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
