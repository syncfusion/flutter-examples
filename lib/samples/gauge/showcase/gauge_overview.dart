import 'package:flutter_examples/model/sample_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GaugeOverviewExample extends SampleView {
  const GaugeOverviewExample(Key key) : super(key: key);
  
  @override
  _GaugeOverviewExampleState createState() =>
      _GaugeOverviewExampleState();
}

class _GaugeOverviewExampleState extends SampleViewState {
  _GaugeOverviewExampleState();

  @override
  Widget build(BuildContext context) {
    return GaugeOverviewFrontPanel();
  }
}

class GaugeOverviewFrontPanel extends SampleView {
  //ignore: prefer_const_constructors_in_immutables
  GaugeOverviewFrontPanel();

  @override
  _GaugeOverviewFrontPanelState createState() =>
      _GaugeOverviewFrontPanelState();
}

class _GaugeOverviewFrontPanelState extends SampleViewState {
  _GaugeOverviewFrontPanelState();
  bool isIndexed = true;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _interval =
          MediaQuery.of(context).orientation == Orientation.portrait ? 10 : 20;
    });
          return Scaffold(
            backgroundColor:  model.isWeb ? Colors.transparent : model.cardThemeColor,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child:
                  Container(child: getGaugeOverviewExample(isIndexed)),
            ),
          );
  }

SfRadialGauge getGaugeOverviewExample(bool isIndexed) {
  return SfRadialGauge(
    animationDuration: 3500,
    enableLoadingAnimation: true,
    axes: <RadialAxis>[
      RadialAxis(
          startAngle: 130,
          endAngle: 50,
          minimum: -50,
          maximum: 150,
          interval: isCardView ? 20 : _interval,
          minorTicksPerInterval: 9,
          showAxisLine: false,
          radiusFactor: kIsWeb ? 0.8 : 0.9,
          labelOffset: 8,
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: -50,
                endValue: 0,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(34, 144, 199, 0.75)),
            GaugeRange(
                startValue: 0,
                endValue: 10,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(34, 195, 199, 0.75)),
            GaugeRange(
                startValue: 10,
                endValue: 30,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(123, 199, 34, 0.75)),
            GaugeRange(
                startValue: 30,
                endValue: 40,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(238, 193, 34, 0.75)),
            GaugeRange(
                startValue: 40,
                endValue: 150,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: const Color.fromRGBO(238, 79, 34, 0.65)),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 90,
                positionFactor: 0.35,
                widget: Container(
                    child: const Text('Temp.°C',
                        style: TextStyle(
                            color: Color(0xFFF8B195), fontSize: 16)))),
            GaugeAnnotation(
                angle: 90,
                positionFactor: 0.8,
                widget: Container(
                  child: const Text(
                    '  22.5  ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ))
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: 22.5,
              needleLength: 0.6,
              lengthUnit: GaugeSizeUnit.factor,
              needleStartWidth: isCardView ? 0 : 1,
              needleEndWidth: isCardView ? 5 : 8,
              animationType: AnimationType.easeOutBack,
              enableAnimation: true,
              animationDuration: 1200,
              knobStyle: KnobStyle(
                  knobRadius: isCardView ? 0.06 : 0.09,
                  sizeUnit: GaugeSizeUnit.factor,
                  borderColor: const Color(0xFFF8B195),
                  color: Colors.white,
                  borderWidth: isCardView ? 0.035 : 0.05),
              tailStyle: TailStyle(
                  color: const Color(0xFFF8B195),
                  width: isCardView ? 4 : 8,
                  lengthUnit: GaugeSizeUnit.factor,
                  length: isCardView ? 0.15 : 0.2),
              needleColor: const Color(0xFFF8B195),
            )
          ],
          axisLabelStyle: GaugeTextStyle(fontSize: isCardView ? 10 : 12),
          majorTickStyle: MajorTickStyle(
              length: 0.25, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
          minorTickStyle: MinorTickStyle(
              length: 0.13, lengthUnit: GaugeSizeUnit.factor, thickness: 1))
    ],
  );
}

double _interval = 10;
}