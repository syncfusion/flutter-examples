/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge multiple axis sample
class MultipleAxisExample extends SampleView {
  /// Creates the gauge multiple axis sample
  const MultipleAxisExample(Key key) : super(key: key);

  @override
  _MultipleAxisExampleState createState() => _MultipleAxisExampleState();
}

class _MultipleAxisExampleState extends SampleViewState {
  _MultipleAxisExampleState();

  @override
  Widget build(BuildContext context) {
    return _buildRadialGauge(context);
  }

  /// Returns the default axis gauge
  SfRadialGauge _buildRadialGauge(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
        minimum: 32,
        maximum: 212,
        interval: 36,
        radiusFactor: MediaQuery.of(context).orientation == Orientation.portrait
            ? isCardView
                ? 0.5
                : 0.6
            : 0.5,
        labelOffset: 15,
        canRotateLabels: true,
        minorTickStyle: const MinorTickStyle(
            color: Color(0xFF00A8B5),
            thickness: 1.5,
            lengthUnit: GaugeSizeUnit.factor,
            length: 0.07),
        majorTickStyle: const MajorTickStyle(
            color: Color(0xFF00A8B5),
            thickness: 1.5,
            lengthUnit: GaugeSizeUnit.factor,
            length: 0.15),
        axisLineStyle: const AxisLineStyle(
          color: Color(0xFF00A8B5),
          thickness: 3,
        ),
        axisLabelStyle:
            const GaugeTextStyle(color: Color(0xFF00A8B5), fontSize: 12),
      ),
      RadialAxis(
          minimum: 0,
          maximum: 100,
          interval: 10,
          ticksPosition: ElementsPosition.outside,
          labelsPosition: ElementsPosition.outside,
          minorTicksPerInterval: 5,
          radiusFactor: 0.95,
          labelOffset: 15,
          minorTickStyle: const MinorTickStyle(
              thickness: 1.5, length: 0.07, lengthUnit: GaugeSizeUnit.factor),
          majorTickStyle: const MinorTickStyle(
            thickness: 1.5,
            length: 0.15,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          axisLineStyle: const AxisLineStyle(
            thickness: 3,
          ),
          axisLabelStyle: const GaugeTextStyle(fontSize: 12),
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 90,
                positionFactor: 1,
                widget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        child: const Text(
                      '33°C  :',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times'),
                    )),
                    Container(
                        child: const Text(
                      ' 91.4°F',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF00A8B5),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times'),
                    ))
                  ],
                ))
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              needleLength: 0.68,
              lengthUnit: GaugeSizeUnit.factor,
              needleStartWidth: 0,
              needleEndWidth: 3,
              value: 33,
              enableAnimation: true,
              knobStyle: const KnobStyle(
                  knobRadius: 6.5, sizeUnit: GaugeSizeUnit.logicalPixel),
            )
          ]),
    ]);
  }
}
