// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge height calculator sample.
class HeightCalculator extends SampleView {
  /// Creates the linear gauge height calculator sample.
  const HeightCalculator(Key key) : super(key: key);

  @override
  _HeightCalculatorState createState() => _HeightCalculatorState();
}

class _HeightCalculatorState extends SampleViewState {
  _HeightCalculatorState();
  double _pointerValue = 130;
  double minimumLevel = 0;
  double maximumLevel = 200;

  @override
  Widget build(BuildContext context) {
    return isWebOrDesktop
        ? Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
              height: 500,
              child: _buildHeightCalculator(context),
            ),
          )
        : _buildHeightCalculator(context);
  }

  /// Returns the height calculator.
  Widget _buildHeightCalculator(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Container(
          height: isCardView
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 3 / 4,
          padding: const EdgeInsets.all(5.0),
          child: SfLinearGauge(
            orientation: LinearGaugeOrientation.vertical,
            maximum: maximumLevel,
            tickPosition: LinearElementPosition.outside,
            labelPosition: LinearLabelPosition.outside,
            minorTicksPerInterval: 0,
            interval: isCardView ? 50 : 25,
            onGenerateLabels: () {
              return isCardView
                  ? <LinearAxisLabel>[
                      const LinearAxisLabel(text: '0 cm', value: 0),
                      const LinearAxisLabel(text: '50 cm', value: 50),
                      const LinearAxisLabel(text: '100 cm', value: 100),
                      const LinearAxisLabel(text: '150 cm', value: 150),
                      const LinearAxisLabel(text: '200 cm', value: 200),
                    ]
                  : <LinearAxisLabel>[
                      const LinearAxisLabel(text: '0 cm', value: 0),
                      const LinearAxisLabel(text: '25 cm', value: 25),
                      const LinearAxisLabel(text: '50 cm', value: 50),
                      const LinearAxisLabel(text: '75 cm', value: 75),
                      const LinearAxisLabel(text: '100 cm', value: 100),
                      const LinearAxisLabel(text: '125 cm', value: 125),
                      const LinearAxisLabel(text: '150 cm', value: 150),
                      const LinearAxisLabel(text: '175 cm', value: 175),
                      const LinearAxisLabel(text: '200 cm', value: 200),
                    ];
            },
            axisTrackStyle: const LinearAxisTrackStyle(),
            markerPointers: <LinearMarkerPointer>[
              LinearShapePointer(
                value: _pointerValue,
                enableAnimation: false,
                onChanged: (dynamic value) {
                  setState(() {
                    _pointerValue = value as double;
                  });
                },
                shapeType: LinearShapePointerType.rectangle,
                color: const Color(0xff0074E3),
                height: 1.5,
                width: isCardView ? 150 : 250,
              ),
              LinearWidgetPointer(
                value: _pointerValue,
                enableAnimation: false,
                onChanged: (dynamic value) {
                  setState(() {
                    _pointerValue = value as double;
                  });
                },
                child: SizedBox(
                  width: 24,
                  height: 16,
                  child: Image.asset('images/rectangle_pointer.png'),
                ),
              ),
              LinearWidgetPointer(
                value: _pointerValue,
                enableAnimation: false,
                onChanged: (dynamic value) {
                  setState(() {
                    _pointerValue = value as double;
                  });
                },
                offset: isCardView ? 150 : 230,
                position: LinearElementPosition.outside,
                child: Container(
                  width: 60,
                  height: 25,
                  decoration: BoxDecoration(
                    color: model.homeCardColor,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: brightness == Brightness.light
                            ? Colors.grey
                            : Colors.black54,
                        offset: const Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      _pointerValue.toStringAsFixed(0) + ' cm',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Color(0xff0074E3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            ranges: <LinearGaugeRange>[
              LinearGaugeRange(
                endValue: _pointerValue,
                startWidth: 200,
                midWidth: isCardView ? 200 : 300,
                endWidth: 200,
                color: Colors.transparent,
                child: Image.asset(
                  brightness == Brightness.light
                      ? 'images/bmi_light.png'
                      : 'images/bmi_dark.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
