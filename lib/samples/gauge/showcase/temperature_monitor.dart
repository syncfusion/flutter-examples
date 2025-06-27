/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports

import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Locals imports
import '../../../model/sample_view.dart';

/// Renders the gauge temperature monitor sample.
class GaugeTemperatureMonitorExample extends SampleView {
  /// Creates the gauge temperature monitor sample.
  const GaugeTemperatureMonitorExample(Key key) : super(key: key);

  @override
  _GaugeTemperatureMonitorExampleState createState() =>
      _GaugeTemperatureMonitorExampleState();
}

class _GaugeTemperatureMonitorExampleState extends SampleViewState {
  _GaugeTemperatureMonitorExampleState();

  @override
  Widget build(BuildContext context) {
    setState(() {
      // change axis interval based on orientation for the UI that looks good.
      _interval = MediaQuery.of(context).orientation == Orientation.portrait
          ? 10
          : 20;
    });
    return _buildTemperatureMonitorExample();
  }

  /// Returns the gauge temperature monitor
  SfRadialGauge _buildTemperatureMonitorExample() {
    return SfRadialGauge(
      animationDuration: 3500,
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: -50,
          maximum: 150,
          interval: isCardView ? 20 : _interval,
          minorTicksPerInterval: 9,
          showAxisLine: false,
          radiusFactor: model.isWebFullView ? 0.8 : 0.9,
          labelOffset: 8,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: -50,
              endValue: 0,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(34, 144, 199, 0.75),
            ),
            GaugeRange(
              startValue: 0,
              endValue: 10,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(34, 195, 199, 0.75),
            ),
            GaugeRange(
              startValue: 10,
              endValue: 30,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(123, 199, 34, 0.75),
            ),
            GaugeRange(
              startValue: 30,
              endValue: 40,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(238, 193, 34, 0.75),
            ),
            GaugeRange(
              startValue: 40,
              endValue: 150,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(238, 79, 34, 0.65),
            ),
          ],
          annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.35,
              widget: Text(
                'Temp.°C',
                style: TextStyle(color: Color(0xFFF8B195), fontSize: 16),
              ),
            ),
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.8,
              widget: Text(
                '  22.5  ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: 22.5,
              needleStartWidth: isCardView ? 0 : 1,
              needleEndWidth: isCardView ? 5 : 8,
              animationType: AnimationType.easeOutBack,
              enableAnimation: true,
              animationDuration: 1200,
              knobStyle: KnobStyle(
                knobRadius: isCardView ? 0.06 : 0.09,
                borderColor: const Color(0xFFF8B195),
                color: Colors.white,
                borderWidth: isCardView ? 0.035 : 0.05,
              ),
              tailStyle: TailStyle(
                color: const Color(0xFFF8B195),
                width: isCardView ? 4 : 8,
                length: isCardView ? 0.15 : 0.2,
              ),
              needleColor: const Color(0xFFF8B195),
            ),
          ],
          axisLabelStyle: GaugeTextStyle(fontSize: isCardView ? 10 : 12),
          majorTickStyle: const MajorTickStyle(
            length: 0.25,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          minorTickStyle: const MinorTickStyle(
            length: 0.13,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  double _interval = 10;
}
