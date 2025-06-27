/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge thermometer sample.
class Thermometer extends SampleView {
  /// Creates the linear gauge thermometer sample.
  const Thermometer(Key key) : super(key: key);

  @override
  _ThermometerState createState() => _ThermometerState();
}

/// State class of thermometer sample.
class _ThermometerState extends SampleViewState {
  double _meterValue = 35;
  final double _temperatureValue = 37.5;

  @override
  Widget build(BuildContext context) {
    return isWebOrDesktop
        ? Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width >= 1000 ? 550 : 440,
              height: 300,
              child: _buildThermometer(context),
            ),
          )
        : _buildThermometer(context);
  }

  /// Returns the thermometer.
  Widget _buildThermometer(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Brightness brightness = Theme.of(context).brightness;

    return Center(
      child: SizedBox(
        height: isCardView
            ? MediaQuery.of(context).size.height
            : orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height / 2
            : MediaQuery.of(context).size.height * 3 / 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Linear gauge to display celsius scale.
                SfLinearGauge(
                  minimum: -20,
                  maximum: 50,
                  interval: 10,
                  minorTicksPerInterval: 0,
                  axisTrackExtent: 23,
                  axisTrackStyle: LinearAxisTrackStyle(
                    thickness: 12,
                    color: model.sampleOutputCardColor,
                    borderWidth: 1,
                    edgeStyle: LinearEdgeStyle.bothCurve,
                  ),
                  tickPosition: LinearElementPosition.outside,
                  labelPosition: LinearLabelPosition.outside,
                  orientation: LinearGaugeOrientation.vertical,
                  markerPointers: <LinearMarkerPointer>[
                    LinearWidgetPointer(
                      markerAlignment: LinearMarkerAlignment.end,
                      value: 50,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      offset: 8,
                      child: SizedBox(
                        height: 30,
                        child: Text(
                          '°C',
                          style: TextStyle(
                            fontSize: isWebOrDesktop ? 14 : 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    LinearShapePointer(
                      value: -20,
                      markerAlignment: LinearMarkerAlignment.start,
                      shapeType: LinearShapePointerType.circle,
                      borderWidth: 1,
                      borderColor: brightness == Brightness.dark
                          ? Colors.white30
                          : Colors.black26,
                      color: model.sampleOutputCardColor,
                      position: LinearElementPosition.cross,
                      width: 24,
                      height: 24,
                    ),
                    LinearShapePointer(
                      value: -20,
                      markerAlignment: LinearMarkerAlignment.start,
                      shapeType: LinearShapePointerType.circle,
                      borderWidth: 6,
                      borderColor: Colors.transparent,
                      color: _meterValue > _temperatureValue
                          ? const Color(0xffFF7B7B)
                          : const Color(0xff0074E3),
                      position: LinearElementPosition.cross,
                      width: 24,
                      height: 24,
                    ),
                    LinearWidgetPointer(
                      value: -20,
                      markerAlignment: LinearMarkerAlignment.start,
                      child: Container(
                        width: 10,
                        height: 3.4,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 2.0,
                              color: model.sampleOutputCardColor,
                            ),
                            right: BorderSide(
                              width: 2.0,
                              color: model.sampleOutputCardColor,
                            ),
                          ),
                          color: _meterValue > _temperatureValue
                              ? const Color(0xffFF7B7B)
                              : const Color(0xff0074E3),
                        ),
                      ),
                    ),
                    LinearWidgetPointer(
                      value: _meterValue,
                      enableAnimation: false,
                      position: LinearElementPosition.outside,
                      onChanged: (dynamic value) {
                        setState(() {
                          _meterValue = value as double;
                        });
                      },
                      child: Container(
                        width: 16,
                        height: 12,
                        transform: Matrix4.translationValues(4, 0, 0.0),
                        child: Image.asset(
                          'images/triangle_pointer.png',
                          color: _meterValue > _temperatureValue
                              ? const Color(0xffFF7B7B)
                              : const Color(0xff0074E3),
                        ),
                      ),
                    ),
                    LinearShapePointer(
                      value: _meterValue,
                      width: 20,
                      height: 20,
                      enableAnimation: false,
                      color: Colors.transparent,
                      position: LinearElementPosition.cross,
                      onChanged: (dynamic value) {
                        setState(() {
                          _meterValue = value as double;
                        });
                      },
                    ),
                  ],
                  barPointers: <LinearBarPointer>[
                    LinearBarPointer(
                      value: _meterValue,
                      enableAnimation: false,
                      thickness: 6,
                      edgeStyle: LinearEdgeStyle.endCurve,
                      color: _meterValue > _temperatureValue
                          ? const Color(0xffFF7B7B)
                          : const Color(0xff0074E3),
                    ),
                  ],
                ),

                /// Linear gauge to display Fahrenheit  scale.
                Container(
                  transform: Matrix4.translationValues(-6, 0, 0.0),
                  child: SfLinearGauge(
                    maximum: 120,
                    showAxisTrack: false,
                    interval: 20,
                    minorTicksPerInterval: 0,
                    axisTrackExtent: 24,
                    axisTrackStyle: const LinearAxisTrackStyle(thickness: 0),
                    orientation: LinearGaugeOrientation.vertical,
                    markerPointers: <LinearMarkerPointer>[
                      LinearWidgetPointer(
                        markerAlignment: LinearMarkerAlignment.end,
                        value: 120,
                        position: LinearElementPosition.inside,
                        offset: 6,
                        enableAnimation: false,
                        child: SizedBox(
                          height: 30,
                          child: Text(
                            '°F',
                            style: TextStyle(
                              fontSize: isWebOrDesktop ? 14 : 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
