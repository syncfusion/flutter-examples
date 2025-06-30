///Dart imports
import 'dart:async';

/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the gauge axis default sample.
class WidgetPointerExample extends SampleView {
  /// Renders default radial gauge widget
  const WidgetPointerExample(Key key) : super(key: key);

  @override
  _WidgetPointerExampleState createState() => _WidgetPointerExampleState();
}

class _WidgetPointerExampleState extends SampleViewState {
  _WidgetPointerExampleState();

  late Timer _timer;
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return _buildWidgetPointerExample(context);
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (mounted) {
      _timer = Timer.periodic(const Duration(milliseconds: 20), (Timer timer) {
        _incrementPointerValue();
      });
    }
  }

  void _incrementPointerValue() {
    setState(() {
      if (_value == 60) {
        _timer.cancel();
      } else {
        _value++;
      }
    });
  }

  /// Returns the default axis gauge
  SfRadialGauge _buildWidgetPointerExample(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          interval: 10,
          labelOffset: 0.1,
          tickOffset: 0.125,
          minorTicksPerInterval: 0,
          labelsPosition: ElementsPosition.outside,
          offsetUnit: GaugeSizeUnit.factor,
          showAxisLine: false,
          showLastLabel: true,
          radiusFactor: model.isWebFullView ? 0.8 : 0.8,
          maximum: 120,
          pointers: <GaugePointer>[
            WidgetPointer(
              offset: isCardView ? -2.5 : -5,
              value: _value.toDouble(),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      model.themeData.colorScheme.brightness == Brightness.light
                      ? Colors.white
                      : const Color.fromRGBO(33, 33, 33, 1),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color:
                          model.themeData.colorScheme.brightness ==
                              Brightness.light
                          ? Colors.grey
                          : Colors.white.withValues(alpha: 0.2),
                      blurRadius: 4.0,
                    ),
                  ],
                  border: Border.all(
                    color:
                        model.themeData.colorScheme.brightness ==
                            Brightness.light
                        ? Colors.black.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                height: isCardView
                    ? 37
                    : MediaQuery.of(context).orientation ==
                          Orientation.landscape
                    ? 45
                    : 50,
                width: isCardView
                    ? 35
                    : MediaQuery.of(context).orientation ==
                          Orientation.landscape
                    ? 45
                    : 50,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      const Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                      Container(
                        width: isCardView
                            ? 14.00
                            : MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                            ? 20
                            : 20,
                        height: isCardView
                            ? 19.00
                            : MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                            ? 30
                            : 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage(
                              model.themeData.colorScheme.brightness ==
                                      Brightness.light
                                  ? 'images/temperature_indicator_light.png'
                                  : 'images/temperature_indicator_dark.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '$_value',
                          style: TextStyle(
                            color: const Color.fromRGBO(126, 126, 126, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: isCardView ? 10 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 40,
              color: const Color.fromRGBO(74, 177, 70, 1),
            ),
            GaugeRange(
              startValue: 40,
              endValue: 80,
              color: const Color.fromRGBO(251, 190, 32, 1),
            ),
            GaugeRange(
              startValue: 80,
              endValue: 120,
              color: const Color.fromRGBO(237, 34, 35, 1),
            ),
          ],
        ),
      ],
    );
  }
}
