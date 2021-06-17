/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';

/// Renders the linear gauge volume settings showcase sample.
class VolumeSettings extends SampleView {
  /// Creates the linear gauge volume settings showcase sample.
  const VolumeSettings(Key key) : super(key: key);

  @override
  _VolumeSettingsState createState() => _VolumeSettingsState();
}

/// State class of volume settings sample.
class _VolumeSettingsState extends SampleViewState {
  _VolumeSettingsState();
  double _musicValue = 100.0;
  double _ringValue = 85.0;
  double _alarmValue = 65.0;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return isCardView
        ? _buildVolumeControl()
        : Center(
            child: Container(
            height: orientation == Orientation.landscape
                ? MediaQuery.of(context).size.height / 2
                : MediaQuery.of(context).size.height / 3,
            child: _buildVolumeControl(),
          ));
  }

  /// Returns the volume settings.
  Widget _buildVolumeControl() {
    final Brightness _brightness = Theme.of(context).brightness;

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
        height: isCardView ? 205 : 240,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: SfLinearGauge(
              orientation: LinearGaugeOrientation.vertical,
              interval: 20.0,
              showTicks: false,
              showLabels: false,
              minorTicksPerInterval: 0,
              axisTrackStyle: LinearAxisTrackStyle(
                thickness: 40,
                edgeStyle: LinearEdgeStyle.bothCurve,
                borderWidth: 1,
                borderColor: _brightness == Brightness.dark
                    ? const Color(0xff898989)
                    : Colors.grey[350],
                color: _brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.grey[350],
              ),
              barPointers: <LinearBarPointer>[
                LinearBarPointer(
                    enableAnimation: false,
                    value: _musicValue,
                    thickness: 40,
                    edgeStyle: LinearEdgeStyle.bothCurve,
                    color: Colors.blueAccent)
              ],
              markerPointers: <LinearMarkerPointer>[
                LinearWidgetPointer(
                    enableAnimation: false,
                    markerAlignment: LinearMarkerAlignment.end,
                    value: 100,
                    child: Container(
                      height: 25,
                      child: Text(_musicValue.toStringAsFixed(0) + '%'),
                    )),
                LinearWidgetPointer(
                  value: 5,
                  enableAnimation: false,
                  markerAlignment: LinearMarkerAlignment.end,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _musicValue = 0;
                        });
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                              child: Icon(
                            _musicValue > 0
                                ? Icons.music_note
                                : Icons.music_off,
                            color: const Color(0xffFFFFFF),
                          )))),
                ),
                LinearShapePointer(
                    enableAnimation: false,
                    value: _musicValue - 20,
                    onValueChanged: (dynamic value) {
                      setState(() {
                        _musicValue = value as double;
                      });
                    },
                    color: Colors.transparent,
                    width: 40,
                    markerAlignment: LinearMarkerAlignment.end,
                    position: LinearElementPosition.cross,
                    shapeType: LinearShapePointerType.circle,
                    height: 40),
              ],
            )),
      ),
      const SizedBox(
        width: 25,
      ),
      Container(
          height: isCardView ? 205 : 240,
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: SfLinearGauge(
                  orientation: LinearGaugeOrientation.vertical,
                  interval: 20.0,
                  showTicks: false,
                  showLabels: false,
                  minorTicksPerInterval: 0,
                  axisTrackStyle: LinearAxisTrackStyle(
                    thickness: 40,
                    edgeStyle: LinearEdgeStyle.bothCurve,
                    borderWidth: 1,
                    borderColor: _brightness == Brightness.dark
                        ? const Color(0xff898989)
                        : Colors.grey[350],
                    color: _brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.grey[350],
                  ),
                  barPointers: <LinearBarPointer>[
                    LinearBarPointer(
                        enableAnimation: false,
                        value: _ringValue,
                        thickness: 40,
                        edgeStyle: LinearEdgeStyle.bothCurve,
                        color: Colors.blueAccent)
                  ],
                  markerPointers: <LinearMarkerPointer>[
                    LinearWidgetPointer(
                      value: 5,
                      enableAnimation: false,
                      markerAlignment: LinearMarkerAlignment.end,
                      child: Container(
                          height: 30,
                          width: 30,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _ringValue = 0;
                                });
                              },
                              child: Center(
                                  child: Icon(
                                _ringValue > 0
                                    ? Icons.notifications
                                    : Icons.notifications_off,
                                color: const Color(0xffFFFFFF),
                              )))),
                    ),
                    LinearWidgetPointer(
                        markerAlignment: LinearMarkerAlignment.end,
                        value: 100,
                        enableAnimation: false,
                        child: Container(
                          height: 25,
                          child: Text(_ringValue.toStringAsFixed(0) + '%'),
                        )),
                    LinearShapePointer(
                        value: _ringValue - 20,
                        enableAnimation: false,
                        onValueChanged: (dynamic value) {
                          setState(() {
                            _ringValue = value as double;
                          });
                        },
                        color: Colors.transparent,
                        width: 40,
                        position: LinearElementPosition.cross,
                        shapeType: LinearShapePointerType.circle,
                        markerAlignment: LinearMarkerAlignment.end,
                        height: 40),
                  ]))),
      const SizedBox(
        width: 25,
      ),
      Container(
          height: isCardView ? 205 : 240,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: SfLinearGauge(
                orientation: LinearGaugeOrientation.vertical,
                interval: 20.0,
                showTicks: false,
                showLabels: false,
                minorTicksPerInterval: 0,
                axisTrackStyle: LinearAxisTrackStyle(
                  thickness: 40,
                  edgeStyle: LinearEdgeStyle.bothCurve,
                  borderWidth: 1,
                  borderColor: _brightness == Brightness.dark
                      ? const Color(0xff898989)
                      : Colors.grey[350],
                  color: _brightness == Brightness.dark
                      ? Colors.transparent
                      : Colors.grey[350],
                ),
                barPointers: <LinearBarPointer>[
                  LinearBarPointer(
                      enableAnimation: false,
                      value: _alarmValue,
                      thickness: 40,
                      edgeStyle: LinearEdgeStyle.bothCurve,
                      color: Colors.blueAccent)
                ],
                markerPointers: <LinearMarkerPointer>[
                  LinearWidgetPointer(
                      enableAnimation: false,
                      markerAlignment: LinearMarkerAlignment.end,
                      value: 100,
                      child: Container(
                        height: 25,
                        child: Text(_alarmValue.toStringAsFixed(0) + '%'),
                      )),
                  LinearWidgetPointer(
                    value: 5,
                    enableAnimation: false,
                    markerAlignment: LinearMarkerAlignment.end,
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _alarmValue = 0;
                          });
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            child: Center(
                                child: Icon(
                              _alarmValue > 0
                                  ? Icons.access_alarm
                                  : Icons.alarm_off,
                              color: const Color(0xffFFFFFF),
                            )))),
                  ),
                  LinearShapePointer(
                      value: _alarmValue - 20,
                      enableAnimation: false,
                      onValueChanged: (dynamic value) {
                        setState(() {
                          _alarmValue = value as double;
                        });
                      },
                      color: Colors.transparent,
                      width: 40,
                      position: LinearElementPosition.cross,
                      shapeType: LinearShapePointerType.circle,
                      markerAlignment: LinearMarkerAlignment.end,
                      height: 40),
                ]),
          ))
    ]);
  }
}
