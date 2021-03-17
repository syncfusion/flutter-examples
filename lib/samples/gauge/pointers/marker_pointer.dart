/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge marker pointer sample
class MarkerPointerExample extends SampleView {
  /// Creates the gauge marker pointer sample
  const MarkerPointerExample(Key key) : super(key: key);

  @override
  _MarkerPointerExampleState createState() => _MarkerPointerExampleState();
}

class _MarkerPointerExampleState extends SampleViewState {
  _MarkerPointerExampleState();

  @override
  Widget build(BuildContext context) {
    return _getMarkerPointerExample();
  }

  /// Returns the marker pointer gauge
  SfRadialGauge _getMarkerPointerExample() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            startAngle: 180,
            endAngle: 360,
            radiusFactor: 0.9,
            canScaleToFit: true,
            interval: 10,
            showLabels: false,
            showAxisLine: false,
            pointers: <GaugePointer>[
              MarkerPointer(
                  value: 70,
                  markerWidth: 20,
                  markerHeight: 20,
                  color: const Color(0xFFF67280),
                  markerType: MarkerType.invertedTriangle,
                  markerOffset: -7)
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 175,
                  positionFactor: 0.8,
                  widget: Container(
                      child: Text('Min',
                          style: TextStyle(
                              fontSize: isCardView ? 12 : 16,
                              fontWeight: FontWeight.bold)))),
              GaugeAnnotation(
                  angle: 270,
                  positionFactor: 0.1,
                  widget: Container(
                      child: Text('70%',
                          style: TextStyle(
                              fontSize: isCardView ? 12 : 16,
                              fontWeight: FontWeight.bold)))),
              GaugeAnnotation(
                  angle: 5,
                  positionFactor: 0.8,
                  widget: Container(
                      child: Text('Max',
                          style: TextStyle(
                              fontSize: isCardView ? 12 : 16,
                              fontWeight: FontWeight.bold))))
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 100,
                sizeUnit: GaugeSizeUnit.factor,
                gradient: model.isWeb
                    ? null
                    : const SweepGradient(
                        colors: <Color>[Color(0xFFAB64F5), Color(0xFF62DBF6)],
                        stops: <double>[0.25, 0.75]),
                startWidth: 0.4,
                endWidth: 0.4,
                color: const Color(0xFF00A8B5),
              )
            ],
            showTicks: false),
      ],
    );
  }
}
