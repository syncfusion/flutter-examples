/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Locals imports
import '../../../model/sample_view.dart';

/// Renders the gauge distance tracker sample.
class DistanceTrackerExample extends SampleView {
  /// Creates the gauge distance tracker sample.
  const DistanceTrackerExample(Key key) : super(key: key);

  @override
  _DistanceTrackerExampleState createState() => _DistanceTrackerExampleState();
}

class _DistanceTrackerExampleState extends SampleViewState {
  _DistanceTrackerExampleState();

  @override
  Widget build(BuildContext context) {
    setState(() {
      // change marker value based on orientation for the UI that looks good.

      _markerValue =
          (MediaQuery.of(context).orientation == Orientation.portrait)
          ? 138
          : model.isWebFullView
          ? 138
          : 136;
    });
    return _buildDistanceTrackerExample();
  }

  /// Returns the gauge distance tracker
  SfRadialGauge _buildDistanceTrackerExample() {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          showLabels: false,
          showTicks: false,
          radiusFactor: 0.8,
          maximum: 240,
          axisLineStyle: const AxisLineStyle(
            cornerStyle: CornerStyle.startCurve,
            thickness: 5,
          ),
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 90,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '142',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: isCardView ? 20 : 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      'km/h',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: isCardView ? 12 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GaugeAnnotation(
              angle: 124,
              positionFactor: 1.1,
              widget: Text(
                '0',
                style: TextStyle(fontSize: isCardView ? 12 : 14),
              ),
            ),
            GaugeAnnotation(
              angle: 54,
              positionFactor: 1.1,
              widget: Text(
                '240',
                style: TextStyle(fontSize: isCardView ? 12 : 14),
              ),
            ),
          ],
          pointers: <GaugePointer>[
            const RangePointer(
              value: 142,
              width: 18,
              pointerOffset: -6,
              cornerStyle: CornerStyle.bothCurve,
              color: Color(0xFFF67280),
              gradient: SweepGradient(
                colors: <Color>[Color(0xFFFF7676), Color(0xFFF54EA2)],
                stops: <double>[0.25, 0.75],
              ),
            ),
            MarkerPointer(
              value: isCardView ? 136 : _markerValue,
              color: Colors.white,
              markerType: MarkerType.circle,
            ),
          ],
        ),
      ],
    );
  }

  double _markerValue = 138;
}
