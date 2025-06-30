/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Local imports
import '../../../model/sample_view.dart';
import '../utils.dart';

/// Renders the linear gauge active hours showcase sample.
class ActiveHours extends SampleView {
  /// Creates the linear gauge active showcase sample.
  const ActiveHours(Key key) : super(key: key);

  @override
  _ActiveHoursState createState() => _ActiveHoursState();
}

/// State class of active hours showcase sample.
class _ActiveHoursState extends SampleViewState {
  _ActiveHoursState();

  late List<double> _inActiveHours;

  @override
  void dispose() {
    _inActiveHours.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isWebOrDesktop
        ? Container(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width >= 450
                  ? 450
                  : MediaQuery.of(context).size.width * 0.45,
              child: _buildActiveHours(context),
            ),
          )
        : _buildActiveHours(context);
  }

  @override
  void initState() {
    ///Store the inactive hours in the list
    _inActiveHours = <double>[
      00.00,
      01.00,
      02.00,
      03.00,
      04.00,
      06.00,
      11.00,
      12.00,
      13.00,
      18.00,
      21.00,
    ];

    super.initState();
  }

  ///Return the active hours
  Widget _buildActiveHours(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SfLinearGauge(
              showTicks: false,
              interval: 30,
              labelOffset: 0,
              axisTrackStyle: const LinearAxisTrackStyle(
                thickness: 75,
                color: Colors.transparent,
              ),
              labelFormatterCallback: (String label) {
                switch (label) {
                  case '0':
                    return '00:00';
                  case '30':
                    return '06:00';
                  case '60':
                    return '12:00';
                  case '90':
                    return '18:00';
                  case '100':
                    return ' ';
                }
                return label;
              },
              markerPointers: List<LinearWidgetPointer>.generate(
                24,
                (int index) => _buildLinearWidgetPointer(
                  index * 4,
                  _inActiveHours.contains(index)
                      ? _getInActivePointerColor(
                          const Color(0xFF05C3DD),
                          0.7,
                          brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                        )
                      : const Color(0xFF05C3DD),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const Text(
                    'Active Hours',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(
                    (24 - _inActiveHours.length).toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      color: Color(0xFF05C3DD),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Get the color for inactive hour widget pointer
  Color _getInActivePointerColor(
    Color color,
    double factor, [
    Color mix = Colors.black,
  ]) {
    return color == Colors.transparent
        ? color
        : Color.fromRGBO(
            ((1 - factor) * (color.r * 255) + factor * (mix.r * 255)).toInt(),
            ((1 - factor) * (color.g * 255) + factor * (mix.g * 255)).toInt(),
            ((1 - factor) * (color.b * 255) + factor * (mix.b * 255)).toInt(),
            1,
          );
  }

  ///Create Linear widget pointer
  LinearWidgetPointer _buildLinearWidgetPointer(double value, Color color) {
    return LinearWidgetPointer(
      value: value,
      enableAnimation: false,
      child: Container(
        height: 75,
        width: 11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
      ),
    );
  }
}
