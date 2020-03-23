import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class TrackColorCustomizedRangeSlider extends StatefulWidget {
  @override
  _TrackColorCustomizedRangeSliderState createState() =>
      _TrackColorCustomizedRangeSliderState();
}

class _TrackColorCustomizedRangeSliderState
    extends State<TrackColorCustomizedRangeSlider> {
  final double _min = 0.0;
  final double _max = 6.0;
  final Color _activeColor = const Color.fromRGBO(255, 125, 30, 1);
  final Color _inactiveTickColor = const Color.fromRGBO(200, 200, 200, 1);
  SfRangeValues _values = const SfRangeValues(2.0, 4.0);

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        inactiveTickColor: _inactiveTickColor,
        activeTickColor: _activeColor,
        inactiveMinorTickColor: _inactiveTickColor,
        activeMinorTickColor: _activeColor,
        inactiveTrackColor: const Color.fromRGBO(194, 194, 194, 0.5)
      ),
      child: SfRangeSlider(
        min: _min,
        max: _max,
        values: _values,
        onChanged: (SfRangeValues values) {
          setState(() {
            _values = values;
          });
        },
        interval: 1,
        minorTicksPerInterval: 3,
        showTicks: true,
        activeColor: _activeColor,
      ),
    );
  }
}
