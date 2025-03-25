/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports

import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Locals imports
import '../../../model/sample_view.dart';

/// Renders the gauge compass sample.
class GaugeCompassExample extends SampleView {
  /// Creates the gauge compass sample.
  const GaugeCompassExample(Key key) : super(key: key);

  @override
  _GaugeCompassExampleState createState() => _GaugeCompassExampleState();
}

class _GaugeCompassExampleState extends SampleViewState {
  _GaugeCompassExampleState();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _annotationTextSize = 22;
      _markerOffset = 0.71;
      _markerHeight = 10;
      _markerWidth = 15;
      _labelFontSize = 11;
    } else {
      _annotationTextSize = model.isWebFullView ? 22 : 16;
      _markerOffset = model.isWebFullView ? 0.71 : 0.69;
      _markerHeight = model.isWebFullView ? 10 : 5;
      _markerWidth = model.isWebFullView ? 15 : 10;
      _labelFontSize = model.isWebFullView ? 11 : 10;
    }
    final Widget widget = SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          showAxisLine: false,
          radiusFactor: 1,
          canRotateLabels: true,
          tickOffset: 0.32,
          offsetUnit: GaugeSizeUnit.factor,
          onLabelCreated: _handleAxisLabelCreated,
          startAngle: 270,
          endAngle: 270,
          labelOffset: 0.05,
          maximum: 360,
          interval: 30,
          minorTicksPerInterval: 4,
          axisLabelStyle: GaugeTextStyle(
            color: const Color(0xFF949494),
            fontSize: isCardView ? 10 : _labelFontSize,
          ),
          minorTickStyle: const MinorTickStyle(
            color: Color(0xFF616161),
            thickness: 1.6,
            length: 0.058,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          majorTickStyle: const MajorTickStyle(
            color: Color(0xFF949494),
            thickness: 2.3,
            length: 0.087,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          backgroundImage: const AssetImage('images/dark_theme_gauge.png'),
          pointers: <GaugePointer>[
            MarkerPointer(
              value: 90,
              color: const Color(0xFFDF5F2D),
              enableAnimation: true,
              animationDuration: 1200,
              markerOffset: isCardView ? 0.69 : _markerOffset,
              offsetUnit: GaugeSizeUnit.factor,
              markerType: MarkerType.triangle,
              markerHeight: isCardView ? 8 : _markerHeight,
              markerWidth: isCardView ? 8 : _markerWidth,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 270,
              widget: Text(
                '90',
                style: TextStyle(
                  color: const Color(0xFFDF5F2D),
                  fontWeight: FontWeight.bold,
                  fontSize: isCardView ? 16 : _annotationTextSize,
                ),
              ),
            ),
          ],
        ),
      ],
    );
    if (model.isWebFullView) {
      return Padding(padding: const EdgeInsets.all(35), child: widget);
    } else {
      return widget;
    }
  }

  /// Handled callback for change numeric value to compass directional letter.
  void _handleAxisLabelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '90') {
      args.text = 'E';
      args.labelStyle = GaugeTextStyle(
        color: const Color(0xFFDF5F2D),
        fontSize: isCardView ? 10 : _labelFontSize,
      );
    } else if (args.text == '360') {
      args.text = '';
    } else {
      if (args.text == '0') {
        args.text = 'N';
      } else if (args.text == '180') {
        args.text = 'S';
      } else if (args.text == '270') {
        args.text = 'W';
      }

      args.labelStyle = GaugeTextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: isCardView ? 10 : _labelFontSize,
      );
    }
  }

  double _annotationTextSize = 22;
  double _markerHeight = 10;
  double _markerWidth = 15;
  double _markerOffset = 0.71;
  double _labelFontSize = 10;
}
