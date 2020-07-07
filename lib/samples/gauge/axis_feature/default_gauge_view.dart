import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RadialGaugeDefault extends SampleView {
  const RadialGaugeDefault(Key key) : super(key: key);
  
  @override
  _RadialGaugeDefaultState createState() => _RadialGaugeDefaultState();
}

class _RadialGaugeDefaultState extends SampleViewState {
  _RadialGaugeDefaultState();
  
  @override
  Widget build(BuildContext context) {
    return getDefaultRadialGauge();
  }

SfRadialGauge getDefaultRadialGauge() {
  return SfRadialGauge(
    enableLoadingAnimation: true,
    axes: <RadialAxis>[
      RadialAxis(
          interval: 10,
          axisLineStyle: AxisLineStyle(
            thickness: 0.03,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          showTicks: false,
          axisLabelStyle: GaugeTextStyle(
            fontSize: isCardView ? 12 : 14,
          ),
          labelOffset: 25,
          radiusFactor: kIsWeb ? 0.8 : 0.95,
          pointers: <GaugePointer>[
            NeedlePointer(
                needleLength: 0.7,
                value: 70,
                lengthUnit: GaugeSizeUnit.factor,
                needleColor: _needleColor,
                needleStartWidth: 0,
                needleEndWidth: isCardView ? 3 : 4,
                knobStyle: KnobStyle(
                    sizeUnit: GaugeSizeUnit.factor,
                    color: _needleColor,
                    knobRadius: 0.05)),
          ])
    ],
  );
}

final Color _needleColor = const Color(0xFFC06C84);
}