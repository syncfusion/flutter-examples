/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge pointer ease animation sample
class RadialEaseExample extends SampleView {
  /// Creates gauge with ease animation
  const RadialEaseExample(Key key) : super(key: key);

  @override
  _RadialEaseExampleState createState() => _RadialEaseExampleState();
}

class _RadialEaseExampleState extends SampleViewState {
  _RadialEaseExampleState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialEaseExample();
  }

  /// Return the gauge pointer ease animation gauge
  SfRadialGauge _buildRadialEaseExample() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 0,
          endAngle: 360,
          showLabels: false,
          showTicks: false,
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          axisLineStyle: AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: isCardView ? 0.07 : 0.1,
          ),
        ),
        RadialAxis(
          startAngle: 170,
          endAngle: 170,
          showTicks: false,
          labelFormat: '{value}M',
          onLabelCreated: _handleLabelCreated,
          showAxisLine: false,
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          maximum: 15,
          axisLabelStyle: GaugeTextStyle(
            fontSize: isCardView ? 10 : 12,
            fontWeight: FontWeight.w500,
          ),
          labelOffset: 25,
          interval: isCardView ? 1 : _interval,
          canRotateLabels: true,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              positionFactor: 1,
              axisValue: 0,
              widget: Container(
                height: isCardView ? 30 : 45,
                width: isCardView ? 30 : 45,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('images/shotput.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            const GaugeAnnotation(
              widget: Text('Distance', style: TextStyle(fontSize: 20)),
            ),
          ],
          pointers: <GaugePointer>[
            const RangePointer(
              value: 11.5,
              width: 0.1,
              color: Color(0xFFF67280),
              enableAnimation: true,
              sizeUnit: GaugeSizeUnit.factor,
              gradient: SweepGradient(
                colors: <Color>[Color(0xFFFFB397), Color(0xFFF46AA0)],
                stops: <double>[0.25, 0.75],
              ),
            ),
            MarkerPointer(
              value: 11.5,
              markerType: MarkerType.image,
              enableAnimation: true,
              imageUrl: 'images/ball_progressbar.png',
              markerHeight: isCardView
                  ? 30
                  : model.isWebFullView
                  ? 45
                  : 40,
              markerOffset: 4,
              markerWidth: isCardView
                  ? 30
                  : model.isWebFullView
                  ? 45
                  : 40,
            ),
          ],
        ),
      ],
    );
  }

  /// Handled callback to hide last label value.
  void _handleLabelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '15M') {
      args.text = '';
    }
  }

  final double _interval = 1;
}
